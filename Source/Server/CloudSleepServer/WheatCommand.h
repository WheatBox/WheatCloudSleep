#pragma once

#include "WheatBedManager.h"

#include <vector>
#include <string>

enum class WheatCommandType {
	unknown,

	yourid,
	sleeper,
	name,
	type,

	leave,

	sleep,
	getup,

	chat,

	move,
	pos,

	kick,
	agree,
	refuse,
	kickover
};

class WheatCommand {
public:
	WheatCommand() {}
	WheatCommand(WheatCommandType _type, const char * _strParam, const int nParam_0, const int nParam_1) { type = _type; strParam = _strParam; nParam[0] = nParam_0; nParam[1] = nParam_1; }

	WheatCommandType type = WheatCommandType::unknown;
	std::string strParam = "";
	int nParam[2] = { 0, 0 };
};

// 指令程序员，负责本公司的服务端的指令解析与生成工作
// 指令程序员其实一直暗恋着 TCP服务员(WheatTCPServer)，很幸运，指令程序员在公司里的最经常一同合作的同事就是TCP服务员
class WheatCommandProgrammer {
public:

	// 解析指令
	WheatCommand Parse(const char * buf);

	// 根据指令生成消息
	std::string MakeMessage(const WheatCommand & command);

	// 切割消息
	// buf 填入要分割的消息，delimiterChar 填入分割符号，pieces 表示要切片的份数，默认0为分割完成每一份
	// 例如 ("ABC$DEF$114$514", '$', 3) 则会得到 "ABC" "DEF" "114$514"
	std::vector<std::string> CutMessage(const char * buf, const char delimiterChar, int pieces = 0);
	std::vector<std::string> CutMessage(const char * buf, size_t len, const char delimiterChar, int pieces = 0);

	WheatCommandType GetCommandTypeFromString(const char * sz);

	void PrintWheatCommand(WheatCommand & command);
	
	void VectorPushBackOriginalSleepersData(std::vector<int> * vectorDestSleepersIds, std::vector<WheatCommand> * vectorDestSleepersCommands, WheatBedManager & srcBedManager, int originalSleeperId);

private:

};

