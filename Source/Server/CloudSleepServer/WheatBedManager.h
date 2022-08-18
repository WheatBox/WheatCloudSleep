#pragma once

#include <winsock.h>
#include <vector>
#include <string>

enum class SleeperType {
	Girl,
	Boy
};

class Sleeper {
public:
	bool online = false;
	SOCKET sock;
	std::string name;
	SleeperType type = SleeperType::Boy;

	void init(bool _online, SOCKET _sock, std::string _name, SleeperType _type) {
		online = _online;
		sock = _sock;
		name = _name;
		type = _type;
	}

	void copy(Sleeper & another) {
		online = another.online;
		sock = another.sock;
		name = another.name;
		type = another.type;
	}

	void clear() {
		online = false;
	}

	SleeperType TransformIntToSleeperType(int _intval);
};

class Bed {
public:
	bool empty = true;
	Sleeper * pSleeper = &sleeper;

private:
	Sleeper sleeper;
};

// 床位经理，担任本公司的床位经理，负责来往睡客们的床位起居
class WheatBedManager {
public:

	// 从床上醒来
	void GetupBed(int getupBedSleepId);
	
	// 在床上睡下
	bool SleepBed(int sleepBedSleepId, Sleeper & sleeper);

	bool IsBedEmpty(int checkBedSleepId);

	SleeperType GetSleeperType(int val);

private:
	Bed m_arrBeds[256];

};

