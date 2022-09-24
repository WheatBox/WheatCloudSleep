#include "violation_detector.h"

#include <charconv>
#include <cstdlib>

#include "wheat_common.h"

namespace wheat
{

// "connection=5,pps=100,bps=10240"
std::map<std::string, double>
ParseLoadInfo(std::string_view str)
{
    std::map<std::string, double> result;
    auto load_vec = common::Split(str, ",");
    for (auto load : load_vec)
    {
        auto pos = load.find("=");
        if (pos != std::string::npos && pos > 0 && pos != load.size() - 1)
        {

            /* 不少编译器要到很高版本才支持from_chars的浮点数版本，先用strtod代替 
            double val;
            auto start = load.data() + pos + 1;
            auto end = load.data() + load.size();
            if (std::from_chars(start, end, val).ec == std::errc())
            {
                result.emplace(std::string(load.data(), pos), val);
            }
            */

            auto start = load.data() + pos + 1;
            char* str;
            double val = strtod(start, &str);
            if (!(val == 0.0 && str == start))
            {
                result.emplace(std::string(load.data(), pos), val);
            }
        }
    }

    return result;
}


ViolationDetector& ViolationDetector::Instance()
{
    static ViolationDetector g_detector;
    return g_detector;
}

void ViolationDetector::AddTypeDetectorRule(const std::string& type, std::string_view threshold)
{
    m_types[type].threshold_list = ParseLoadInfo(threshold);
}

void ViolationDetector::RemoveTypeDetectorRule(const std::string& type)
{
    auto iter_type = m_types.find(type);
    if (iter_type != m_types.end())
    {
        auto& type_obj = iter_type->second;
        if (type_obj.type_all_ids.empty())
        {
            m_types.erase(iter_type);
        }
        else
        {
            type_obj.threshold_list.clear();
        }
    }
}

void ViolationDetector::AddIdDetectorRule(const std::string& type, const std::string& id, std::string_view threshold)
{
    m_types[type].type_all_ids[id].threshold_list = ParseLoadInfo(threshold);
}

void ViolationDetector::RemoveIdDetectorRule(const std::string& type, const std::string& id)
{
    auto iter_type = m_types.find(type);
    if (iter_type != m_types.end())
    {
        auto& ids = iter_type->second.type_all_ids;
        auto iter_id = ids.find(id);
        if (iter_id != ids.end())
        {
            auto& id_obj = iter_id->second;
            if (id_obj.on_violations.empty())
            {
                ids.erase(iter_id);
            }
            else
            {
                id_obj.threshold_list.clear();
            }
        }
    }
}

void ViolationDetector::UpdateInfo(std::string_view type, std::string_view id, std::string_view cur_info)
{
    auto cur_load_list = ParseLoadInfo(cur_info);
    if (cur_load_list.empty())
        return;

    auto type_iter = m_types.find(type);
    if (type_iter == m_types.end())
        return;

    auto& id_list = type_iter->second.type_all_ids;
    auto id_iter = id_list.find(id);
    if (id_iter == id_list.end())
        return;

    auto& id_info = id_iter->second;
    const auto& threshold_list = id_info.threshold_list.empty() ? 
        type_iter->second.threshold_list : id_info.threshold_list;

    std::vector<OnViolation> on_violations;
    char reason[256] = {};
    //map是有序的，可以按顺序比较，不用find，时间复杂度O(m+n) 
    auto iter1 = cur_load_list.begin();
    auto iter2 = threshold_list.begin();
    while (iter1 != cur_load_list.end() && iter2 != threshold_list.end())
    {
        auto cmp_result = iter1->first <=> iter2->first;
        if (cmp_result < 0)
        {
            ++iter1;
        }
        else if (cmp_result > 0)
        {
            ++iter2;
        }
        else
        {
            //超过阈值，调用on_violation 
            if (iter1->second > iter2->second)
            {
                snprintf(reason, 256, "type:%s. id:%s, cond %s value:%lf more than threshold:%lf",
                    type.data(), id.data(), iter1->first.c_str(), iter1->second, iter2->second);
                on_violations.swap(id_info.on_violations);
                break;
            }
            else
            {
                ++iter1;
                ++iter2;
            }
        }
    }

    for (const auto& on_violation : on_violations)
        on_violation(reason);
}

void ViolationDetector::AddObserver(const std::string& type, const std::string& id, OnViolation on_violation)
{
    m_types[type].type_all_ids[id].on_violations.emplace_back(std::move(on_violation));
}

bool ViolationDetector::RemoveId(const std::string& type, const std::string& id)
{
    auto iter1 = m_types.find(type);
    if (iter1 != m_types.end())
    {
        auto& id_list = iter1->second.type_all_ids;
        auto iter2 = id_list.find(id);
        if (iter2 != id_list.end())
        {
            auto& id_info = iter2->second;
            //如果设置了id的规则，那么不能直接删 
            if (id_info.threshold_list.empty())
            {
                id_list.erase(iter2);
                if (id_list.empty() && iter1->second.threshold_list.empty())
                {
                    m_types.erase(iter1);
                }
            }
            else
            {
                id_info.on_violations.clear();
            }
            return true;
        }
    }
    return false;
}

}
