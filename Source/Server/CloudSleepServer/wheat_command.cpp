#include "wheat_command.h"
#include <stdexcept>
#include <vector>

namespace wheat
{

std::vector<std::string_view> 
Split(std::string_view str, std::string_view delimiter, bool allow_empty = false)
{
    std::vector<std::string_view> vec;
    if (delimiter.empty())
    {
        return vec;
    }

    std::size_t current = 0;
    std::size_t index = 0;
    while ((index = str.find(delimiter, current)) != str.npos)
    {
        if (index - current != 0 || allow_empty)
        {
            vec.emplace_back(str.data() + current, index - current);
        }
        current = index + delimiter.length();
    }
    if (current < str.length() || allow_empty)
    {
        vec.emplace_back(str.data() + current, str.length() - current);
    }
    return vec;
}


WheatCommand ParseCommand(std::string_view msg)
{
    if (!msg.ends_with('\0'))
    {
        throw std::runtime_error("invalid msg:" + std::string(msg));
    }
    msg = msg.substr(0, msg.size() - 1);

    auto sub_strs = Split(msg, "$", true);
    if (sub_strs.size() != 2)
    {
        throw std::runtime_error("invalid msg:" + std::string(msg));
    }

    std::string_view command = sub_strs[0];
    std::string_view args = sub_strs[1];

    auto make_pos = [](std::string_view pos_str) {
        auto delim_pos = pos_str.find(',');
        if (delim_pos == std::string::npos)
        {
            throw std::runtime_error("invalid pos:" + std::string(pos_str));
            return INVALID_POS;
        }
        else
        {
            return Pos{ atoi(pos_str.data()), atoi(pos_str.data() + delim_pos + 1) };
        }
    };

    if (command == "name")
    {
        return CmdName{ std::string(args) };
    }
    else if (command == "type")
    {
        return CmdType{ SleeperSex(std::stoi(std::string(args))) };
    }
    else if (command == "sleep")
    {
        return CmdSleep{ std::stoi(std::string(args)) };
    }
    else if (command == "getup")
    {
        return CmdGetup{ };
    }
    else if (command == "chat")
    {
        return CmdChat{ std::string(args) };
    }
    else if (command == "move")
    {
        return CmdMove{ make_pos(args) };
    }
    else if (command == "pos")
    {
        return CmdPos{ make_pos(args) };
    }
    else if (command == "kick")
    {
        return CmdVoteKickStart{ std::stoull(std::string(args)) };
    }
    else if (command == "agree")
    {
        return CmdVoteAgree{ std::stoull(std::string(args)) };
    }
    else if (command == "refuse")
    {
        return CmdVoteRefuse{ std::stoull(std::string(args)) };
    }
    else
    {
        throw std::runtime_error("invalid msg:" + std::string(msg));
    }
}

std::string PackCommand(const WheatCommand& cmd)
{
    return std::visit(overloaded{
        [](CmdYourid arg) { return "yourid$" + std::to_string(arg.id); },
        [](CmdSleeper arg) { return "sleeper$" + std::to_string(arg.id); },
        [](const CmdName& arg) { return "name$" + arg.name; },
        [](CmdType arg) { return "type$" + std::to_string(static_cast<int>(arg.sex)); },
        [](CmdLeave arg) { return "leave$" + std::to_string(arg.id); },
        [](CmdSleep arg) { return "sleep$" + std::to_string(arg.bed_id); },
        [](CmdGetup arg) { return std::string("getup$") /* + arg.bed_id*/; },
        [](const CmdChat& arg) { return "chat$" + arg.msg; },
        [](CmdMove arg) { return "move$" + std::to_string(arg.pos.x) + ',' + std::to_string(arg.pos.y); },
        [](CmdPos arg) { return "pos$" + std::to_string(arg.pos.x) + ',' + std::to_string(arg.pos.y); },
        [](CmdVoteKickStart arg) { return "kick$" + std::to_string(arg.kick_id); },
        [](CmdVoteState arg) { return "agree$" + std::to_string(arg.argee) + ',' + std::to_string(arg.refuse); },
        [](CmdVoteKickOver) { return std::string("kickover$"); },
        [](auto&&) { return std::string(); }
    }, cmd);
}

std::string PackCommandWithId(SleeperId id, const WheatCommand& cmd)
{
    return std::to_string(id) + '\0' + PackCommand(cmd) + '\0';
}

}
