if(myPathDestX != undefined && myPathDestY != undefined) {
	if(floor(x) == floor(myPathDestX) && floor(y) == floor(myPathDestY)) {
		MyPathStop();
		
		if(willSleep) {
			willSleep = false;
			
			var _bedIns = collision_circle(x, y, 16, obj_bed, false, true);
			if(_bedIns != noone) {
				SendSleep(_bedIns.bedSleepId);
			}
		}
	}
}
