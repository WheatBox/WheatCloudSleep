#pragma once

#include <atomic>
#include <deque>
#include <memory>
#include <string>

#include <asio.hpp>

#include "content_filter.h"
#include "wheat_command.h"

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
    Sleeper(Room& room, socket sock, std::shared_ptr<ContentFilter> content_filter);

    void Start();

    void Stop();

    std::string GetIp() const;

    //下发消息给端
    void Deliver(std::string msg);

    //自身的基本信息，sleeper加入房间后，房间获取并下发送所有其他sleeper的信息给ta 
    std::string MakeSelfInfo() const;

    inline int GetBedId() { return m_bed_id; }
    inline void ClearBedId() { m_bed_id = -1; }

private:
    bool EliminateBadWord(std::string& msg) const noexcept;

    void SyncDeliver(const std::string& msg);

    asio::awaitable<void> Reader();

    asio::awaitable<void> Writer();
private:
    Room& m_room;
    SleeperId m_id;
    socket m_sock;
    bool m_is_administrator = false;
    asio::ip::address_v4 m_ip;
    bool m_is_stoped = false;
    std::string m_name = "_";
    // SleeperSex m_sex = SleeperSex::BOY;
    SleeperSex m_sex = 0;
    int m_bed_id = -1;
    Pos m_pos = INVALID_POS;
    bool m_receivedPackGuid = false;
    std::chrono::steady_clock::time_point m_lastVoteTime;

    asio::steady_timer m_timer;   //此定时器用于发送消息队列的同步，asio常用做法 
    std::deque<std::string> m_write_msgs;

    std::shared_ptr<ContentFilter> m_content_filter;
};


}