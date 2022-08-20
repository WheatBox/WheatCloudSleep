#include "WheatBedManager.h"
#include "ProjectCommon.h"

void WheatBedManager::GetupBed(int getupBedSleepId)
{
	m_arrBeds[getupBedSleepId].empty = true;
	m_arrBeds[getupBedSleepId].pSleeper->clear();
}

bool WheatBedManager::SleepBed(int sleepBedSleepId, Sleeper & sleeper)
{
	if(IsBedEmpty(sleepBedSleepId) == false) {
		return false;
	}

	m_arrBeds[sleepBedSleepId].empty = false;
	m_arrBeds[sleepBedSleepId].pSleeper->copy(sleeper);

	return true;
}

bool WheatBedManager::IsBedEmpty(int checkBedSleepId)
{
	return m_arrBeds[checkBedSleepId].empty;
}

SleeperType WheatBedManager::GetSleeperType(int val)
{
	switch(val) {
		case 0:
			return SleeperType::Girl;
			break;
		case 1:
			return SleeperType::Boy;
			break;
	}

	return SleeperType::Boy;
}

int WheatBedManager::FindSleeperId(SOCKET sleeperSocket)
{
	for(int i = 0; i < m_sleepers.size(); i++) {
		if(m_sleepers[i].empty == true) {
			continue;
		}

		if(m_sleepers[i].sock == sleeperSocket) {
			return i;
		}
	}
	return -1;
}

void WheatBedManager::RegisterNewSleeper(Sleeper sleeper)
{
	int emptyId = FindEmptySleeperId();
	
	if(emptyId == -1) {
		m_sleepers.push_back(sleeper);
		return;
	}

	m_sleepers[emptyId].copy(sleeper);
}

void WheatBedManager::CancelSleeper(int sleeperId)
{
	m_sleepers[sleeperId].clear();
}

void WheatBedManager::CancelSleeper(SOCKET sleeperSocket)
{
	CancelSleeper(FindSleeperId(sleeperSocket));
}

int WheatBedManager::FindEmptySleeperId()
{
	for(int i = 0; i < m_sleepers.size(); i++) {
		if(m_sleepers[i].empty) {
			return i;
		}
	}
	return -1;
}

Sleeper::Sleeper()
{
	set(true, 0, "", SleeperType::Boy);
}

Sleeper::Sleeper(SOCKET _sock)
{
	set(true, _sock, "", SleeperType::Boy);
}

Sleeper::Sleeper(bool _empty, SOCKET _sock, const char* _name, SleeperType _type)
{
	set(_empty, _sock, _name, _type);
}

SleeperType Sleeper::TransformIntToSleeperType(int _intval)
{
	switch(_intval) {
		case 0:
			return SleeperType::Girl;
		case 1:
			return SleeperType::Boy;
	}
	return SleeperType::Girl;
}

