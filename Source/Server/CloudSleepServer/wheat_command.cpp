#include "wheat_command.h"
#include <stdexcept>
#include "wheat_common.h"
#include "cJSON.h"
#include "logger.h"

namespace wheat
{

    WheatCommand ParseCommand(std::string_view msg)
    {
        /*if (!msg.ends_with('\0'))
        {
            throw std::runtime_error("invalid msg:" + std::string(msg));
        }
        msg = msg.substr(0, msg.size() - 1);

        auto sub_strs = common::Split(msg, "$", true);
        if (sub_strs.size() != 2)
        {
            throw std::runtime_error("invalid msg:" + std::string(msg));
        }*/

        cJSON* pcjson_parsed = cJSON_CreateObject();
        pcjson_parsed = cJSON_Parse(msg.data());

        cJSON* temp1 = (cJSON_GetObjectItem(pcjson_parsed, "Cmd"));
        cJSON* temp2 = (cJSON_GetObjectItem(pcjson_parsed, "Args"));
        if (temp1 == NULL || temp2 == NULL
            || temp1->type == NULL || temp2->type == NULL) {
            LOG_WARN("json get object fail");
            throw std::runtime_error("invalid msg:" + std::string(msg));
            cJSON_Delete(pcjson_parsed);
        }
        else {
            std::string_view command = (temp1->valuestring);
            std::string_view args = (temp2->valuestring);

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
                // return CmdVoteAgree{ std::stoull(std::string(args)) }; 
                return CmdVoteAgree{  };
            }
            else if (command == "refuse")
            {
                // return CmdVoteRefuse{ std::stoull(std::string(args)) }; 
                return CmdVoteRefuse{  };
            }
            else
            {
                throw std::runtime_error("invalid msg:" + std::string(msg));
            }
        }
    }

    std::string ProcCommand(std::string Cmd, std::string Arg1) {
        // std::string ret = "{\"Cmd\":\"" + Cmd + "\",\"Args\" : \"" + Arg1 + "\"}";
        std::string ret = "{\"Cmd\":\"" + Cmd + "\",\"Args\" : [\"" + Arg1 + "\"] }";
        return ret + '\0';
    }

    std::string ProcCommand(std::string Cmd, std::string Arg1, std::string Arg2) {
        // std::string ret = "{\"Cmd\":\"" + Cmd + "\",\"Args\" : \"" + Arg1 + "\""",\"Args\" : \"" + Arg2 + "\"}";
        std::string ret = "{\"Cmd\":\"" + Cmd + "\",\"Args\" : [\"" + Arg1 + "\",\"" + Arg2 + "\"] }";
        return ret + '\0';
    }

    std::string PackCommand(const WheatCommand& cmd)
    {
        return std::visit(overloaded{
            [](CmdYourid arg) { return ProcCommand("yourid", std::to_string(arg.id)); },
            [](CmdSleeper arg) { return ProcCommand("sleeper", std::to_string(arg.id)); },
            [](const CmdName& arg) { return ProcCommand("name", arg.name); },
            [](CmdType arg) { return ProcCommand("type", std::to_string(static_cast<int>(arg.sex))); },
            [](CmdLeave arg) { return ProcCommand("leave", std::to_string(arg.id)); },
            [](CmdSleep arg) { return ProcCommand("sleep", std::to_string(arg.bed_id)); },
            [](CmdGetup) { return ProcCommand("getup", "0"); },
            [](const CmdChat& arg) { return ProcCommand("chat", arg.msg); },
            [](CmdMove arg) { return ProcCommand("move", std::to_string(arg.pos.x), std::to_string(arg.pos.y)); },
            [](CmdPos arg) { return ProcCommand("pos", std::to_string(arg.pos.x), std::to_string(arg.pos.y)); },
            [](CmdVoteKickStart arg) { return ProcCommand("kick", std::to_string(arg.kick_id)); },
            [](CmdVoteState arg) { return ProcCommand("agree", std::to_string(arg.argee), std::to_string(arg.refuse)); },
            [](CmdVoteKickOver) { return ProcCommand("kickover", "0"); },
            [](auto&&) { return std::string(); }
            }, cmd);
    }

    std::string PackCommandWithId(SleeperId id, const WheatCommand& cmd)
    {
        std::string temp = PackCommand(cmd);//能力有限，先把Command的“}”删了，再把id作为addid,append
        // temp.erase(remove(temp.begin(), temp.end(), '}'), temp.end());
        temp = temp.substr(0, temp.size() - 2);
        temp.append(",\"Id\":\"" + std::to_string(id) + "\"}");
        return '\0' + temp;
    }

}
