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

