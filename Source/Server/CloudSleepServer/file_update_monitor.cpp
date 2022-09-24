#include "file_update_monitor.h"

#include <mutex>

#ifdef _WIN32
#include "windows.h"
#else
#include <unistd.h>
#include <sys/select.h>
#include <sys/inotify.h>
#define EVENT_SIZE  ( sizeof (struct inotify_event) )
#define BUF_LEN     ( 1024 * ( EVENT_SIZE + 16 ) )
#endif

#include "wheat_common.h"

namespace wheat::common
{

FileUpdateMonitor::FileUpdateMonitor()
{
#ifdef _WIN32
    m_handle_stop = INVALID_HANDLE_VALUE;
#else
    m_fd = -1;
#endif
    m_thread_running = false;
}

FileUpdateMonitor::~FileUpdateMonitor()
{
    Stop();
}

FileUpdateMonitor& FileUpdateMonitor::Instance()
{
    static FileUpdateMonitor single_instance;
    return single_instance;
}

void FileUpdateMonitor::Start()
{
    Stop();
#ifdef _WIN32
    m_handle_stop = CreateEvent(NULL, FALSE, FALSE, NULL);
#else
    m_fd = inotify_init();
#endif
    m_thread_running = true;
    m_work_thread = std::thread([this]() { ThreadProcEx(); });
}

void FileUpdateMonitor::Stop()
{
#ifdef _WIN32
    if (m_handle_stop != INVALID_HANDLE_VALUE)
    {
        SetEvent(m_handle_stop);
    }
#endif
    if (m_thread_running)
    {
        m_thread_running = true;
        m_work_thread.join();
    }

    std::unique_lock<std::shared_mutex> write_lock(m_monitor_mutex);
    for (auto path_iter = m_monite_paths.begin(); path_iter != m_monite_paths.end(); path_iter++)
    {
#ifdef _WIN32
        FindCloseChangeNotification(path_iter->second.handle);
#else
        inotify_rm_watch(m_fd, path_iter->second.fd);
#endif
    }
    m_monite_paths.clear();

#ifdef _WIN32
    if (m_handle_stop != INVALID_HANDLE_VALUE)
    {
        CloseHandle(m_handle_stop);
        m_handle_stop = INVALID_HANDLE_VALUE;
    }
#else
    if (m_fd >= 0)
    {
        close(m_fd);
        m_fd = -1;
    }
#endif
}

void FileUpdateMonitor::ThreadProcEx()
{
    while (m_thread_running)
    {
        std::map<std::string, std::set<IFileUpdateNotify*>> notifies;
#ifdef _WIN32
        HANDLE handles[64] = { m_handle_stop };
        std::string paths[64] = { };
        int32_t handle_count = 1;
        std::shared_lock<std::shared_mutex> read_lock(m_monitor_mutex);
        for (auto& [path, moniter_info] : m_monite_paths)
        {
            handles[handle_count] = moniter_info.handle;
            paths[handle_count++] = path;
        }
        read_lock.unlock();
        auto wait_ret = MsgWaitForMultipleObjects(handle_count, handles, FALSE, 100, QS_ALLEVENTS);
        if (wait_ret == WAIT_OBJECT_0)
        {
            break;
        }
        else if (wait_ret > WAIT_OBJECT_0 && wait_ret < WAIT_OBJECT_0 + handle_count)
        {
            int32_t handle_index = wait_ret - WAIT_OBJECT_0;
            WIN32_FILE_ATTRIBUTE_DATA attr;
            std::shared_lock<std::shared_mutex> read_lock(m_monitor_mutex);
            auto path_iter = m_monite_paths.find(paths[handle_index]);
            if (path_iter != m_monite_paths.end())
            {
                auto file_iter = path_iter->second.files.begin();
                while (file_iter != path_iter->second.files.end())
                {
                    if (GetFileAttributesExA((*file_iter).first.data(), GetFileExInfoStandard, &attr))
                    {
                        if (CompareFileTime(&attr.ftLastWriteTime, &(*file_iter).second.fileAttr.ftLastWriteTime) != 0)
                        {
                            (*file_iter).second.fileAttr.ftLastWriteTime = attr.ftLastWriteTime;
                            notifies[(*file_iter).first] = (*file_iter).second.notifies;
                        }
                    }
                    file_iter++;
                }
            }
            FindNextChangeNotification(handles[wait_ret - WAIT_OBJECT_0]);
        }
        else if (wait_ret == WAIT_OBJECT_0 + handle_count)
        {
            MSG msg;
            while (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE))
            {
                TranslateMessage(&msg);
                DispatchMessage(&msg);
            }
        }
#else
        fd_set rfd;
        char buffer[BUF_LEN];
        FD_ZERO(&rfd);
        FD_SET(m_fd, &rfd);

        struct timeval tv;
        tv.tv_sec = 0;
        tv.tv_usec = 100000; // 100000 us

        if (select(m_fd + 1, &rfd, NULL, NULL, &tv) <= 0)
        {
            continue;
        }

        std::shared_lock<std::shared_mutex> read_lock(m_monitor_mutex);

        int iLen = read(m_fd, buffer, BUF_LEN);

        int i = 0;
        while (i < iLen)
        {
            struct inotify_event* event = (struct inotify_event*)&buffer[i];

            std::string dir;
            for (auto& [monite_path, monite_info] : m_monite_paths)
            {
                if (monite_info.fd == event->wd)
                {
                    auto canonical_file_path = GetFileCanonicalPath(event->name);
                    if (!canonical_file_path.empty())
                    {
                        auto file_iter = monite_info.files.find(canonical_file_path);
                        if (file_iter != monite_info.files.end())
                        {
                            notifies[(*file_iter).first] = (*file_iter).second.notifies;
                        }
                    }
                    break;
                }
            }
            i += EVENT_SIZE + event->len;
        }
        read_lock.unlock();
#endif
        for (auto& [path, noitfy_set] : notifies)
        {
            for (auto notify : noitfy_set)
            {
                notify->OnFileUpdate(path.data());
            }
        }
    }
}

