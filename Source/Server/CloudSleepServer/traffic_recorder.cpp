#include "traffic_recorder.h"
#include <asio/co_spawn.hpp>
#include <asio/detached.hpp>
#include <asio/redirect_error.hpp>
#include "violation_detector.h"
#include "logger.h"

#include <cmath>

namespace wheat
{

void UploadTrafficInfo(std::chrono::milliseconds ms, IPAddress addr, 
    uint64_t conn_count, uint64_t package_count, uint64_t bits);

IPTrafficRecorder& IPTrafficRecorder::Instance()
{
    static IPTrafficRecorder g_recorder;
    return g_recorder;
}

void IPTrafficRecorder::SetExecutor(asio::any_io_executor executor)
{
    m_executor = std::move(executor);
}

void IPTrafficRecorder::SetUploadInterval(std::chrono::milliseconds upload_interval)
{
    m_upload_interval = upload_interval;
}

void IPTrafficRecorder::OnConnection(IPAddress addr)
{
    bool start_record = false;

    auto iter = m_ip_traffic_info.find(addr);
    if (iter == m_ip_traffic_info.end())
    {
        asio::steady_timer timer(m_executor);
        iter = m_ip_traffic_info.emplace(addr, 
            std::make_shared<TrafficInfo>(std::move(timer))).first;
        assert(iter != m_ip_traffic_info.end());
        start_record = true;
    }
    auto& traffic_info = *iter->second;
    traffic_info.connection_count++;
    traffic_info.is_changed = true;

    if (start_record)
        StartRecord(addr, iter->second);
}

void IPTrafficRecorder::OnConnectionClose(IPAddress addr)
{
    auto iter = m_ip_traffic_info.find(addr);
    if (iter != m_ip_traffic_info.end())
    {
        auto& traffic_info = *iter->second;
        traffic_info.connection_count--;
        traffic_info.is_changed = true;

        //连接数归零之后，除了要在本地移除ip之外，还需要移除违规检测器里的id 
        if (traffic_info.connection_count == 0)
        {
            auto str_addr = addr.to_string();
            LOG_INFO("%s, stop record, ip:%s", __func__, str_addr.c_str());
            ViolationDetector::Instance().RemoveId("ip", str_addr);
            m_ip_traffic_info.erase(iter);
        }
    }
}

void IPTrafficRecorder::OnData(IPAddress addr, uint64_t bits)
{
    auto iter = m_ip_traffic_info.find(addr);
    if (iter == m_ip_traffic_info.end())
    {
        LOG_WARN("%s, ip:%s not found", __func__, addr.to_string().c_str());
        return;
    }
    auto& traffic_info = *iter->second;
    traffic_info.package_count++;
    traffic_info.bits += bits;
    traffic_info.is_changed = true;
}

void IPTrafficRecorder::StartRecord(IPAddress addr, std::weak_ptr<TrafficInfo> traffic_info_weak_ref)
{
    LOG_INFO("%s, ip:%s", __func__, addr.to_string().c_str());
    asio::co_spawn(
        m_executor,
        [addr, traffic_info_weak_ref, upload_interval = m_upload_interval]() ->
        asio::awaitable<void> {
            while (true)
            {
                try
                {
                    auto p_traffic_info = traffic_info_weak_ref.lock();
                    if (!p_traffic_info)
                        co_return;

                    auto& traffic_info = *p_traffic_info;
                    traffic_info.timer.expires_after(upload_interval);
                    co_await traffic_info.timer.async_wait(asio::use_awaitable);
                    if (traffic_info.is_changed)
                    {
                        UploadTrafficInfo(upload_interval, addr, traffic_info.connection_count,
                            traffic_info.package_count, traffic_info.bits);
                        traffic_info.Reset();
                    }
                }
                catch (const std::exception&)
                {
                    //说明定时器被取消了 
                    co_return;
                }
            }
        },
        asio::detached);
}

wheat::IPTrafficRecorder::TrafficInfo::TrafficInfo(asio::steady_timer tm)
    : timer(std::move(tm))
{
}

IPTrafficRecorder::TrafficInfo::~TrafficInfo()
{
    timer.cancel();
}

void IPTrafficRecorder::TrafficInfo::Reset()
{
    package_count = 0;
    bits = 0;
    is_changed = false;
}

void UploadTrafficInfo(std::chrono::milliseconds ms, IPAddress addr, 
    uint64_t conn_count, uint64_t package_count, uint64_t bits)
{
    //计算每秒包的数据量以及字节数 
    auto sec_count = std::chrono::duration_cast<std::chrono::duration<double>>(ms).count();
    uint64_t pps = std::ceil((double)package_count / sec_count);
    uint64_t bps = std::ceil((double)bits / sec_count);

    char buffer[256];
    snprintf(buffer, 255, "conn=%zu,pps=%zu,bps=%zu", conn_count, pps, bps);
    ViolationDetector::Instance().UpdateInfo("ip", addr.to_string(), buffer);
}


}