#pragma once

#include <winsock.h>
#include <vector>
#include <string>

#define BED_NUM 256

enum class SleeperType {
	Girl,
	Boy
};

template<typename T>
class Vec2 {
public:
	Vec2() { x = 0; y = 0; };
	Vec2(T _x, T _y) { x = _x; y = _y; };

	void operator=(const Vec2<T> & another) { x = another.x; y = another.y; };

	T x;
	T y;
};

class Sleeper {
public:
	Sleeper();
	Sleeper(SOCKET _sock);
	Sleeper(SOCKET _sock, const char * _name, SleeperType _type);
	Sleeper(bool _empty, SOCKET _sock,  const char * _name, SleeperType _type);

	bool empty = true;
	SOCKET sock;
	std::string name = "";
	SleeperType type = SleeperType::Boy;

	Vec2<int> moveLastData;
	Vec2<int> posLastData;

	std::string IPADDRESS = "";

	bool firstMoved = false; // 经历过首次移动

	int sleepingBedId = -1;

	void set(bool _empty, SOCKET _sock, const char * _name, SleeperType _type) {
		empty = _empty;
		sock = _sock;
		name = _name;
		type = _type;
	}

	void copy(Sleeper & another) {
		empty = another.empty;
		sock = another.sock;
		name = another.name;
		type = another.type;

		moveLastData = another.moveLastData;
		posLastData = another.posLastData;

		firstMoved = another.firstMoved;
	}

	void clear() {
		empty = true;
		firstMoved = false;

		IPADDRESS = "";
	}

	SleeperType TransformIntToSleeperType(int _intval);
};

class Bed {
public:
	inline bool Empty() { return empty; }
	inline Sleeper * GetSleeper() { return pSleeper; }
	
	inline void Set(bool _empty) { empty = _empty; }
	inline void Set(bool _empty, Sleeper * _pSleeper) { empty = _empty; pSleeper = _pSleeper; }

	inline void Clear() { empty = true; }

private:
	bool empty = true;
	Sleeper * pSleeper = nullptr;
};

// 床位经理，担任本公司的床位经理，负责来往睡客们的床位起居
class WheatBedManager {
public:

	// 从床上醒来
	void GetupBed(int getupBedSleepId);
	
	// 在床上睡下
	bool SleepBed(int sleepBedSleepId);

	bool IsBedEmpty(int checkBedSleepId);

	// 通过 SleeperType 的值 来获取 SleeperType::xxxx
	// 例如 GetSleeperType(0) 会返回 SleeperType::Girl
	SleeperType GetSleeperType(int val);

	// 通过 socket 来查找 睡客id，如果不存在该睡客，返回 -1
	int FindSleeperId(SOCKET sock);

	// 登记新的睡客
	// 如果有空闲的 睡客id，则替换掉该 睡客id 的 睡客，如果没有空闲的 睡客id，push_back() 一个新的 睡客id
	// 返回为该睡客注册的 睡客id
	int RegisterNewSleeper(Sleeper sleeper);

	// 注销睡客，有睡客离开
	void CancelSleeper(int sleeperId);
	void CancelSleeper(SOCKET sleeperSocket);

	// 查找首个空闲的 睡客id，如果没有空闲 睡客id，返回 -1
	int FindEmptySleeperId();

	inline Bed * GetBed(int _bedSleepId) { return & m_arrBeds[_bedSleepId]; }

	inline Sleeper * GetSleeper(int _sleeperId) { return & m_sleepers[_sleeperId]; }

	std::vector<Sleeper> m_sleepers;

private:
	Bed m_arrBeds[BED_NUM];

};

