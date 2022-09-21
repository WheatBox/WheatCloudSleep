#pragma once
#include <stdio.h>
#include <string>
#include <string_view>
#include <atomic>

constexpr const char* GetFileName(std::string_view system_file_name)
{
    auto pos = system_file_name.rfind('\\');
    if (pos != std::string::npos)
    {
        return system_file_name.substr(pos + 1).data();
    }
    else
    {
        return system_file_name.data();
    }
}

#define LOG_IMPL(logger, log_level, format, ...)    \
{                                                   \
if (log_level >= logger.m_log_level)                \
{                                                   \
    logger.Log(GetFileName(__FILE__), __LINE__, log_level, format, ##__VA_ARGS__); \
}                                                   \
}

#define LOG_DEBUG(format, ...) LOG_IMPL(util::g_logger, util::LogLevel::DEBUG, format, ##__VA_ARGS__);
#define LOG_INFO(format, ...) LOG_IMPL(util::g_logger, util::LogLevel::INFO, format, ##__VA_ARGS__);
#define LOG_WARN(format, ...) LOG_IMPL(util::g_logger, util::LogLevel::WARN, format, ##__VA_ARGS__);
#define LOG_ERROR(format, ...) LOG_IMPL(util::g_logger, util::LogLevel::LEVEL_ERROR, format, ##__VA_ARGS__);
#define LOG_FATAL(format, ...) LOG_IMPL(util::g_logger, util::LogLevel::FATAL, format, ##__VA_ARGS__);


namespace util
{

enum class LogLevel
{
    DEBUG,
    INFO,
    WARN,
    LEVEL_ERROR,
    FATAL
};

#define LOG_CONSOLE 1
#define LOG_FILE    2

constexpr inline uint64_t DEFAULT_CHUNK_SIZE = 10 * 1024 * 1024;

class SimpleLogger
{
public:
    SimpleLogger();

    void SetLogMode(int mode) { m_mode = mode; };

    void SetLogToFile(const char* file_name);

    void SetLogLevel(LogLevel log_level) { m_log_level = log_level; }

    void SetChunkSize(uint64_t chunk_size) { m_chunk_size = chunk_size; }

    void Log(const char* src_code_file, int log_line, LogLevel log_level, const char* format, ...);

private:
    void OpenFile();

public:
    LogLevel m_log_level = LogLevel::INFO;

private:
    std::string m_file_prefix;
    FILE* m_file = nullptr;
    int m_mode = LOG_CONSOLE;
    std::atomic_uint64_t m_chunk_size = DEFAULT_CHUNK_SIZE;
    std::atomic_uint64_t m_cur_file_size = 0;
};

inline SimpleLogger g_logger;

}