#pragma once

#include <chrono>
#include <map>

#include <asio/any_io_executor.hpp>
#include <asio/steady_timer.hpp>
#include <asio/awaitable.hpp>
#include <asio/ip/address_v4.hpp>

namespace wheat
{

using IPAddress = asio::ip::address_v4;

/* 对特定ip的流量和连接数量进行记录以及上报的类
 * 目前上报的信息是"conn=1,pps=10,bps=240"这种格式，分别是当前连接数，每秒包的数量，每秒bit数
 */
class IPTrafficRecorder
{
public:
    //也设计成单例了。。。 
    static IPTrafficRecorder& Instance();

    void SetExecutor(asio::any_io_executor executor);
    //上报流量信息的时间间隔，太大降低精度，太小影响性能 
    void SetUploadInterval(std::chrono::milliseconds upload_interval);
public:
    //ip有连接过来时调用 
    void OnConnection(IPAddress addr);
    //连接关闭时调用  
    void OnConnectionClose(IPAddress addr);
    //ip有数据过来时调用 
    void OnData(IPAddress addr, uint64_t bits);
private:
    struct TrafficInfo
    {
        TrafficInfo(asio::steady_timer tm);
        TrafficInfo(TrafficInfo&&) noexcept = default;
        ~TrafficInfo();
        void Reset();

        asio::steady_timer timer;
        uint64_t connection_count = 0;
        uint64_t package_count = 0;
        uint64_t bits = 0;
        bool is_changed = false;
    };

    void StartRecord(IPAddress addr, std::weak_ptr<TrafficInfo> p_traffic_info);
private:
    IPTrafficRecorder() = default;

private:
    asio::any_io_executor m_executor;
    std::chrono::milliseconds m_upload_interval{ 1000 };
    std::map<IPAddress, std::shared_ptr<TrafficInfo>> m_ip_traffic_info;
};


}