var _initBedSleepId = 0;
for(var iy = 0; iy < 16; iy++) {
	for(var ix = 0; ix < 16; ix++) {
		var _offsetY = 320 + 256;
		var _offsetX = 768 + 128 + (iy % 2 == 0 ? 128 : 0);
		CreateBed(ix * 320 + _offsetX, iy * 288 + _offsetY, _initBedSleepId);
		_initBedSleepId++;
	}
}

mp_grid_add_instances(grid, obj_bed, false);

sleepers = [];

SendName();
SendType();

MyGetSleeperIdMax = function() {
	return array_length(sleepers) - 1;
}

MyCanUseSleeperId = function(sleeperId) {
	var sleeperIdMax = MyGetSleeperIdMax();
	if(sleeperIdMax < sleeperId || !instance_exists(sleepers[sleeperId])) {
		return false;
	}
	return true;
}

synchPosRateTime = 5 * 60; // 五秒向服务器发送一次自己的坐标，让其它客户端进行同步
alarm_set(0, synchPosRateTime);

