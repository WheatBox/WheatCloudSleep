#include "WheatBedManager.h"
#include "ProjectCommon.h"

void WheatBedManager::GetupBed(int getupBedSleepId)
{
	m_arrBeds[getupBedSleepId].Clear();
}

bool WheatBedManager::SleepBed(int sleepBedSleepId)
{
	if(IsBedEmpty(sleepBedSleepId) == false) {
		return false;
	}

	m_arrBeds[sleepBedSleepId].Set(false, GetSleeper(FindSleeperId(sleepBedSleepId)));

	return true;
}

bool WheatBedManager::IsBedEmpty(int checkBedSleepId)
{
	return m_arrBeds[checkBedSleepId].Empty();
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

int WheatBedManager::RegisterNewSleeper(Sleeper sleeper)
{
	sleeper.empty = false;
	int emptyId = FindEmptySleeperId();
	
	if(emptyId == -1) {
		m_sleepers.push_back(sleeper);
		return static_cast<int>(m_sleepers.size()) - 1;
	}

	m_sleepers[emptyId].copy(sleeper);

	return emptyId;
}

void WheatBedManager::CancelSleeper(int sleeperId)
{
	if(sleeperId > -1 && sleeperId < m_sleepers.size()) {
		if(m_sleepers[sleeperId].sleepingBedId != -1) {
			GetupBed(m_sleepers[sleeperId].sleepingBedId);
		}

		m_sleepers[sleeperId].clear();
	}
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
	set(false, _sock, "", SleeperType::Boy);
}

Sleeper::Sleeper(SOCKET _sock, const char* _name, SleeperType _type)
{
	set(false, _sock, _name, _type);
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

