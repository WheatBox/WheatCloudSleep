#include <iostream>
#include <winsock.h>
#include <string>

#include "ProjectCommon.h"
#include "WheatTCPServer.h"

#define MYPORT 11451

int main() {
	WheatTCPServer myServer;
	myServer.Init(MYPORT);
	
	myServer.Run();

	myServer.CloseServer();
	return 0;
}

