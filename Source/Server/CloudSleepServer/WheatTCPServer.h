#pragma once

#include "WheatCommand.h"
#include "WheatBedManager.h"

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

	// 连接两个 buf 而生成一个新的 buf，中间用 '\0' 分隔
	void BufferCatenate(char * destBuf, const char * buf1, size_t buf1Size, const char * buf2, size_t buf2Size);

	void SendMessageToFdSet(fd_set inputFdSet, int fdMax, const char * str);
	void SendMessageToFdSet(fd_set inputFdSet, int fdMax, const char * str, size_t len);

private:
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

