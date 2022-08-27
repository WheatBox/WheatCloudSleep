#include "WheatTCPServer.h"
#include "ProjectCommon.h"

#include "WheatChatRecorder.h"

#include <iostream>

#define WHEATTCP_BUFFERSIZE 256

#pragma comment(lib, "ws2_32.lib")

bool WheatTCPServer::Init(int port) {
	if(WSAStart() == false) {
		return false;
	}
	if(SocketInit() == false) {
		return false;
	}
	SetServerAddress(port);
	if(Bind() == false) {
		return false;
	}
	if(Listen() == false) {
		return false;
	}
	return true;
}

void WheatTCPServer::CloseServer() {
	closesocket(m_socket);
	WSACleanup();
}

void WheatTCPServer::Run()
{
	printf("Server Start to Run.\n");

	WheatChatRecorder wheatChatRecorder;

	fd_set fd;
	FD_ZERO(&fd);
	FD_SET(m_socket, &fd);

	int fdMax = static_cast<int>(m_socket);

	while(1) {
		fd_set fdTemp = fd;
		
		timeval tm;
		tm.tv_sec = 10;
		tm.tv_usec = 0;
		
		int selectRes = select(fdMax, &fdTemp, NULL, NULL, &tm);
		
		// printf("selectRes = %d\n", selectRes);
		// printf("FD_ISSET = %d\n", FD_ISSET(m_socket, &fdTemp));
		
		if(selectRes > 0) {
			if(FD_ISSET(m_socket, &fdTemp)) {
				sockaddr_in clientAddr;
				int len = sizeof(sockaddr_in);

				SOCKET clientSocket = accept(m_socket, (sockaddr *)& clientAddr, &len);
				
				FD_SET(clientSocket, &fd);
				fdMax = MAX(fdMax, static_cast<int>(clientSocket));

				printf("New Client %lld Joined  %s:%d\n", clientSocket, inet_ntoa(clientAddr.sin_addr), ntohs(clientAddr.sin_port));

				int newSleeperId = m_bedManager.RegisterNewSleeper(Sleeper(clientSocket));

				// 记录IP地址
				m_bedManager.m_sleepers[newSleeperId].IPADDRESS = inet_ntoa(clientAddr.sin_addr);
				
				SendCommand(clientSocket, newSleeperId, WheatCommand(WheatCommandType::yourid, "", newSleeperId, 0));
				SendCommandToFdSet(fd, fdMax, newSleeperId, WheatCommand(WheatCommandType::sleeper, "", newSleeperId, 0), clientSocket);

				std::vector<WheatCommand> originalSleepersCommands;
				std::vector<int> originalSleepersIds;
				for(int iSleeperId = 0; iSleeperId < m_bedManager.m_sleepers.size(); iSleeperId++) {
					if(m_bedManager.m_sleepers[iSleeperId].empty == false && iSleeperId != newSleeperId) {
						m_pCommandProgrammer->VectorPushBackOriginalSleepersData(& originalSleepersIds, & originalSleepersCommands, m_bedManager, iSleeperId);
					}
				}
				SendMultiCommand(clientSocket, originalSleepersIds, originalSleepersCommands);


				if(selectRes <= 1) {
					continue;
				}
			}
			
			for(int i = 0; i <= fdMax; i++) {
				if(FD_ISSET(i, &fdTemp)) {
					char buf[WHEATTCP_BUFFERSIZE];
					memset(buf, 0, WHEATTCP_BUFFERSIZE);
					int recvRes = recv(i, buf, sizeof(buf) - 1, 0);
					if(recvRes == SOCKET_ERROR || recvRes == 0) {
						closesocket(i);
						FD_CLR(i, &fd);

						printf("Client %d Left.\n", i);

						int leaveSleeperId = m_bedManager.FindSleeperId(i);

						if(leaveSleeperId < 0 || leaveSleeperId >= m_bedManager.m_sleepers.size()) {
							printf("%d I Don't Know Who Left! SKIP!\n", leaveSleeperId);
						} else {
							SendCommandToFdSet(fd, fdMax, leaveSleeperId, WheatCommand(WheatCommandType::leave, "", leaveSleeperId, 0));
						}
						m_bedManager.CancelSleeper(leaveSleeperId);
					} else {
						// SendMessageToFdSet(fd, fdMax, buf, sizeof(buf));

						// printf("Client %d : %s\n", i, buf);

						WheatCommand command = m_pCommandProgrammer->Parse(buf);
						
						int whoSleeperId = m_bedManager.FindSleeperId(i);

						if(whoSleeperId < 0 || whoSleeperId >= m_bedManager.m_sleepers.size()) {
							command.type = WheatCommandType::unknown;
						}

						switch(command.type) {
							case WheatCommandType::unknown:
								printf("%d Unknown Command! SKIP!\n", i);
								continue;
								break;

							case WheatCommandType::name:
								m_bedManager.m_sleepers[whoSleeperId].name = command.strParam;
								printf("Client %d : %s\n", i, buf);
								wheatChatRecorder.Record(m_bedManager.m_sleepers[whoSleeperId].IPADDRESS, m_bedManager.m_sleepers[whoSleeperId].name);

								break;
							case WheatCommandType::type:
								m_bedManager.m_sleepers[whoSleeperId].type = m_bedManager.GetSleeperType(command.nParam[0]);
								break;

							case WheatCommandType::sleep:
							{
								if(command.nParam[0] >= BED_NUM || command.nParam[0] < 0) {
									printf("Wrong Bed Id!! %d\n", command.nParam[0]);
									continue;
								}

								Bed * pBedTemp = m_bedManager.GetBed(command.nParam[0]);
								if(!pBedTemp->Empty()) {
									printf("Bed Is Not Empty. %d Can Not Sleep.\n", i);
									continue;
								} else {
									printf("%d Sleep On Bed Which Is BedSleepId = %d\n", i, command.nParam[0]);
									pBedTemp->Set(false, m_bedManager.GetSleeper(m_bedManager.FindSleeperId(i)));
									m_bedManager.m_sleepers[whoSleeperId].sleepingBedId = command.nParam[0];
								}
							}
							break;
							case WheatCommandType::getup:
								if(m_bedManager.m_sleepers[whoSleeperId].sleepingBedId != -1) {
									m_bedManager.GetupBed(m_bedManager.m_sleepers[whoSleeperId].sleepingBedId);
									m_bedManager.m_sleepers[whoSleeperId].sleepingBedId = -1;
								}
								break;

							case WheatCommandType::chat:
								printf("Client %d : %s\n", i, buf);
								wheatChatRecorder.Record((m_bedManager.m_sleepers[whoSleeperId].IPADDRESS + "_" + m_bedManager.m_sleepers[whoSleeperId].name + "}:=>"), command.strParam);
								break;

							case WheatCommandType::move:
								m_bedManager.m_sleepers[whoSleeperId].moveLastData = Vec2<int>(command.nParam[0], command.nParam[1]);
								m_bedManager.m_sleepers[whoSleeperId].firstMoved = true;
								break;
							case WheatCommandType::pos:
								m_bedManager.m_sleepers[whoSleeperId].posLastData = Vec2<int>(command.nParam[0], command.nParam[1]);
								break;
						}

						// m_pCommandProgrammer->PrintWheatCommand(command);

						SendCommandToFdSet(fd, fdMax, whoSleeperId, command);

					}
				}
			}
		}
	}
}

