if(mySleeperId < 0) {
	alarm_set(0, synchPosRateTime);
	exit;
}

if(instance_exists(sleepers[mySleeperId])) {
	if(sleepers[mySleeperId].MyPathIsRunning()) {
		alarm_set(0, 2);
		exit;
	}
	
	SendPos(sleepers[mySleeperId].x, sleepers[mySleeperId].y);
}

alarm_set(0, synchPosRateTime);

