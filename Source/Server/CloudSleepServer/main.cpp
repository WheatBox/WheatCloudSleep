#include <iostream>
#include <winsock.h>
#include <string>

#include "ProjectCommon.h"
#include "WheatTCPServer.h"
#include "WheatCommand.h"

#include "WheatChatRecorder.h"

#define MYPORT 11451

int main() {
	system("chcp 65001"); // ����Ϊ Unicode(UTF-8 ��ǩ��) - ����ҳ 65001

	WheatTCPServer myServer(MYPORT);
	
	myServer.Run();

	myServer.CloseServer();

	return 0;
}

