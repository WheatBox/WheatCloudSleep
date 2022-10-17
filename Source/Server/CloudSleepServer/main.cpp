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

    const std::filesystem::path& f_stop_char_list = wheat::Config::Instance().stop_char_list;
    if (f_stop_char_list.empty())
    {
        LOG_WARN("stop char word list file not found, please specify!");
        return nullptr;
    }

    return std::make_unique<wheat::ContentFilter>(bad_word_list, f_stop_char_list);
}

// 若未能检测到敏感词文件，则会启用该备用敏感词汇
std::unique_ptr<wheat::ContentFilter> BuildDefaultContentFilter()
{
    std::vector<std::string> bad_words;
    bad_words.push_back("刁近平");
    bad_words.push_back("习近平");
    bad_words.push_back("近平");
    bad_words.push_back("习近");
    bad_words.push_back("xijinping");
    bad_words.push_back("xijin");
    bad_words.push_back("jinping");
    bad_words.push_back("xjp");
    bad_words.push_back("杨尚昆");
    bad_words.push_back("yangshangkun");
    bad_words.push_back("ysk");
    bad_words.push_back("江泽民");
    bad_words.push_back("jiangzemin");
    bad_words.push_back("jzm");
    bad_words.push_back("李先念");
    bad_words.push_back("lixiannian");
    bad_words.push_back("lxn");
    bad_words.push_back("胡锦涛");
    bad_words.push_back("hujintao");
    bad_words.push_back("hjt");
    bad_words.push_back("刘少奇");
    bad_words.push_back("liushaoqi");
    bad_words.push_back("lsq");
    bad_words.push_back("邓小平");
    bad_words.push_back("dengxiaoping");
    bad_words.push_back("dxp");
    bad_words.push_back("毛泽东");
    bad_words.push_back("maozedong");
    bad_words.push_back("mzd");
    
    bad_words.push_back("台湾");
    bad_words.push_back("台灣");
    bad_words.push_back("tw");
    bad_words.push_back("香港");
    bad_words.push_back("xg");
    bad_words.push_back("新疆");
    bad_words.push_back("xj");

    bad_words.push_back("傻逼");
    bad_words.push_back("sb");
    bad_words.push_back("婊子");
    bad_words.push_back("母狗");
    bad_words.push_back("操你");
    bad_words.push_back("日你");
    bad_words.push_back("草你");
    bad_words.push_back("杀");
    bad_words.push_back("死");

    std::vector<std::string> stop_chars;
    stop_chars.push_back(",");
    stop_chars.push_back(".");
    stop_chars.push_back("/");
    stop_chars.push_back("?");
    stop_chars.push_back(";");
    stop_chars.push_back(":");
    stop_chars.push_back("'");
    stop_chars.push_back("\"");
    stop_chars.push_back("[");
    stop_chars.push_back("]");
    stop_chars.push_back("{");
    stop_chars.push_back("}");
    stop_chars.push_back("(");
    stop_chars.push_back(")");
    stop_chars.push_back("*");
    stop_chars.push_back("&");
    stop_chars.push_back("^");
    stop_chars.push_back("%");
    stop_chars.push_back("$");
    stop_chars.push_back("#");
    stop_chars.push_back("@");
    stop_chars.push_back("!");
    stop_chars.push_back("~");
    stop_chars.push_back("`");
    stop_chars.push_back("<");
    stop_chars.push_back(">");
    stop_chars.push_back("\\");
    stop_chars.push_back("|");
    stop_chars.push_back("-");
    stop_chars.push_back("_");
    stop_chars.push_back("+");
    stop_chars.push_back("=");

    stop_chars.push_back("，");
    stop_chars.push_back("。");
    stop_chars.push_back("—");
    stop_chars.push_back("…");
    stop_chars.push_back("；");
    stop_chars.push_back("‘");
    stop_chars.push_back("‘");
    stop_chars.push_back("“");
    stop_chars.push_back("“");
    stop_chars.push_back("、");
    stop_chars.push_back("·");
    stop_chars.push_back("（");
    stop_chars.push_back("）");
    stop_chars.push_back("【");
    stop_chars.push_back("】");
    stop_chars.push_back("！");
    stop_chars.push_back("？");
    stop_chars.push_back("《");
    stop_chars.push_back("》");
    stop_chars.push_back("￥");

    return std::make_unique<wheat::ContentFilter>(bad_words, stop_chars);
}

asio::awaitable<void> Listener(asio::ip::tcp::acceptor acceptor)
{
    std::shared_ptr<wheat::ContentFilter> content_filter = BuildContentFilter();
    if (!content_filter)
    {
        LOG_WARN("using default bad word and stop char list which is very simple!");
        content_filter = BuildDefaultContentFilter();
    }
    else
    {
        LOG_INFO("using bad word list file at %s", wheat::Config::Instance().bad_word_list.string().c_str());
        LOG_INFO("using stop char list file at %s", wheat::Config::Instance().stop_char_list.string().c_str());
    }
    content_filter->SetSuperMode(wheat::Config::Instance().content_filter_super_mode);
    
    wheat::Config::Instance().m_pContentFilter = content_filter;

    wheat::Room room(acceptor.get_executor());
    room.m_packGuid = wheat::Config::Instance().cloudpack_guid;

    LOG_INFO("using cloudpack's guid = %s", room.m_packGuid.c_str());

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