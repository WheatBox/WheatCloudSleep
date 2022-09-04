#pragma once

#include <set>
#include <map>
#include <string>
#include <thread>
#include <shared_mutex>

#ifdef _WIN32
#include "windows.h"
#endif

namespace wheat::common
{

//接收文件更新通知的类，需实现此接口
struct IFileUpdateNotify
{
    //
    //文件更新通知
    //
    virtual void OnFileUpdate(const char* file_path) = 0;
};


//提供监视某路径下文件更新的功能 
class FileUpdateMonitor
{
public:
    static FileUpdateMonitor& Instance();

    //启动监视某路径下的文件 
    void Start();

    //停止监视 
    void Stop();

    //添加监视路径下的文件 
    bool AddFile(const char* file_path, IFileUpdateNotify* notify);

    //删除监视路径下的文件 
    bool RemoveFile(const char* file_path, IFileUpdateNotify* notify);

protected:

    FileUpdateMonitor();
    virtual ~FileUpdateMonitor();

    virtual void ThreadProcEx();
    bool AddDir(const std::string& dir_path);
    bool RemoveDir(const std::string& dir_path);

private:
    struct MoniteFileInfo
    {
#ifdef _WIN32
        WIN32_FILE_ATTRIBUTE_DATA fileAttr{ 0 };               //文件属性
#endif
        std::set<IFileUpdateNotify*> notifies;                 //通知对象集合
    };

    struct MonitePathInfo
    {
#ifdef _WIN32
        HANDLE handle;
#else
        int fd;
#endif
        std::map<std::string, MoniteFileInfo> files;
    };

    std::shared_mutex m_monitor_mutex;
    std::map<std::string, MonitePathInfo> m_monite_paths;
    std::thread m_work_thread;
    bool m_thread_running = false;

#ifdef _WIN32
    HANDLE m_handle_stop;
#else
    int m_fd;
#endif

};

}