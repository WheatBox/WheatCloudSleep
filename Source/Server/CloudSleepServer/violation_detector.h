#pragma once
#include <functional>
#include <map>
#include <string>
#include <string_view>

namespace wheat
{

/* 违规检测 
 */
class ViolationDetector
{
public:
    //违规时的回调类型，参数是违规原因 
    using OnViolation = std::function<void(std::string)>;
    //也是单例 
    static ViolationDetector& Instance();
public:
    //设置对于整个类型规则的阈值 
    void SetTypeDetectorRule(const std::string& type, std::string_view threshold);
    //设置对于类型的某个id的阈值 
    void SetIdDetectorRule(const std::string& type, const std::string& id, std::string_view threshold);
    //更新某个类型某个id的当前信息 
    void UpdateInfo(std::string_view type, std::string_view id, std::string_view cur_info);
    //添加对于某个类型某个id的观察者，触发违规时会调用传入的on_violation 
    void AddObserver(const std::string& type, const std::string& id, OnViolation on_violation);
    //移除整个id 
    bool RemoveId(const std::string& type, const std::string& id);
private:

    struct Id
    {
        std::map<std::string, double> threshold_list;
        std::vector<OnViolation> on_violations;
    };

    struct Type
    {
        std::map<std::string, double> threshold_list;
        std::map<std::string, Id, std::less<>> type_all_ids;
    };

    std::map<std::string, Type, std::less<>> m_types;
};


}