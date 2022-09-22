#include "asio.hpp"
#include "sleeper.h"
#include "room.h"
#include "logger.h"
#include "black_list.h"
#include "violation_detector.h"
#include "traffic_recorder.h"
#include "config.h"
#include "file_update_monitor.h"
#include "content_filter.h"
#include <iostream>
#include <filesystem>
#include <string>
#include <vector>

asio::awaitable<void> Listener(asio::ip::tcp::acceptor acceptor)
{
    std::vector<std::string> word_list;
    word_list.push_back("习近平");
    word_list.push_back("江泽民");
    word_list.push_back("傻逼");
    word_list.push_back("操你妈");
    word_list.push_back("死");
    word_list.push_back("杀");
    std::shared_ptr<wheat::ContentFilter> content_filter = std::make_shared<wheat::ContentFilter>(word_list);
    wheat::Room room(acceptor.get_executor());
    for (;;)
    {
        std::make_shared<wheat::Sleeper>(
            room,
            co_await acceptor.async_accept(asio::use_awaitable),
            content_filter
            )->Start();
    }
}

void PrintUsage()
{
    std::cout << "Usage: CloudSleepServer [-c config | -h]\n";
}

void InitGlobalInstance(asio::any_io_executor executor)
{
    util::g_logger.SetLogMode(LOG_CONSOLE | LOG_FILE);
    util::g_logger.SetLogToFile("sleep_server");

    wheat::common::FileUpdateMonitor::Instance().Start();
    wheat::blacklist::BlackList::Instance().SetExecutor(executor);
    wheat::IPTrafficRecorder::Instance().SetExecutor(executor);
    wheat::Config::Instance().SetExecutor(executor);
}

int main(int argc, char* argv[])
{
#ifdef _WIN32
    system("chcp 65001");
#endif // _WIN32


    std::string_view config_file;
    if (argc > 1)
    {
        if (std::strcmp("-h", argv[1]) == 0)
        {
            PrintUsage();
            return 0;
        }
        else if (strcmp("-c", argv[1]) == 0
            && argc >= 3)
        {
            config_file = argv[2];
        }
    }

    try
    {
        asio::io_context io_context(1);
        InitGlobalInstance(io_context.get_executor());
        wheat::Config::Instance().SetConfigFile(config_file);

        asio::co_spawn(
            io_context,
            Listener(asio::ip::tcp::acceptor(io_context, { asio::ip::tcp::v4(), wheat::Config::Instance().listen_port })),
            asio::detached);

        asio::signal_set signals(io_context, SIGINT, SIGTERM);
        signals.async_wait([&](auto, auto) { io_context.stop(); });

        LOG_INFO("sleep server start, listen port:%u", wheat::Config::Instance().listen_port);
        io_context.run();
    }
    catch (std::exception& e)
    {
        LOG_FATAL("%s", e.what());
    }

}