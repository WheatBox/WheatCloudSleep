#pragma once

#include <winsock.h>

// TCP服务员，在本公司负责TCP协议的数据传输服务，专门处理睡客们的需求，并代替睡客们和内部工作人员交流
// 她昨天刚和男朋友分手，所以心情不太好，可能会搞错一些数据造成BUG
class WheatTCPServer {
public:
	// WheatTCPServer();
	// virtual ~WheatTCPServer();

	bool Init(int port);
	void CloseServer();

	void Run();

	void SendMessageToFdSet(fd_set inputFdSet, int fdMax, const char * str);
	void SendMessageToFdSet(fd_set inputFdSet, int fdMax, const char * str, size_t len);

private:
	WSADATA m_WSAData;
	SOCKET m_socket;
	sockaddr_in m_address;

	bool WSAStart();
	bool SocketInit();
	void SetServerAddress(int port);
	bool Bind();
	bool Listen();
};

