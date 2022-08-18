var _initBedSleepId = 0;
for(var iy = 0; iy < 16; iy++) {
	for(var ix = 0; ix < 16; ix++) {
		var _offsetY = 256;
		var _offsetX = 128 + (iy % 2 == 0 ? 128 : 0);
		CreateBed(ix * 320 + _offsetX, iy * 288 + _offsetY, depth, _initBedSleepId);
		_initBedSleepId++;
	}
}

