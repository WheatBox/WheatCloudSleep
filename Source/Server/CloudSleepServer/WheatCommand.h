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

// ָ�����Ա�����𱾹�˾�ķ���˵�ָ����������ɹ���
// ָ�����Ա��ʵһֱ������ TCP����Ա(WheatTCPServer)�������ˣ�ָ�����Ա�ڹ�˾������һͬ������ͬ�¾���TCP����Ա
class WheatCommandProgrammer {
public:

	// ����ָ��
	WheatCommand Parse(const char * buf);

	// ����ָ��������Ϣ
	std::string MakeMessage(const WheatCommand & command);

	// �и���Ϣ
	// buf ����Ҫ�ָ����Ϣ��delimiterChar ����ָ���ţ�pieces ��ʾҪ��Ƭ�ķ�����Ĭ��0Ϊ�ָ����ÿһ��
	// ���� ("ABC$DEF$114$514", '$', 3) ���õ� "ABC" "DEF" "114$514"
	std::vector<std::string> CutMessage(const char * buf, const char delimiterChar, int pieces = 0);
	std::vector<std::string> CutMessage(const char * buf, size_t len, const char delimiterChar, int pieces = 0);

	WheatCommandType GetCommandTypeFromString(const char * sz);

	void PrintWheatCommand(WheatCommand & command);
	
	void VectorPushBackOriginalSleepersData(std::vector<int> * vectorDestSleepersIds, std::vector<WheatCommand> * vectorDestSleepersCommands, WheatBedManager & srcBedManager, int originalSleeperId);

private:

};