void WheatTCPServer::SendCommand(SOCKET destSocket, int sleeperIdWhoMakeThisCommand, const WheatCommand& command)
{
	int & sleeperId = sleeperIdWhoMakeThisCommand;
	std::string strSleeperId = "";
	std::string strMessage = "";
	size_t bufSendSize = 0;
	char * bufSend = nullptr;

	strSleeperId = std::to_string(sleeperId);
	strMessage = m_pCommandProgrammer->MakeMessage(command);

	bufSendSize = strSleeperId.length() + 1 + strMessage.length() + 1;

	bufSend = new char[bufSendSize];

	BufferCatenate(bufSend, strSleeperId.c_str(), strSleeperId.length(), strMessage.c_str(), strMessage.length());

	send(destSocket, bufSend, int(bufSendSize), 0);

	printf("%s %s, Socket = %zd\n", bufSend, bufSend + 2, destSocket);

	delete [] bufSend;
	bufSend = nullptr;
}

void WheatTCPServer::SendCommandToFdSet(fd_set destFdSet, int fdMax, int sleeperIdWhoMakeThisCommand, const WheatCommand& command, SOCKET skipSocket)
{
	int & sleeperId = sleeperIdWhoMakeThisCommand;
	std::string strSleeperId = "";
	std::string strMessage = "";
	size_t bufSendSize = 0;
	char * bufSend = nullptr;

	strSleeperId = std::to_string(sleeperId);
	strMessage = m_pCommandProgrammer->MakeMessage(command);

	bufSendSize = strSleeperId.length() + 1 + strMessage.length() + 1;

	bufSend = new char[bufSendSize];

	BufferCatenate(bufSend, strSleeperId.c_str(), strSleeperId.length(), strMessage.c_str(), strMessage.length());

	SendBufferToFdSet(destFdSet, fdMax, bufSend, bufSendSize, skipSocket);

	delete [] bufSend;
	bufSend = nullptr;
}

