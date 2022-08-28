#include "room.h"
#include "wheat_command.h"
#include <algorithm>
#include "logger.h"

namespace wheat
{

void Room::Join(SleeperId id, std::shared_ptr<Sleeper> sleeper)
{
    if (m_sleepers.contains(id))
    {
        LOG_WARN("%s, sleeper:%lld already join", __func__, id);
    }
    else
    {
        LOG_INFO("%s, sleeper:%lld join", __func__, id);

        sleeper->Deliver(PackCommandWithId(id, CmdYourid{ id }));
        DeliverToAll(PackCommandWithId(id, CmdSleeper{ id }));
        for (const auto& [_, old_sleeper] : m_sleepers)
        {
            sleeper->Deliver(old_sleeper->MakeSelfInfo());
        }
        m_sleepers.emplace(id, std::move(sleeper));
    }
}

void Room::Leave(SleeperId id)
{
    auto iter = m_sleepers.find(id);
    if (iter != m_sleepers.end())
    {
        GetUp(id);
        LOG_INFO("%s, sleeper:%d leave", __func__, id);
        m_sleepers.erase(iter);
        DeliverToAll(PackCommandWithId(id, CmdLeave{ id }));
    }
    else
    {
        LOG_INFO("%s, sleeper:%d not join", __func__, id);
    }
}

bool Room::Sleep(SleeperId id, int bed_num)
{
    if (bed_num >= 0 && bed_num < DEFAULT_MAX_BED_NUM)
    {
        auto& pre_sleeper_id = m_beds[bed_num];
        if (pre_sleeper_id == INVALID_SLEEPER_ID)
        {
            LOG_INFO("%s, sleeper:%lld sleep on bed:%d", __func__, id, bed_num);
            pre_sleeper_id = id;
            return true;
        }
        else
        {
            LOG_ERROR("%s, bed:%d is not empty, previos sleeper:%lld, sleeper:%lld", 
                __func__, bed_num, pre_sleeper_id, id);
        }
    }

    return false;
}

void Room::GetUp(SleeperId id)
{
    auto iter = std::find(m_beds.begin(), m_beds.end(), id);
    if (iter != m_beds.end())
    {
        LOG_INFO("%s, sleeper:%lld getup on bed:%d", __func__, id, *iter);
        *iter = INVALID_SLEEPER_ID;
    }
    else
    {
        LOG_WARN("%s, sleeper:%lld not sleep", __func__, id);
    }
}

void Room::Deliver(SleeperId src_id, std::string_view msg)
{
    DeliverToAll(std::to_string(src_id) + '\0' + std::string(msg));
}

void Room::DeliverToAll(const std::string& msg)
{
    for (const auto& [_, sleeper] : m_sleepers)
    {
        sleeper->Deliver(std::string(msg));
    }
}


}