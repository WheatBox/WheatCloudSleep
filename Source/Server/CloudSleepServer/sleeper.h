#pragma once
#include <memory>
#include <deque>
#include <string>
#include <atomic>
#include <vector>

#include <asio.hpp>

#include "wheat_command.h"
#include "detect_rule.h"

namespace wheat
{

//产生全局唯一的sleeper_id
SleeperId MakeSleeperId();
class Room;


/* Sleeper，基本用户的概念
 */
class Sleeper
    : public std::enable_shared_from_this<Sleeper>
{
    using socket = asio::ip::tcp::socket;
public:
    Sleeper(Room& room, socket sock, std::vector<std::shared_ptr<detect_rule::RuleBase>>&& rules);

    void Start();

    void Stop();

    std::string GetIp() const;

    //下发消息给端
    void Deliver(std::string msg);

    //自身的基本信息，sleeper加入房间后，房间获取并下发送所有其他sleeper的信息给ta 
    std::string MakeSelfInfo() const;
private:
    asio::awaitable<void> Reader();

    asio::awaitable<void> Writer();
private:
    Room& m_room;
    SleeperId m_id;
    socket m_sock;
    std::string m_name = "_";
    SleeperSex m_sex = SleeperSex::BOY;
    int m_bed_id = -1;
    Pos m_pos = INVALID_POS;

    asio::steady_timer m_timer;   //此定时器用于发送消息队列的同步，asio常用做法 
    std::deque<std::string> m_write_msgs;

    std::vector<std::shared_ptr<detect_rule::RuleBase>> rules_;
};


}