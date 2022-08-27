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

	bool firstMoved = false; // �������״��ƶ�

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

// ��λ�������α���˾�Ĵ�λ������������˯���ǵĴ�λ���
class WheatBedManager {
public:

	// �Ӵ�������
	void GetupBed(int getupBedSleepId);
	
	// �ڴ���˯��
	bool SleepBed(int sleepBedSleepId);

	bool IsBedEmpty(int checkBedSleepId);

	// ͨ�� SleeperType ��ֵ ����ȡ SleeperType::xxxx
	// ���� GetSleeperType(0) �᷵�� SleeperType::Girl
	SleeperType GetSleeperType(int val);

	// ͨ�� socket ������ ˯��id����������ڸ�˯�ͣ����� -1
	int FindSleeperId(SOCKET sock);

	// �Ǽ��µ�˯��
	// ����п��е� ˯��id�����滻���� ˯��id �� ˯�ͣ����û�п��е� ˯��id��push_back() һ���µ� ˯��id
	// ����Ϊ��˯��ע��� ˯��id
	int RegisterNewSleeper(Sleeper sleeper);

	// ע��˯�ͣ���˯���뿪
	void CancelSleeper(int sleeperId);
	void CancelSleeper(SOCKET sleeperSocket);

	// �����׸����е� ˯��id�����û�п��� ˯��id������ -1
	int FindEmptySleeperId();

	inline Bed * GetBed(int _bedSleepId) { return & m_arrBeds[_bedSleepId]; }

	inline Sleeper * GetSleeper(int _sleeperId) { return & m_sleepers[_sleeperId]; }

	std::vector<Sleeper> m_sleepers;

private:
	Bed m_arrBeds[BED_NUM];

};

