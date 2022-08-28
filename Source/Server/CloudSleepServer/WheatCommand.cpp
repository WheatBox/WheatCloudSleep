#include "WheatCommand.h"
#include "ProjectCommon.h"

WheatCommand WheatCommandProgrammer::Parse(const char* buf)
{
	WheatCommand resultCommand;
	
	std::vector<std::string> vecCuttedBuf = CutMessage(buf, '$', 2);

	/* ��ȡ resultCommand.type��CommandTypes���� */

	// ������ڻ����һ�Σ���û���ҵ��ָ����ţ���������˷ָ����ţ����ٻ���2�Σ���ʹ�ڶ���Ϊ���ַ��������Զ���Ϊ unknown
	if(vecCuttedBuf.size() <= 1) {
		resultCommand.type = WheatCommandType::unknown;
		return resultCommand;
	}

	resultCommand.type = GetCommandTypeFromString(vecCuttedBuf[0].c_str());
	
	/* ��ȡ resultCommand.nParam �� resultCommand.strParam��params���� */

	switch(resultCommand.type) {
		case WheatCommandType::yourid:
		case WheatCommandType::sleeper:
			resultCommand.type = WheatCommandType::unknown;
			break;
		case WheatCommandType::name:
			resultCommand.strParam = vecCuttedBuf[1];
			break;
		case WheatCommandType::type:
			resultCommand.nParam[0] = atoi(vecCuttedBuf[1].c_str());
			break;

		case WheatCommandType::leave:
			resultCommand.type = WheatCommandType::unknown;
			break;

		case WheatCommandType::sleep:
			resultCommand.nParam[0] = atoi(vecCuttedBuf[1].c_str());
			break;
		case WheatCommandType::getup:
			break;

		case WheatCommandType::chat:
			resultCommand.strParam = vecCuttedBuf[1];
			break;

		case WheatCommandType::move:
		case WheatCommandType::pos:
		{
			std::vector<std::string> vecPosCutTemp = CutMessage(vecCuttedBuf[1].c_str(), ',');
			resultCommand.nParam[0] = atoi(vecPosCutTemp[0].c_str());
			resultCommand.nParam[1] = atoi(vecPosCutTemp[1].c_str());
		}
		break;

		case WheatCommandType::kick:
			resultCommand.nParam[0] = atoi(vecCuttedBuf[1].c_str());
			break;
		case WheatCommandType::agree:
			break;
		case WheatCommandType::refuse:
			break;
		case WheatCommandType::kickover:
			break;
	}

	return resultCommand;
}

std::string WheatCommandProgrammer::MakeMessage(const WheatCommand& command)
{
	std::string res = "";

	switch(command.type) {
		case WheatCommandType::yourid:
			res = res + "yourid$" + std::to_string(command.nParam[0]);
			break;
		case WheatCommandType::sleeper:
			res = res + "sleeper$" + std::to_string(command.nParam[0]);
			break;
		case WheatCommandType::name:
			res = res + "name$" + command.strParam;
			break;
		case WheatCommandType::type:
			res = res + "type$" + std::to_string(command.nParam[0]);
			break;

		case WheatCommandType::leave:
			res = res + "leave$" + std::to_string(command.nParam[0]);
			break;

		case WheatCommandType::sleep:
			res = res + "sleep$" + std::to_string(command.nParam[0]);
			break;
		case WheatCommandType::getup:
			res += "getup$";
			break;

		case WheatCommandType::chat:
			res = res + "chat$" + command.strParam;
			break;

		case WheatCommandType::move:
			res = res + "move$" + std::to_string(command.nParam[0]) + "," + std::to_string(command.nParam[1]);
			break;
		case WheatCommandType::pos:
			res = res + "pos$" + std::to_string(command.nParam[0]) + "," + std::to_string(command.nParam[1]);
			break;

		case WheatCommandType::kick:
			res = res + "kick$" + std::to_string(command.nParam[0]);
			break;
		case WheatCommandType::agree:
			res = res + "agree$" + std::to_string(command.nParam[0]) + "," + std::to_string(command.nParam[1]);
			break;
		case WheatCommandType::refuse:
			res = res + "refuse$" + std::to_string(command.nParam[0]) + "," + std::to_string(command.nParam[1]);
			break;
		case WheatCommandType::kickover:
			res += "kickover$";
			break;
	}

	const char * szRes = res.c_str();
	return res;
}

std::vector<std::string> WheatCommandProgrammer::CutMessage(const char* buf, const char delimiterChar, int pieces)
{
	return CutMessage(buf, strlen(buf), delimiterChar, pieces);
}

