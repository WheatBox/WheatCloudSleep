#include "config.h"

#include <algorithm>
#include <fstream>
#include <map>
#include <string_view>

#include <asio/dispatch.hpp>
#include <nlohmann/json.hpp>

#include "logger.h"
#include "permission_mgr.h"
#include "traffic_recorder.h"
#include "violation_detector.h"

using nlohmann::json;
using namespace std::literals::string_view_literals;

#define GET_CONFIG_ITEM_FROM_JSON(json_obj, item_name)                      \
if (auto iter = config_items.find(#item_name); iter != config_items.end())  \
{                                                                           \
   item_name = *iter;                                                       \
}

#define GET_CONFIG_ITEM_FROM_JSON__STRING(json_obj, item_name)              \
if (auto iter = config_items.find(#item_name); iter != config_items.end())  \
{                                                                           \
   item_name = iter->get<std::string>();                                    \
}

namespace wheat
{

class ViolationRules
    : public common::IFileUpdateNotify
{
    struct ViolationRuleKey
    {
        std::string type;
        std::string id;

        auto operator<=>(const ViolationRuleKey&) const = default;
    };

public:
    ViolationRules();

    void SetExecutor(asio::any_io_executor executor);

    void SetConfigFile(std::filesystem::path path);
private:
    void ParseConfig(std::filesystem::path path);

    void UpdateRules(std::map<ViolationRuleKey, std::string> new_rules);

    virtual void OnFileUpdate(const char* file_path);

private:
    asio::any_io_executor m_executor;
    std::filesystem::path m_config_file_path;
    std::map<ViolationRuleKey, std::string> m_rules;
};

ViolationRules& GetViolationRules()
{
    static ViolationRules instance;
    return instance;
}

Config& Config::Instance()
{
    static Config instance;
    return instance;
}

void Config::SetExecutor(asio::any_io_executor executor)
{
    m_executor = std::move(executor);
    GetViolationRules().SetExecutor(m_executor);
}

bool Config::SetConfigFile(std::filesystem::path path)
{
    if (!path.empty())
    {
        common::FileUpdateMonitor::Instance().AddFile(path.generic_string().c_str(), this);
        return ParseConfig(std::move(path));
    }
    else
    {
        return false;
    }
}

bool Config::ParseConfig(std::filesystem::path path)
{
    std::ifstream in(path);
    auto path_str = path.generic_string();
    if (!in.is_open())
    {
        LOG_ERROR("%s, open config file:%s failed", __func__, path_str.c_str());
        return false;
    }

    try
    {
        auto config_items = json::parse(in);
        GET_CONFIG_ITEM_FROM_JSON(config_items, listen_port);
        GET_CONFIG_ITEM_FROM_JSON(config_items, max_bed_num);
        GET_CONFIG_ITEM_FROM_JSON(config_items, vote_wait_period_s);
        GET_CONFIG_ITEM_FROM_JSON(config_items, traffic_upload_interval_ms);
        GET_CONFIG_ITEM_FROM_JSON(config_items, block_period_m);
        GET_CONFIG_ITEM_FROM_JSON(config_items, max_block_period_m);
        GET_CONFIG_ITEM_FROM_JSON(config_items, watch_period_m);
        GET_CONFIG_ITEM_FROM_JSON(config_items, max_watch_period_m);
        GET_CONFIG_ITEM_FROM_JSON(config_items, vote_kick_ratetime_s);
        GET_CONFIG_ITEM_FROM_JSON(config_items, content_filter_super_mode);

        GET_CONFIG_ITEM_FROM_JSON__STRING(config_items, violation_rules_config_file);
        GET_CONFIG_ITEM_FROM_JSON__STRING(config_items, permission_file);
        GET_CONFIG_ITEM_FROM_JSON__STRING(config_items, bad_word_list);
        GET_CONFIG_ITEM_FROM_JSON__STRING(config_items, stop_char_list);

        GET_CONFIG_ITEM_FROM_JSON__STRING(config_items, cloudpack_guid);
    }
    catch (const std::exception& e)
    {
        LOG_ERROR("%s, parse json failed, err:%s", __func__, e.what());
        return false;
    }

    UpdateConfig();
    return true;
}

void Config::OnFileUpdate(const char* file_path)
{
    asio::dispatch(
        m_executor,
        [this, file_path = std::string(file_path)]()
    {
        LOG_INFO("OnFileUpdate, file_path:%s", file_path.c_str());
        ParseConfig(file_path);
    });
}

void Config::UpdateConfig() const
{
    wheat::IPTrafficRecorder::Instance().SetUploadInterval(
        std::chrono::milliseconds(traffic_upload_interval_ms));
    GetViolationRules().SetConfigFile(violation_rules_config_file);
    PermissionMgr::Instance().SetPermissionFile(permission_file);

    if(m_pContentFilter != nullptr)
        m_pContentFilter->SetSuperMode(content_filter_super_mode);
    LOG_INFO("ContentFilter SuperMode %s", content_filter_super_mode ? "Enabled" : "Disabled");
}

ViolationRules::ViolationRules()
{
    std::map<ViolationRuleKey, std::string> rules;
    //添加默认ip规则 连接数=5，每秒发包数100，每秒比特81920(10KB)  
    rules.emplace(ViolationRuleKey{ "ip", "" }, "conn=5,pps=100,bps=81920");
    //为了测试方便，对于127.0.0.1放开限制 
    rules.emplace(ViolationRuleKey{ "ip", "127.0.0.1" }, "conn=1000,pps=100000,bps=819200000");
    UpdateRules(std::move(rules));
}

void ViolationRules::SetExecutor(asio::any_io_executor executor)
{
    m_executor = std::move(executor);
}

void ViolationRules::SetConfigFile(std::filesystem::path path)
{
    if (path == m_config_file_path && !m_config_file_path.empty())
    {
        ParseConfig(m_config_file_path);
        return;
    }

    if (!m_config_file_path.empty())
    {
        common::FileUpdateMonitor::Instance().RemoveFile(m_config_file_path.generic_string().c_str(), this);
    }
    m_config_file_path = std::move(path);
    if (!m_config_file_path.empty())
    {
        common::FileUpdateMonitor::Instance().AddFile(m_config_file_path.generic_string().c_str(), this);
        ParseConfig(m_config_file_path);
    }
}

void ViolationRules::ParseConfig(std::filesystem::path path)
{
    std::ifstream in(path);
    if (!in.is_open())
    {
        LOG_ERROR("%s, open config file:%s failed", __func__, path.generic_string().c_str());
        return;
    }

    try
    {
        auto rule_items = json::parse(in);
        if (!rule_items.is_array())
        {
            LOG_ERROR("%s, invalid config_file", __func__);
            return;
        }

        std::map<ViolationRuleKey, std::string> new_rules;
        for (auto& rule_item : rule_items)
        {
            try
            {
                ViolationRuleKey key;
                key.type = rule_item.at("type"sv);
                if (rule_item.contains("id"sv))
                {
                    key.id = rule_item["id"sv];
                }
                
                new_rules.emplace(std::move(key), rule_item.at("config"sv).get<std::string>());
            }
            catch (const std::exception&)
            {
                LOG_WARN("%s invalid rule_item, no type or no config", __func__);
                continue;
            }
        }
        UpdateRules(std::move(new_rules));
    }
    catch (const std::exception& e)
    {
        LOG_ERROR("%s, parse json failed, err:%s", __func__, e.what());
        return;
    }
}

void ViolationRules::UpdateRules(std::map<ViolationRuleKey, std::string> new_rules)
{
    auto& old_rules = m_rules;

    auto add_rule = [](const ViolationRuleKey& key, const std::string& rule)
    {
        LOG_INFO("add violation rule, type:%s, id:%s, rule:%s", 
            key.type.c_str(), key.id.c_str(), rule.c_str());
        if (key.id.empty())
        {
            ViolationDetector::Instance().AddTypeDetectorRule(key.type, rule);
        }
        else
        {
            ViolationDetector::Instance().AddIdDetectorRule(key.type, key.id, rule);
        }
    };
    auto remove_rule = [](const ViolationRuleKey& key)
    {
        LOG_INFO("remove violation rule, type:%s, id:%s", key.type.c_str(), key.id.c_str());
        if (key.id.empty())
        {
            ViolationDetector::Instance().RemoveTypeDetectorRule(key.type);
        }
        else
        {
            ViolationDetector::Instance().RemoveIdDetectorRule(key.type, key.id);
        }
    };

    auto iter_new = new_rules.begin();
    auto iter_old = old_rules.begin();
    while (iter_new != new_rules.end() && iter_old != old_rules.end())
    {
        auto cmp_result = iter_old->first <=> iter_new->first;
        if (cmp_result < 0)
        {
            remove_rule(iter_old->first);
            ++iter_old;
        }
        else if (cmp_result > 0)
        {
            add_rule(iter_new->first, iter_new->second);
            ++iter_new;
        }
        else
        {
            if (iter_old->second != iter_new->second)
            {
                remove_rule(iter_old->first);
                add_rule(iter_new->first, iter_new->second);
            }
            ++iter_new;
            ++iter_old;
        }
    }
    
    while (iter_new != new_rules.end())
    {
        add_rule(iter_new->first, iter_new->second);
        ++iter_new;
    }
    while (iter_old != old_rules.end())
    {
        remove_rule(iter_old++->first);
    }


    old_rules.swap(new_rules);
}

void ViolationRules::OnFileUpdate(const char* file_path)
{
    asio::dispatch(
        m_executor,
        [this, file_path = std::string(file_path)]() 
    {
        LOG_INFO("OnFileUpdate, file_path:%s", file_path.c_str());
        SetConfigFile(file_path);
    });
}

}
