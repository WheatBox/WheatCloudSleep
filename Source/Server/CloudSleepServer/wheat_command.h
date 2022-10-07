#pragma once

#include <string>
#include <variant>

#include "wheat_error_code.h"

namespace wheat
{
using SleeperId = uint64_t;
constexpr inline SleeperId INVALID_SLEEPER_ID = (uint64_t)-1;

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

/*enum class SleeperSex
{
    BOY,
    GIRL
};*/
typedef int SleeperSex;

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

struct CmdVoteKickStart
{
    SleeperId kick_id;
};

struct CmdVoteAgree
{
    // SleeperId id; 
};

struct CmdVoteRefuse
{
    // SleeperId id; 
};

struct CmdVoteState
{
    size_t argee;
    size_t refuse;
};

struct CmdVoteKickOver
{

};

struct CmdError
{
    WheatErrorCode error_code;
};

struct CmdPackGuid
{
    std::string guid;
};

//用于std::visit访问varaint，参见https://zh.cppreference.com/w/cpp/utility/variant/visit 
template<class... Ts> struct overloaded : Ts... { using Ts::operator()...; };
template<class... Ts> overloaded(Ts...)->overloaded<Ts...>;

using WheatCommand = std::variant<std::monostate, CmdYourid, CmdSleeper, CmdName, CmdType, 
    CmdLeave, CmdSleep, CmdGetup, CmdChat, CmdMove, CmdPos, CmdVoteKickStart, CmdVoteAgree, 
    CmdVoteRefuse, CmdVoteState, CmdVoteKickOver, CmdError, CmdPackGuid>;

WheatCommand ParseCommand(std::string_view msg);

std::string PackCommand(const WheatCommand& cmd);

std::string PackCommandWithId(SleeperId id, const WheatCommand& cmd);
}