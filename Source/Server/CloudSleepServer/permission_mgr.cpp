#include "permission_mgr.h"
#include <fstream>
#include "logger.h"

namespace wheat
{
PermissionMgr& PermissionMgr::Instance()
{
    static PermissionMgr instance;
    return instance;
}
void PermissionMgr::SetPermissionFile(std::filesystem::path path)
{
    std::unique_lock lk(m_mutex);

    if (path == m_permission_file && !m_permission_file.empty())
    {
        lk.unlock();
        ParsePermissionFile();
        return;
    }

    if (!m_permission_file.empty())
    {
        common::FileUpdateMonitor::Instance().RemoveFile(m_permission_file.generic_string().c_str(), this);
    }
    m_permission_file = std::move(path);
    if (!m_permission_file.empty())
    {
        common::FileUpdateMonitor::Instance().AddFile(m_permission_file.generic_string().c_str(), this);
        lk.unlock();
        ParsePermissionFile();
    }
}

bool PermissionMgr::IsAdministrator(std::string_view key)
{
    (void)key;
    return true;
    /* todo 等需要实现管理员权限时放开 
    std::lock_guard lk(m_mutex);

    return m_administrators.contains(key);
    */
}

void PermissionMgr::OnFileUpdate(const char* file_path)
{
    LOG_INFO("%s, file_path", __func__, file_path);
    SetPermissionFile(file_path);
}

void PermissionMgr::ParsePermissionFile()
{
    std::filesystem::path path;
    {
        std::lock_guard lk(m_mutex);
        path = m_permission_file;
    }

    std::ifstream in(path);
    if (!in.is_open())
    {
        LOG_ERROR("%s, open perssion file:%s failed", 
            __func__, path.generic_string().c_str());
        return;
    }

    decltype(m_administrators) administrators;
    std::string line;
    while (std::getline(in, line))
    {
        administrators.emplace(line);
    }

    {
        std::lock_guard lk(m_mutex);
        m_administrators.swap(administrators);
    }
}


}