bool FileUpdateMonitor::AddDir(const std::string& dir_path)
{
    auto path_iter = m_monite_paths.find(dir_path);
    if (path_iter != m_monite_paths.end())
    {
        return true;
    }

#ifdef _WIN32
    auto path_handle = FindFirstChangeNotificationA(dir_path.data(), FALSE, FILE_NOTIFY_CHANGE_LAST_WRITE);
    if (path_handle != INVALID_HANDLE_VALUE)
    {
        m_monite_paths[dir_path] = { path_handle, {} };
    }
    else
    {
        return false;
    }
#else
    std::string watch_path = dir_path + "/";
    auto path_fd = inotify_add_watch(m_fd, watch_path.data(), IN_MODIFY | IN_CREATE | IN_MOVED_TO);
    if (path_fd >= 0)
    {
        m_monite_paths[dir_path] = { path_fd, {} };
    }
    else
    {
        return false;
    }
#endif
    return true;
}

bool FileUpdateMonitor::RemoveDir(const std::string& dir_path)
{
    auto path_iter = m_monite_paths.find(dir_path);
    if (path_iter == m_monite_paths.end())
    {
        return true;
    }

#ifdef _WIN32
    FindCloseChangeNotification(path_iter->second.handle);
#else
    inotify_rm_watch(m_fd, path_iter->second.fd);
#endif
    m_monite_paths.erase(path_iter);

    return true;
}

bool FileUpdateMonitor::AddFile(const char* file_path, IFileUpdateNotify* notify)
{
    if (!file_path || *file_path == '\0') return false;
    if (!m_thread_running) return false;

    auto canonical_file_path = GetFileCanonicalPath(file_path).generic_string();
    if (canonical_file_path.empty()) return false;

    auto parent_dir = GetFileParentPath(canonical_file_path).generic_string();
    std::unique_lock<std::shared_mutex> write_lock(m_monitor_mutex);
    if (!AddDir(parent_dir))
    {
        return false;
    }
    auto& monite_files = m_monite_paths[parent_dir].files;
    auto iter = monite_files.find(canonical_file_path);
    if (iter == monite_files.end())
    {
        MoniteFileInfo fileInfo;
#ifdef _WIN32
        GetFileAttributesExA(canonical_file_path.data(), GetFileExInfoStandard, &fileInfo.fileAttr);
#endif
        fileInfo.notifies.insert(notify);
        monite_files[canonical_file_path] = fileInfo;
    }
    else
    {
        (*iter).second.notifies.insert(notify);
    }

    return true;
}

bool FileUpdateMonitor::RemoveFile(const char* file_path, IFileUpdateNotify* notify)
{
    if (!file_path || *file_path == '\0') return false;
    if (!m_thread_running) return false;

    auto canonical_file_path =GetFileCanonicalPath(file_path).generic_string();
    if (canonical_file_path.empty()) return false;

    auto parent_dir = GetFileParentPath(canonical_file_path).generic_string();
    std::unique_lock<std::shared_mutex> write_lock(m_monitor_mutex);
    auto path_iter = m_monite_paths.find(parent_dir);
    if (path_iter == m_monite_paths.end())
    {
        return true;
    }

    auto file_iter = path_iter->second.files.find(canonical_file_path);
    if (file_iter == path_iter->second.files.end())
    {
        return true;
    }
    file_iter->second.notifies.erase(notify);
    if (file_iter->second.notifies.empty())
    {
        path_iter->second.files.erase(file_iter);
        if (path_iter->second.files.empty())
        {
            RemoveDir(parent_dir);
        }
    }
    return true;
}

}
