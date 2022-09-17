if(inited == false) {
	inited = true;
	
	if(isMe) {
		var _initPosIndexTemp = irandom_range(0, array_length(gArrSleepersInitPosx[myType]) - 1);
		x = gArrSleepersInitPosx[myType][_initPosIndexTemp];
		y = gArrSleepersInitPosy[myType][_initPosIndexTemp];
		
		DebugMes(gArrSleepersInitPosx);
		DebugMes(myType);
		DebugMes(_initPosIndexTemp);
		
		CameraSetPos(x, y);
		
		SendPos(x, y);
	}
}

if(myPathDestX != undefined && myPathDestY != undefined) {
	if(floor(x) == floor(myPathDestX) && floor(y) == floor(myPathDestY)) {
		MyPathStop();
		
		if(willSleep) {
			willSleep = false;
			
			var _bedIns = collision_circle(x, y, 32, obj_bed, false, true);
			if(_bedIns != noone) {
				SendSleep(_bedIns.bedSleepId);
			}
		}
	}
}
