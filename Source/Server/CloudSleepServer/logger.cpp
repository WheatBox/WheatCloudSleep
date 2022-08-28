#define _CRT_SECURE_NO_WARNINGS
#include "logger.h"
#include <chrono>
#include <stdarg.h>

#ifdef _WIN32
#include <Windows.h>
#else
#include <sys/time.h>
#endif

namespace util
{

#ifdef _WIN32
std::pair<std::tm*, long int> GetTimeStamp()
{
    static std::tm tm;
    SYSTEMTIME wtm;
    GetLocalTime(&wtm);

    tm.tm_year = wtm.wYear - 1900;
    tm.tm_mon = wtm.wMonth - 1;
    tm.tm_mday = wtm.wDay;
    tm.tm_hour = wtm.wHour;
    tm.tm_min = wtm.wMinute;
    tm.tm_sec = wtm.wSecond;

    return std::make_pair(&tm, wtm.wMilliseconds);
}

#else
std::pair<std::tm*, long int> GetTimeStamp()
{
    struct timeval tv;
    gettimeofday(&tv, NULL);

    return std::make_pair(std::localtime(&tv.tv_sec), tv.tv_usec / 1000);
}

#endif // _WIN32

char* GetTimeStampStr()
{
    auto [tm, msec] = GetTimeStamp();
    static char buffer[256] = { };

    snprintf(buffer, 256, "%04d-%02d-%02d %02d:%02d:%02d:%03d", tm->tm_year + 1900, 
        tm->tm_mon + 1, tm->tm_mday, tm->tm_hour, tm->tm_min, tm->tm_sec, msec);
    return buffer;
}

const char* LogLevelToStr(LogLevel log_level)
{
    switch (log_level)
    {
    case LogLevel::DEBUG:
        return "debug";
    case LogLevel::INFO:
        return "info";
    case LogLevel::WARN:
        return "warn";
    case LogLevel::LEVEL_ERROR:
        return "error";
    case LogLevel::FATAL:
        return "fatal";
    default:
        return "unknown";
    }
}

void SimpleLogger::SetLogToFile(const char* file_name)
{
    m_file_prefix = file_name;
    OpenFile();
}

void SimpleLogger::Log(const char* src_code_file, int log_line, LogLevel log_level, const char* format, ...)
{
    char buffer[1024];
    int prefix_size = snprintf(buffer, 1024, "%s [%s] %s:%d ", 
        GetTimeStampStr(), LogLevelToStr(log_level), src_code_file, log_line);

    va_list arg_list;
    va_start(arg_list, format);
    int content_size = vsnprintf(buffer + prefix_size, 1024 - prefix_size, format, arg_list);
    va_end(arg_list);

    auto size = prefix_size + content_size;
    if (m_mode | LOG_CONSOLE)
    {
        fwrite(buffer, size, 1, stdout);
        fwrite("\n", 1, 1, stdout);
    }
    
    if (m_mode | LOG_FILE)
    {
        if (m_cur_file_size >= m_chunk_size)
        {
            OpenFile();
        }

        if (m_file)
        {
            fwrite(buffer, size, 1, m_file);
            fwrite("\n", 1, 1, m_file);
            //todo 是否用单独的线程打印日志
            fflush(m_file);
            m_cur_file_size += size;
        }
    }
}

void SimpleLogger::OpenFile()
{
    auto [tm, msec] = GetTimeStamp();
    char file_name[256] = {};
    snprintf(file_name, 256, "%s-%04d-%02d-%02d-%02d-%02d-%02d.log", m_file_prefix.c_str(), 
        tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday, tm->tm_hour, tm->tm_min, tm->tm_sec);

    m_file = fopen(file_name, "w");
    if (m_file)
    {
        m_cur_file_size = 0;
    }
}

}
