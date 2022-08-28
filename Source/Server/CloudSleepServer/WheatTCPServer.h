#pragma once

#define FD_SETSIZE 1024

#include "WheatCommand.h"
#include "WheatBedManager.h"
#include "WheatVote.h"

#include <winsock.h>

// TCP服务员，在本公司负责TCP协议的数据传输服务，专门处理睡客们的需求，并代替睡客们和内部工作人员交流
// 她昨天刚和男朋友分手 *哭哭*，所以心情不太好，可能会搞错一些数据造成BUG
class WheatTCPServer {
public:
	WheatTCPServer() {};
	WheatTCPServer(int port) { Init(port); };
	// virtual ~WheatTCPServer();

	bool Init(int port);
	void CloseServer();

	void Run();

private:

	WheatVote m_voteKick;

	// 发送指令
	// destSocket				目标客户端的 Socket
	// sleeperIdWhoMakeThisCommand	填写产生这条指令的睡客的 睡客Id
	void SendCommand(SOCKET destSocket, int sleeperIdWhoMakeThisCommand, const WheatCommand & command);
	void SendCommandToFdSet(fd_set destFdSet, int fdMax, int sleeperIdWhoMakeThisCommand, const WheatCommand & command, SOCKET skipSocket = -1);

	// 将多条指令合包后一次发送
	void SendMultiCommand(SOCKET destSocket, std::vector<int> & sleeperIdWhoMakeTheseCommands, const std::vector<WheatCommand> & command);

	// 连接两个 buf 而生成一个新的 buf，中间用 '\0' 分隔
	void BufferCatenate(char * destBuf, const char * buf1, size_t buf1Size, const char * buf2, size_t buf2Size);
	void BufferCatenate(char * destBuf, size_t offset, const char * buf1, size_t buf1Size, const char * buf2, size_t buf2Size);

	void SendBufferToFdSet(fd_set inputFdSet, int fdMax, const char * str);
	void SendBufferToFdSet(fd_set inputFdSet, int fdMax, const char * str, size_t len, SOCKET skipSocket = -1);

	// 断开连接某一客户端
	void CloseClient(SOCKET sock, fd_set * fdSet, int fdSetMax);


	WSADATA m_WSAData;
	SOCKET m_socket;
	sockaddr_in m_address;

	WheatCommandProgrammer * m_pCommandProgrammer = nullptr;

	WheatBedManager m_bedManager;

	bool WSAStart();
	bool SocketInit();
	void SetServerAddress(int port);
	bool Bind();
	bool Listen();
};

