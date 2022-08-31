#include "asio.hpp"
#include "sleeper.h"
#include "room.h"
#include "logger.h"
#include "black_list.h"
#include "violation_detector.h"
#include "traffic_recorder.h"
#include <iostream>

constexpr std::uint16_t PORT = 11451;
constexpr std::uint16_t MAX_PORT = 65535;

asio::awaitable<void> Listener(asio::ip::tcp::acceptor acceptor)
{
    wheat::Room room(acceptor.get_executor());
    for (;;)
    {
        std::make_shared<wheat::Sleeper>(
            room,
            co_await acceptor.async_accept(asio::use_awaitable)
            )->Start();
    }
}

void PrintUsage()
{
    std::cout << "Usage: CloudSleepServer ({port}|-h)\n";
}

int main(int argc, char* argv[])
{
    std::uint16_t server_port = PORT;

    if (argc > 1)
    {
        if (std::strcmp("-h", argv[1]) == 0)
        {
            PrintUsage();
            return 0;
        }

        try
        {
            unsigned long new_port = std::stoul(argv[1]);
            if (new_port > MAX_PORT)
            {
                throw std::exception();
            }

            server_port = static_cast<std::uint16_t>(new_port);
        }
        catch (const std::exception&)
        {
            std::cout << "Error: wrong argument\n";
            PrintUsage();
            return 1;
        }

    }

    util::g_logger.SetLogMode(LOG_CONSOLE | LOG_FILE);
    util::g_logger.SetLogToFile("sleep_server");

    try
    {
        asio::io_context io_context(1);
        wheat::blacklist::BlackList::Instance().Init(io_context.get_executor());
        //设置ip的默认违规规则，连接数=5，每秒发包数100，每秒比特81920(10KB) 
        wheat::ViolationDetector::Instance().SetTypeDetectorRule("ip", "conn=5,pps=100,bps=81920");
        //为了测试方便，对于127.0.0.1放开限制 
        wheat::ViolationDetector::Instance().SetIdDetectorRule("ip", "127.0.0.1", "conn=1000,pps=100000,bps=819200000");
        wheat::IPTrafficRecorder::Instance().SetExecutor(io_context.get_executor());
        wheat::IPTrafficRecorder::Instance().SetUploadInterval(std::chrono::seconds(1));

        asio::co_spawn(
            io_context,
            Listener(asio::ip::tcp::acceptor(io_context, { asio::ip::tcp::v4(), server_port })),
            asio::detached);

        asio::signal_set signals(io_context, SIGINT, SIGTERM);
        signals.async_wait([&](auto, auto) { io_context.stop(); });

        LOG_INFO("sleep server start, listen port:%u", server_port);
        io_context.run();
    }
    catch (std::exception& e)
    {
        LOG_FATAL("%s", e.what());
    }

}