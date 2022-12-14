#include "sleeper.h"

#include <atomic>

#include "black_list.h"
#include "logger.h"
#include "permission_mgr.h"
#include "room.h"
#include "traffic_recorder.h"
#include "violation_detector.h"
#include "wheat_command.h"
#include "config.h"
#include "report_recorder.h"

namespace wheat
{

Sleeper::Sleeper(Room& room, socket sock, std::shared_ptr<ContentFilter> content_filter)
    : m_room(room)
    , m_id(MakeSleeperId())
    , m_sock(std::move(sock))
    , m_ip(m_sock.remote_endpoint().address().to_v4())
    , m_timer(m_sock.get_executor())
    , m_content_filter(std::move(content_filter))
{
    m_timer.expires_at(std::chrono::steady_clock::time_point::max());
    LOG_INFO("new sleeper, sleeper_id:%lld, remote_ip:%s", m_id, GetIp().c_str());
}

//加入房间，启动一个收消息的协程，一个发消息的协程 
void Sleeper::Start()
{
    //记录连接、开始观察 
    IPTrafficRecorder::Instance().OnConnection(m_ip);
    ViolationDetector::Instance().AddObserver("ip", GetIp(),
        [this, weak_ref = weak_from_this()](std::string reason)
        {
		    auto ref = weak_ref.lock();
			if (!ref) return;

            auto ip_str = GetIp();
            LOG_WARN("OnViolation, sleeper_id:%lld, ip:%s, reason:%s",
                m_id, ip_str.c_str(), reason.c_str());
            //加入黑名单 
            blacklist::BlackList::Instance().AddIpToBlockList(ip_str);

            Stop();
        });

    if (!m_room.Join(m_id, shared_from_this()))
    {
        LOG_INFO("%s, Join failed, so disconnect socket, sleeper_id:%lld, ip:%s", 
            __func__, m_id, GetIp().c_str());
        Stop();
    }
    else
    {
        //todo 到时候需要根据客户端传过来的字段确定是否有管理员权限 
        m_is_administrator = PermissionMgr::Instance().IsAdministrator("");
        asio::co_spawn(m_sock.get_executor(),
            [self = shared_from_this()]{ return self->Reader(); },
            asio::detached);

        asio::co_spawn(m_sock.get_executor(),
            [self = shared_from_this()]{ return self->Writer(); },
            asio::detached);
    }
}

std::string Sleeper::GetIp() const
{
    return m_ip.to_string();
}

void Sleeper::Deliver(std::string msg)
{
    m_write_msgs.emplace_back(std::move(msg));
    m_timer.cancel_one();
}

std::string Sleeper::MakeSelfInfo() const
{
    std::string info;
    auto make_cmd_str = [this](const WheatCommand& cmd) { return PackCommandWithId(m_id, cmd); };

    info += make_cmd_str(CmdSleeper{ m_id });
    info += make_cmd_str(CmdName{ m_name });
    info += make_cmd_str(CmdType{ m_sex });

    if (m_bed_id != -1)
    {
        info += make_cmd_str(CmdSleep{ m_bed_id });
    }
    else
    {
        info += make_cmd_str(CmdPos{ m_pos });
    }
    return info;
}

bool Sleeper::EliminateBadWord(std::string& msg) const noexcept
{
    bool modified = false;
    while (true)
    {
        bool is_modified = m_content_filter->FilterContent(msg, '*'); // currently use '*'
        if (!is_modified)
        {
            break;
        }
        modified = true;
    }
    return modified;
}

void Sleeper::SyncDeliver(const std::string& msg)
{
    asio::write(m_sock, asio::buffer(msg));
}

asio::awaitable<void> Sleeper::Reader()
{
    try
    {
        //循环读取数据
        std::string buffer;
        while (true)
        {
            auto n = co_await asio::async_read_until(m_sock,
                asio::dynamic_buffer(buffer, 512), '\0', asio::use_awaitable);
            IPTrafficRecorder::Instance().OnData(m_ip, n * 8);

            try
            {
                std::string_view msg(buffer.data(), n);
                LOG_DEBUG("%s, sleeper_id:%lld, on commad:%s", __func__, m_id, msg.data());

                //部分消息不需要(或者处理失败时不需要)转发 
                bool forward = true;

                WheatCommand msgCommand = ParseCommand(msg);
                WheatCommand replayMsgCommand;

                std::visit(
                overloaded{
                    [this, &forward](CmdSleep cmd) {
                        if (m_room.Sleep(m_id, cmd.bed_id))
                            m_bed_id = cmd.bed_id;
                        else
                            forward = false;
                    },
                    [this](CmdGetup) { m_room.GetUp(m_id); },
                    [this, &forward, &replayMsgCommand](CmdName cmd) { 
                        m_name = std::move(cmd.name); 
                        LOG_INFO("sleeper:%lld's name is:%s", m_id, m_name.c_str());
                        // bool modified = EliminateBadWord(m_name);
                        bool modified = ! m_content_filter->CheckContent(m_name);
                        if(modified) {
                            forward = false;
                            replayMsgCommand = CmdError{ WheatErrorCode::InvalidName };
                            // LOG_INFO("sleeper:%lld's name after modified is:%s", m_id, m_name.c_str());
                            LOG_INFO("sleeper:%lld's name %s include bad word", m_id, m_name.c_str());
                        }
                    },
                    [this](CmdType cmd) { 
                        // m_sex = std::move(cmd.sex); 
                        m_sex = cmd.sex;
                        LOG_INFO("sleeper:%lld's sex is:%d", m_id, m_sex);
                    },
                    [this](CmdChat& cmd) { 
                        LOG_INFO("sleeper:%lld say:%s", m_id, cmd.msg.c_str());
                        // auto t1 = std::chrono::steady_clock::now();
                        bool modified = EliminateBadWord(cmd.msg);
                        // auto t2 = std::chrono::steady_clock::now();
                        // double dr_ms = std::chrono::duration<double, std::milli>(t2 - t1).count();
                        // LOG_INFO("time: %lf ms.", dr_ms);
                        if (modified)
                        {
                            LOG_INFO("sleeper:%lld after modified say:%s", m_id, cmd.msg.c_str());
                        }
                    },
                    [this](CmdPos cmd) { m_pos = cmd.pos; },
                    [this](CmdMove cmd) { m_pos = cmd.pos; },
                    [this, &forward](CmdVoteKickStart cmd) { 
                        if (m_is_administrator)
                        {
                            auto timenow = std::chrono::steady_clock::now();
                            auto nowVoteTimeRate = std::chrono::duration_cast<std::chrono::seconds>(timenow - m_lastVoteTime).count();
                            if(nowVoteTimeRate > Config::Instance().vote_kick_ratetime_s) {
                                LOG_INFO("sleeper:%lld sent VoteKickStart.", m_id);
                                if(m_room.VoteKickStart(cmd.kick_id) == false)
                                    forward = false;
                                else
                                    m_lastVoteTime = std::chrono::steady_clock::now();
                            } else {
                                forward = false;
                                LOG_INFO("but too close to the last time");
                            }
                        }
                        else
                        {
                            LOG_ERROR("OnVoteKickStart, sleeper:%lld has no permisson", m_id);
                        }
                    },
                    [this, &forward](CmdVoteAgree) { m_room.Agree(m_id); forward = false; },
                    [this, &forward](CmdVoteRefuse) { m_room.Refuse(m_id); forward = false; },
                    [this, &forward, &replayMsgCommand](CmdPackGuid cmd) {
                        m_receivedPackGuid = true;
                        forward = false;
                        if(cmd.guid != m_room.m_packGuid) {
                            replayMsgCommand = CmdError{ WheatErrorCode::InvalidScene };
                            LOG_INFO("sleeper:%lld's cloudpack's guid %s does not match the server", m_id, cmd.guid.c_str());
                        }
                    },
                    [this](CmdEmote) {  }, // 嗯，表情消息应该没啥要处理的，不过还是留个位置好了
                    [this, &forward](CmdReport cmd) {
                        forward = false;
                        LOG_REPORT("sleeper:%lld report: %s", m_id, cmd.reportContent.c_str());
                        Deliver(PackCommandWithId(m_id, CmdReport{ "0" }));
                    },
                    [this, &forward](CmdPriChat cmd) {
                        forward = false;

                        cmd.src_id = m_id;
                        LOG_INFO("sleeper:%lld prichat %lld,: %s", cmd.src_id, cmd.dest_id, cmd.msg.c_str());

                        if(m_room.IsSleeperInRoom(cmd.dest_id) == false) {
                            return;
                        }
                        
                        bool modified = EliminateBadWord(cmd.msg);
                        if (modified)
                        {
                            LOG_INFO("sleeper:%lld prichat %lld after modified:%s", cmd.src_id, cmd.dest_id, cmd.msg.c_str());
                        }

                        std::string _replyMsgTemp = PackCommandWithId(cmd.src_id, cmd);
                        m_room.DeliverTo(cmd.dest_id, _replyMsgTemp);
                        m_room.DeliverTo(cmd.src_id, _replyMsgTemp);
                    },
                    [](auto&&) { }
                }, 
                msgCommand);

                if (std::holds_alternative<CmdError>(replayMsgCommand))
                {
                    // Send back error message, stop socket, then break out
                    SyncDeliver(PackCommandWithId(m_id, replayMsgCommand));
                    Stop();
                    break;
                }

                if (forward)
                {
                    m_room.Deliver(PackCommandWithId(m_id, msgCommand));
                }
            }
            catch (const std::exception& e)
            {
                LOG_WARN("%s, ParseCommand failed, command: %s, err:%s, sleeper_id:%lld", __func__, buffer.data(), e.what(), m_id);
            }

            if(m_receivedPackGuid == false) {
                LOG_INFO("sleeper:%lld's first message is not cloudpack's guid", m_id);
                Stop();
                break;
            }

            buffer.erase(0, n);
        }
    }
    catch (const std::exception& e)
    {
        Stop();
        LOG_INFO("%s exception, asio read failed, err:%s, sleeper_id:%lld, remote_ip:%s", 
            __func__, e.what(), m_id, GetIp().c_str());
    }
}


asio::awaitable<void> Sleeper::Writer()
{
    try
    {
        while (m_sock.is_open())
        {
            if (m_write_msgs.empty())
            {
                //在定时器处等待，直到发送消息队列有数据 
                asio::error_code ec;
                co_await m_timer.async_wait(asio::redirect_error(asio::use_awaitable, ec));
            }
            else
            {
                co_await asio::async_write(m_sock,
                    asio::buffer(m_write_msgs.front()), asio::use_awaitable);
                m_write_msgs.pop_front();
            }
        }
    }
    catch (const std::exception& e)
    {
        Stop();
        LOG_WARN("%s exception, asio write failed, err:%s, sleeper_id:%lld, remote_ip:%s", 
            __func__, e.what(), m_id, GetIp().c_str());
    }
}

void Sleeper::Stop()
{
    if (m_is_stoped)
        return;
    m_is_stoped = true;
    LOG_INFO("%s, sleeper_id:%lld, ip:%s", __func__, m_id, GetIp().c_str());
    m_room.Leave(m_id);
    m_sock.close();
    m_timer.cancel();
    //记录连接断开
    IPTrafficRecorder::Instance().OnConnectionClose(m_ip);
}

SleeperId MakeSleeperId()
{
    static std::atomic<SleeperId> global_sleeper_id{ 10000 };
    return global_sleeper_id++;
}

}
