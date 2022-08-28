#pragma once

#include <time.h>

class WheatVote {
public:
	virtual ~WheatVote();

	void Init(int sleeperNum, int _voteKickSleeperId);

	bool AddAgree(int sleeperId);
	bool AddRefuse(int sleeperId);

	// 获取距离投票开始过去的时间，单位 秒，以 int 返回
	int GetPastTime();

	inline bool IsVoting() { return m_isVoting; };
	inline void SetIsVoting(bool bVoting) { m_isVoting = bVoting; };

	void GetVoteAnswer(int * destAgrees, int * destRefuses);

	int m_voteKickSleeperId = -1;

private:
	time_t m_time = time(NULL);

	bool m_isVoting = false;

	// -1 = 反对，0 = 未投票，1 = 同意，这是个数组
	int * m_pArrSleepersVoteAnwsers = nullptr;
	int m_sleepersVoteNumMax = 0; // 数组 m_pArrSleepersVoteAnwsers 的长度

};

