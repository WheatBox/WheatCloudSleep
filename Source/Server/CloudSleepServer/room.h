#pragma once

#include <map>
#include <memory>
#include <string_view>
#include <vector>

#include "sleeper.h"
#include "vote_counter.h"

namespace wheat
{

class Sleeper;

/* 房间，Sleeper可以加入房间，同一个房间内的Sleeper能互相看到对方 
 * 负责管理sleeper(加入离开)、管理床位(睡觉/起床)、以及消息的分发 
 */

class Room
{
public:
    explicit Room(asio::any_io_executor executor);

    bool Join(SleeperId id, std::shared_ptr<Sleeper> sleeper);

    void Leave(SleeperId id);

    bool Sleep(SleeperId id, int bed_num);

    void GetUp(SleeperId id);

    bool VoteKickStart(SleeperId id);

    void Agree(SleeperId id);

    void Refuse(SleeperId id);

    void Deliver(std::string_view msg);

private:
    void DeliverToAll(const std::string& msg);

    void SendVoteState();

    void VoteKickOver(SleeperId id, const std::string& ip);

private:
    asio::any_io_executor m_executor;
    std::map<SleeperId, std::shared_ptr<Sleeper>> m_sleepers;
    std::vector<SleeperId> m_beds;

    bool m_is_voting = false;
    VoteCounter<SleeperId> m_vote_counter;

};


}