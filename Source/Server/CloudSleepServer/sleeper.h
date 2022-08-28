#pragma once
#include <asio.hpp>
#include <memory>
#include <deque>
#include <string>
#include <atomic>
#include "wheat_command.h"

namespace wheat
{

//����ȫ��Ψһ��sleeper_id
SleeperId MakeSleeperId();
class Room;


/* Sleeper�������û��ĸ���
 */
class Sleeper
    : public std::enable_shared_from_this<Sleeper>
{
    using socket = asio::ip::tcp::socket;
public:
    Sleeper(Room& room, socket sock);

    void Start();

    //�·���Ϣ����
    void Deliver(std::string msg);

    //����Ļ�����Ϣ��sleeper���뷿��󣬷����ȡ���·�����������sleeper����Ϣ��ta
    std::string MakeSelfInfo() const;
private:
    asio::awaitable<void> Reader();

    asio::awaitable<void> Writer();

    void Stop();
private:
    Room& m_room;
    SleeperId m_id;
    socket m_sock;
    std::string m_name = "_";
    SleeperSex m_sex = SleeperSex::BOY;
    int m_bed_id = -1;
    Pos m_pos = INVALID_POS;

    asio::steady_timer m_timer;   //�˶�ʱ�����ڷ�����Ϣ���е�ͬ����asio��������
    std::deque<std::string> m_write_msgs;
};


}