void WheatTCPServer::SendMultiCommand(SOCKET destSocket, std::vector<int> & sleeperIdWhoMakeTheseCommands, const std::vector<WheatCommand>& commands)
{
	std::vector<int> & sleeperIds = sleeperIdWhoMakeTheseCommands;
	std::string strSleeperId = "";
	std::string strMessage = "";
	size_t bufSendSize = 0;
	size_t bufCatenateOffset = 0;
	size_t strLen = 0;
	char * bufSend = nullptr; // = new char[20000];
	char * bufTemp;
	
	for(int i = 0; i < commands.size(); i++) {
		strSleeperId = std::to_string(sleeperIds[i]);
		strMessage = m_pCommandProgrammer->MakeMessage(commands[i]);
		strLen = strSleeperId.length() + 1 + strMessage.length() + 1;

		bufCatenateOffset = bufSendSize;

		bufSendSize += strLen;

		// bufTemp 用来存储前面此次这一段消息（strSleeperId 和 strMessage）
		bufTemp = new char[strLen];

		// BufferCatenate(bufSend, bufCatenateOffset, strSleeperId.c_str(), strSleeperId.length(), strMessage.c_str(), strMessage.length());
		BufferCatenate(bufTemp, 0, strSleeperId.c_str(), strSleeperId.length(), strMessage.c_str(), strMessage.length());

		// 将bufSend存起来
		char * bufSave = new char[bufCatenateOffset];
		memcpy(bufSave, bufSend, bufCatenateOffset);
		
		// 删除旧的bufSend，并整个新的
		if(bufSend != nullptr)
			delete [] bufSend;
		bufSend = new char[bufSendSize];

		// 把提前存储的旧的 bufSend 拷贝过来
		memcpy(bufSend, bufSave, bufCatenateOffset);

		// 把前面拼合而成的 bufTemp 拷贝过来
		memcpy(bufSend + bufCatenateOffset, bufTemp, strLen);

		// 清理 bufTemp 和 bufSave
		delete [] bufSave;
		delete [] bufTemp;
	}

	if(bufSend != nullptr) {
		send(destSocket, bufSend, int(bufSendSize), 0);

		delete [] bufSend;
		bufSend = nullptr;
	}
}

void WheatTCPServer::BufferCatenate(char* destBuf, const char* buf1, size_t buf1Size, const char* buf2, size_t buf2Size)
{
	memcpy(destBuf, buf1, buf1Size + 1);
	memcpy(destBuf + buf1Size + 1, buf2, buf2Size + 1);
}

void WheatTCPServer::BufferCatenate(char * destBuf, size_t offset, const char * buf1, size_t buf1Size, const char * buf2, size_t buf2Size)
{
	memcpy(destBuf + offset, buf1, buf1Size + 1);
	memcpy(destBuf + offset + buf1Size + 1, buf2, buf2Size + 1);
}

void WheatTCPServer::SendBufferToFdSet(fd_set inputFdSet, int fdMax, const char * str) {
	SendBufferToFdSet(inputFdSet, fdMax, str, strlen(str));
}

void WheatTCPServer::SendBufferToFdSet(fd_set inputFdSet, int fdMax, const char * str, size_t len, SOCKET skipSocket)
{
	for(int i = 0; i <= fdMax; i++) {
		if(i == skipSocket || i == m_socket) {
			continue;
		}
		if(FD_ISSET(i, &inputFdSet)) {
			send(i, str, int(len), 0);
		}
	}
}

bool WheatTCPServer::WSAStart() {
	if(WSAStartup(MAKEWORD(2, 2), &m_WSAData) != 0) {
		printf("WSAStartup Failed!\n");
		return false;
	}
	printf("WSAStartup Succeed.\n");
	return true;
}

bool WheatTCPServer::SocketInit()
{
	m_socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if(m_socket == INVALID_SOCKET) {
		printf("socket Error!! %d\n", WSAGetLastError());
		WSACleanup();
		return false;
	}
	printf("socket Succeed.\n");
	return true;
}

void WheatTCPServer::SetServerAddress(int port) {
	m_address.sin_family = AF_INET;
	m_address.sin_port = htons(port);
	m_address.sin_addr.S_un.S_addr = htonl(INADDR_ANY);
}

bool WheatTCPServer::Bind()
{
	int bindRes = bind(m_socket, (sockaddr *)& m_address, sizeof(SOCKADDR_IN));
	if(bindRes == SOCKET_ERROR) {
		printf("bind Error!!\n");
		CloseServer();
		return false;
	}
	printf("bind Succeed.\n");
	return true;
}

bool WheatTCPServer::Listen()
{
	int listenRes = listen(m_socket, SOMAXCONN);
	if(listenRes == SOCKET_ERROR) {
		printf("listen Error!!\n");
		CloseServer();
		return false;
	}
	printf("listen Succeed.\n");
	return true;
}
