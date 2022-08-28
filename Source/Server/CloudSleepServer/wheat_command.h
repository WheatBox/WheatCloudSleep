#pragma once

#include <string>
#include <variant>

namespace wheat
{
using SleeperId = size_t;
constexpr inline SleeperId INVALID_SLEEPER_ID = (size_t)-1;

struct CmdYourid
{
    SleeperId id;
};

struct CmdSleeper
{
    SleeperId id;
};

struct CmdName
{
    std::string name;
};

enum class SleeperSex
{
    BOY,
    GIRL
};

struct CmdType
{
    SleeperSex sex;
};

struct CmdLeave
{
    SleeperId id;
};

struct CmdSleep
{
    int bed_id;
};

struct CmdGetup
{
    //int bed_id;
};

struct CmdChat
{
    std::string msg;
};

struct Pos
{
    int x = -1;
    int y = -1;
};

constexpr inline Pos INVALID_POS = Pos{ -1, -1 };

struct CmdMove
{
    Pos pos;
};

struct CmdPos
{
    Pos pos;
};

//用于std::visit访问varaint，参见https://zh.cppreference.com/w/cpp/utility/variant/visit
template<class... Ts> struct overloaded : Ts... { using Ts::operator()...; };
template<class... Ts> overloaded(Ts...)->overloaded<Ts...>;

using WheatCommand = std::variant<CmdYourid, CmdSleeper, CmdName, CmdType, CmdLeave, CmdSleep, CmdGetup, CmdChat, CmdMove, CmdPos>;

WheatCommand ParseCommand(std::string_view msg);

std::string PackCommand(const WheatCommand& cmd);

std::string PackCommandWithId(SleeperId id, const WheatCommand& cmd);
}