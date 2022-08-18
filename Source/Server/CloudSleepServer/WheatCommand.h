#pragma once

#include <string>

enum class WheatCommandType {
	unknown,

	name,
	type,

	sleep,
	getup,

	chat,

	move,
	pos
};

struct WheatCommand {
	WheatCommandType type = WheatCommandType::unknown;
	std::string strParam;
	int nParam[2];
};

// 指令程序员，负责本公司的服务端的指令解析与生成工作
// 指令程序员其实一直暗恋着 TCP服务员(WheatTCPServer)，很幸运，指令程序员在公司里的最经常一同合作的同事就是TCP服务员
class WheatCommandProgrammer {
public:

	// 解析指令
	WheatCommand Parse(const char * buf);

	// 根据指令生成消息
	const char * MakeMessage(WheatCommand & command);

private:

};

