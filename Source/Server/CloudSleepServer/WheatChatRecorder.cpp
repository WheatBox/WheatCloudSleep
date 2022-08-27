#include "WheatChatRecorder.h"

WheatChatRecorder::WheatChatRecorder() {
	// Init();
}

bool WheatChatRecorder::Init()
{
	m_file = fopen("records.txt", "a");

	return true;
}

void WheatChatRecorder::Close() {
	fclose(m_file);
}

bool WheatChatRecorder::Record(std::string ip, std::string input)
{
	Init();

	fputs((ip + "}:" + input + "\n").c_str(), m_file);

	Close();

	return true;
}
