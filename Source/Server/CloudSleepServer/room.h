#pragma once
#include <array>
#include <memory>
#include <map>
#include <string_view>
#include "sleeper.h"
#include "vote_counter.h"
#include "logger.h"

namespace wheat
{

constexpr size_t DEFAULT_MAX_BED_NUM = 256;//默认最大床位256 
constexpr int DEFAULT_VOTE_WAIT_TIME = 10; //默认投票时间10秒 
class Sleeper;

/* 房间，Sleeper可以加入房间，同一个房间内的Sleeper能互相看到对方 
 * 负责管理sleeper(加入离开)、管理床位(睡觉/起床)、以及消息的分发 
 */
class Room
{
public:
    Room() { for (auto& id : m_beds) id = INVALID_SLEEPER_ID; };

    void Join(SleeperId id, std::shared_ptr<Sleeper> sleeper);

    void Leave(SleeperId id);

    bool Sleep(SleeperId id, int bed_num);

    void GetUp(SleeperId id);

    template <typename Executor>
    bool VoteKickStart(Executor executor, SleeperId id)
    {
        if (m_is_voting)
        {
            LOG_WARN("%s, another vote is being", __func__);
            return false;
        }
        else
        {
            LOG_INFO("%s, sleeper_id:%lld", __func__, id);
            m_is_voting = true;
            asio::co_spawn(
                executor,
                [this, id, executor]() -> asio::awaitable<void>
                {
                    asio::steady_timer timer(executor, std::chrono::seconds(DEFAULT_VOTE_WAIT_TIME));
                    co_await timer.async_wait(asio::use_awaitable);
                    VoteKickOver(id);

                    m_vote_counter.Clear();
                },
                asio::detached
            );
            return true;
        }
    }

    void Agree(SleeperId id);

    void Refuse(SleeperId id);

    void Deliver(SleeperId src_id, std::string_view msg);

private:
    void DeliverToAll(const std::string& msg);

    void SendVoteState();

    void VoteKickOver(SleeperId id);

private:
    std::map<SleeperId, std::shared_ptr<Sleeper>> m_sleepers;
    std::array<SleeperId, DEFAULT_MAX_BED_NUM> m_beds;

    bool m_is_voting = false;
    VoteCounter<SleeperId> m_vote_counter;
};


}