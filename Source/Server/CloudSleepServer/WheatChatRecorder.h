#pragma once

#include <iostream>
#include <string>

class WheatChatRecorder {
public:
	WheatChatRecorder();

	bool Init();
	void Close();

	bool Record(std::string ip, std::string input);

private:
	FILE * m_file;

};