std::vector<std::string> WheatCommandProgrammer::CutMessage(const char* buf, size_t len, const char delimiterChar, int pieces)
{
	std::vector<std::string> result;
	std::string strTemp = buf;

	if(pieces == 1) {
		result.push_back(strTemp);
		return result;
	}

	// ʣ��ĵ�����
	int remainKnives = pieces - 1;

	int l = 0;
	for(int r = 0; r <= len; r++) {
		if(buf[r] == delimiterChar || r == len) {
			if(remainKnives == 0) {
				// == 0�����������ˣ�ʣ�µ�ȫ����
				// < 0�����Ե�����Ϊ���޵��ӣ�˳��һ�� pieces = 0 ʱ remainKnives��ʼֵ = -1������ Ĭ��pieces = 0 ����ȫ����
				result.push_back(strTemp.substr(l));
				break;
			}

			result.push_back(strTemp.substr(l, r - l));
			l = r + 1;

			remainKnives--;
		}
	}

	return result;
}

WheatCommandType WheatCommandProgrammer::GetCommandTypeFromString(const char* sz)
{
	if(strcmp(sz, "yourid") == 0)
		return WheatCommandType::yourid;
	if(strcmp(sz, "sleeper") == 0)
		return WheatCommandType::sleeper;
	if(strcmp(sz, "name") == 0)
		return WheatCommandType::name;
	if(strcmp(sz, "type") == 0)
		return WheatCommandType::type;
	
	if(strcmp(sz, "leave") == 0)
		return WheatCommandType::leave;

	if(strcmp(sz, "sleep") == 0)
		return WheatCommandType::sleep;
	if(strcmp(sz, "getup") == 0)
		return WheatCommandType::getup;

	if(strcmp(sz, "chat") == 0)
		return WheatCommandType::chat;

	if(strcmp(sz, "move") == 0)
		return WheatCommandType::move;
	if(strcmp(sz, "pos") == 0)
		return WheatCommandType::pos;

	if(strcmp(sz, "kick") == 0)
		return WheatCommandType::kick;
	if(strcmp(sz, "agree") == 0)
		return WheatCommandType::agree;
	if(strcmp(sz, "refuse") == 0)
		return WheatCommandType::refuse;
	if(strcmp(sz, "kickover") == 0)
		return WheatCommandType::kickover;
	
	return WheatCommandType::unknown;
}

void WheatCommandProgrammer::PrintWheatCommand(WheatCommand& command)
{
	printf("--------- Command Print ---------\n");
	printf("type: %d\n", static_cast<int>(command.type));
	printf("strParam: %s\n", command.strParam.c_str());
	printf("nParams: [ %d, %d ]\n", command.nParam[0], command.nParam[1]);
	printf("---------------------------------\n");
}

void WheatCommandProgrammer::VectorPushBackOriginalSleepersData(std::vector<int>* vectorDestSleepersIds, std::vector<WheatCommand>* vectorDestSleepersCommands, WheatBedManager & srcBedManager, int originalSleeperId)
{
	std::vector<int>* vecIds = vectorDestSleepersIds;
	std::vector<WheatCommand>* vecCmds = vectorDestSleepersCommands;
	WheatBedManager & bedManager = srcBedManager;
	int sleeperId = originalSleeperId;
	
	vecIds->push_back(sleeperId);
	vecCmds->push_back(WheatCommand(WheatCommandType::sleeper, "", sleeperId, 0));
	vecIds->push_back(sleeperId);
	vecCmds->push_back(WheatCommand(WheatCommandType::name, bedManager.m_sleepers[sleeperId].name.c_str(), 0, 0));
	vecIds->push_back(sleeperId);
	vecCmds->push_back(WheatCommand(WheatCommandType::type, "", static_cast<int>(bedManager.m_sleepers[sleeperId].type), 0));

	if(bedManager.m_sleepers[sleeperId].sleepingBedId != -1) {
		vecIds->push_back(sleeperId);
		vecCmds->push_back(WheatCommand(WheatCommandType::sleep, "", bedManager.m_sleepers[sleeperId].sleepingBedId, 0));
	} else {
		vecIds->push_back(sleeperId);
		vecCmds->push_back(WheatCommand(WheatCommandType::pos, "", bedManager.m_sleepers[sleeperId].posLastData.x, bedManager.m_sleepers[sleeperId].posLastData.y));
		if(bedManager.m_sleepers[sleeperId].firstMoved == true) {
			vecIds->push_back(sleeperId);
			vecCmds->push_back(WheatCommand(WheatCommandType::move, "", bedManager.m_sleepers[sleeperId].moveLastData.x, bedManager.m_sleepers[sleeperId].moveLastData.y));
		}
	}
}

