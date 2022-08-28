#pragma once

#include <time.h>

class WheatVote {
public:
	virtual ~WheatVote();

	void Init(int sleeperNum, int _voteKickSleeperId);

	bool AddAgree(int sleeperId);
	bool AddRefuse(int sleeperId);

	// ��ȡ����ͶƱ��ʼ��ȥ��ʱ�䣬��λ �룬�� int ����
	int GetPastTime();

	inline bool IsVoting() { return m_isVoting; };
	inline void SetIsVoting(bool bVoting) { m_isVoting = bVoting; };

	void GetVoteAnswer(int * destAgrees, int * destRefuses);

	int m_voteKickSleeperId = -1;

private:
	time_t m_time = time(NULL);

	bool m_isVoting = false;

	// -1 = ���ԣ�0 = δͶƱ��1 = ͬ�⣬���Ǹ�����
	int * m_pArrSleepersVoteAnwsers = nullptr;
	int m_sleepersVoteNumMax = 0; // ���� m_pArrSleepersVoteAnwsers �ĳ���

};

