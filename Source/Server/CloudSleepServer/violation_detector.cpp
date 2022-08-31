#include "violation_detector.h"
#include "wheat_common.h"
#include <charconv>

namespace wheat
{

// "connection=5,pps=100,bps=10240"
std::map<std::string, double>
ParseLoadInfo(std::string_view str)
{
    std::map<std::string, double> result;
    auto load_vec = Split(str, ",");
    for (auto load : load_vec)
    {
        auto pos = load.find("=");
        if (pos != std::string::npos && pos > 0 && pos != load.size() - 1)
        {
            double val;
            auto start = load.data() + pos + 1;
            auto end = load.data() + load.size();
            if (std::from_chars(start, end, val).ec == std::errc())
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

void ViolationDetector::SetTypeDetectorRule(const std::string& type, std::string_view threshold)
{
    m_types[type].threshold_list = ParseLoadInfo(threshold);
}

void ViolationDetector::SetIdDetectorRule(const std::string& type, const std::string& id, std::string_view threshold)
{
    m_types[type].type_all_ids[id].threshold_list = ParseLoadInfo(threshold);
}

void ViolationDetector::UpdateInfo(std::string_view type, std::string_view id, std::string_view cur_info)
{
    auto cur_load_list = ParseLoadInfo(cur_info);
    if (cur_load_list.empty())
        return;

    auto type_iter = m_types.find(type);
    if (type_iter != m_types.end())
    {
        auto& id_list = type_iter->second.type_all_ids;
        auto id_iter = id_list.find(id);
        if (id_iter == id_list.end())
        {
            return;
        }
        const auto& id_info = id_iter->second;
        const auto& threshold_list = id_info.threshold_list.empty() ? 
            type_iter->second.threshold_list : id_info.threshold_list;

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
                    char buffer[256];
                    snprintf(buffer, 256, "cond %s value:%lf more than threshold:%lf",
                        iter1->first.c_str(), iter1->second, iter2->second);
                    for (const auto& on_violation : id_info.on_violations)
                        on_violation(buffer);

                    return;
                }
                else
                {
                    ++iter1;
                    ++iter2;
                }
            }
        }
    }
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
