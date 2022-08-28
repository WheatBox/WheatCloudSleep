#pragma once
#include <array>
#include <memory>
#include <map>
#include <string_view>
#include "sleeper.h"

namespace wheat
{

constexpr size_t DEFAULT_MAX_BED_NUM = 256;
class Sleeper;

/* 房间，Sleeper可以加入房间，同一个房间内的Sleeper能互相看到对方
 * 负责管理sleeper(加入离开)、管理床位(睡觉/起床)、以及消息的分发 
 */
class Room
{
public:
    Room() { for (auto& id : m_beds) id = INVALID_SLEEPER_ID; };

    void Join(SleeperId id, std::shared_ptr<Sleeper> sleeper);

    void Leave(SleeperId id);

    bool Sleep(SleeperId id, int bed_num);

    void GetUp(SleeperId id);

    void Deliver(SleeperId src_id, std::string_view msg);

private:
    void DeliverToAll(const std::string& msg);

private:
    std::map<SleeperId, std::shared_ptr<Sleeper>> m_sleepers;
    std::array<SleeperId, DEFAULT_MAX_BED_NUM> m_beds;
};


}