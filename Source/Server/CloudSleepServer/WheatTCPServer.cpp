#include "WheatTCPServer.h"
#include "ProjectCommon.h"

#include <iostream>

#define WHEATTCP_BUFFERSIZE 4096

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
	printf("Server Start to Run...\n");

	fd_set fd;
	FD_ZERO(&fd);
	FD_SET(m_socket, &fd);

	int fdMax = static_cast<int>(m_socket);

	while(1) {
		fd_set fdTemp = fd;
		
		int selectRes = select(0, &fdTemp, NULL, NULL, NULL);

		if(selectRes > 0) {
			if(FD_ISSET(m_socket, &fdTemp)) {
				sockaddr_in clientAddr;
				int len = sizeof(sockaddr_in);

				SOCKET clientSocket = accept(m_socket, (sockaddr *)& clientAddr, &len);
					
				FD_SET(clientSocket, &fd);
				fdMax = MAX(fdMax, static_cast<int>(clientSocket));

				printf("New Client %lld Joined  %s:%d\n", clientSocket, inet_ntoa(clientAddr.sin_addr), ntohs(clientAddr.sin_port));

				if(selectRes == 1) {
					continue;
				}
			}
			
			for(int i = 0; i <= fdMax; i++) {
				if(FD_ISSET(i, &fdTemp)) {
					char buf[WHEATTCP_BUFFERSIZE] = {0};
					int recvRes = recv(i, buf, sizeof(buf), 0);
					if(recvRes == SOCKET_ERROR || recvRes == 0) {
						closesocket(i);
						FD_CLR(i, &fd);

						printf("Client %d Left\n", i);
					} else {
						SendMessageToFdSet(fd, fdMax, buf, sizeof(buf));

						printf("Client %d : %s\n", i, buf);
					}
				}
			}
		}
	}
}

void WheatTCPServer::SendMessageToFdSet(fd_set inputFdSet, int fdMax, const char * str) {
	SendMessageToFdSet(inputFdSet, fdMax, str, strlen(str));
}

void WheatTCPServer::SendMessageToFdSet(fd_set inputFdSet, int fdMax, const char * str, size_t len)
{
	for(int i = 0; i < fdMax; i++) {
		if(FD_ISSET(i, &inputFdSet)) {
			if(i == m_socket) {
				continue;
			}
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
