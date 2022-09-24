#pragma once

#include <filesystem>
#include <set>
#include <string>
#include <string_view>
#include <mutex>

#include "file_update_monitor.h"

namespace wheat
{

class PermissionMgr
    : public common::IFileUpdateNotify
{
public:
    static PermissionMgr& Instance();

    void SetPermissionFile(std::filesystem::path path);

    bool IsAdministrator(std::string_view key);

private:
    virtual void OnFileUpdate(const char* file_path) override;

    void ParsePermissionFile();

private:
    std::mutex m_mutex;
    std::filesystem::path m_permission_file;
    std::set<std::string, std::less<>> m_administrators;
};


}