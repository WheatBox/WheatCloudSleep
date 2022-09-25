#pragma once

#include <filesystem>

#include <asio/any_io_executor.hpp>

#include "file_update_monitor.h"

namespace wheat
{

struct Config
    : public common::IFileUpdateNotify
{
public:
    static Config& Instance();

    void SetExecutor(asio::any_io_executor executor);

    bool SetConfigFile(std::filesystem::path path);

    //config items
    //服务器端口 
    uint16_t listen_port = 11451;
    //房间最大床位256
    int max_bed_num = 256;
    //投票时间10s
    int vote_wait_period_s = 10;
    //上报流量信息时间间隔1000ms
    int traffic_upload_interval_ms = 1000;

    //默认黑名单时长10min，最大黑名单时长1天，观察期时长翻倍 
    int block_period_m = 10;
    int max_block_period_m = 24 * 60;
    int watch_period_m = 2 * block_period_m;
    int max_watch_period_m = 2 * max_block_period_m;

    std::filesystem::path violation_rules_config_file;
    std::filesystem::path permission_file;
    std::filesystem::path bad_word_list;
private:
    bool ParseConfig(std::filesystem::path path);

    virtual void OnFileUpdate(const char* file_path);

    void UpdateConfig() const;
private:
    asio::any_io_executor m_executor;
};


}