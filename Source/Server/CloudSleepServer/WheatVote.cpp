#include "WheatVote.h"

#include <Windows.h>
#include <iostream>
WheatVote::~WheatVote()
{
	if(m_pArrSleepersVoteAnwsers != nullptr) {
		delete [] m_pArrSleepersVoteAnwsers;
	}
}

void WheatVote::Init(int sleeperNum, int _voteKickSleeperId)
{
	m_time = time(NULL);

	m_isVoting = false;

	if(m_pArrSleepersVoteAnwsers != nullptr) {
		delete [] m_pArrSleepersVoteAnwsers;
	}

	m_sleepersVoteNumMax = sleeperNum;
	m_pArrSleepersVoteAnwsers = new int[sleeperNum];
	memset(m_pArrSleepersVoteAnwsers, 0, sleeperNum);

	m_voteKickSleeperId = _voteKickSleeperId;
}

bool WheatVote::AddAgree(int sleeperId)
{
	if(IsVoting() == false) {
		return false;
	}

	if(sleeperId < 0 || sleeperId >= m_sleepersVoteNumMax) {
		printf("sleeperId = %d\n", sleeperId);
		return false;
	}
	m_pArrSleepersVoteAnwsers[sleeperId] = 1;
	return true;
}

bool WheatVote::AddRefuse(int sleeperId)
{
	if(IsVoting() == false) {
		return false;
	}

	if(sleeperId < 0 || sleeperId >= m_sleepersVoteNumMax) {
		return false;
	}
	m_pArrSleepersVoteAnwsers[sleeperId] = -1;
	return true;
}

int WheatVote::GetPastTime()
{
	time_t t = time(NULL);
	int sec = static_cast<int>(difftime(t, m_time));

	return sec;
}

void WheatVote::GetVoteAnswer(int* destAgrees, int* destRefuses)
{
	if(destAgrees != nullptr)
		*destAgrees = 0;
	if(destRefuses != nullptr)
		*destRefuses = 0;

	for(int i = 0; i < m_sleepersVoteNumMax; i++) {
		if(m_pArrSleepersVoteAnwsers[i] == 1) {
			if(destAgrees != nullptr) {
				*destAgrees += 1;
			}
		} else if(m_pArrSleepersVoteAnwsers[i] == -1) {
			if(destRefuses != nullptr)
				*destRefuses += 1;
		}
	}
}

