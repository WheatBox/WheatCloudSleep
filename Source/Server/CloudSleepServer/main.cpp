#include <filesystem>
#include <iostream>
#include <string>
#include <vector>

#include <asio.hpp>

#include "black_list.h"
#include "config.h"
#include "content_filter.h"
#include "file_update_monitor.h"
#include "logger.h"
#include "room.h"
#include "sleeper.h"
#include "traffic_recorder.h"
#include "violation_detector.h"

std::unique_ptr<wheat::ContentFilter> BuildContentFilter()
{
    const std::filesystem::path& bad_word_list = wheat::Config::Instance().bad_word_list;
    if (bad_word_list.empty())
    {
        LOG_WARN("bad word list file not found, please specify!");
        return nullptr;
    }

    return std::make_unique<wheat::ContentFilter>(bad_word_list);
}

std::unique_ptr<wheat::ContentFilter> BuildDefaultContentFilter()
{
    std::vector<std::string> bad_words;
    bad_words.push_back("习近平");
    bad_words.push_back("傻逼");
    bad_words.push_back("操你");
    bad_words.push_back("日你");
    bad_words.push_back("草你");
    bad_words.push_back("杀");
    bad_words.push_back("死");

    return std::make_unique<wheat::ContentFilter>(bad_words);
}

asio::awaitable<void> Listener(asio::ip::tcp::acceptor acceptor)
{
    std::shared_ptr<wheat::ContentFilter> content_filter = BuildContentFilter();
    if (!content_filter)
    {
        LOG_WARN("using default bad word list which is very simple!");
        content_filter = BuildDefaultContentFilter();
    }
    else
    {
        LOG_INFO("using bad word list file at %s", wheat::Config::Instance().bad_word_list.string().c_str());
    }
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