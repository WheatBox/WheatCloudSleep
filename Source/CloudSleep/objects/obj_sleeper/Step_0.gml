if(inited == false) {
	inited = true;
	
	if(isMe) {
		var _initPosIndexTemp = irandom_range(0, array_length(gArrSleepersInitPosx[myType]) - 1);
		x = gArrSleepersInitPosx[myType][_initPosIndexTemp];
		y = gArrSleepersInitPosy[myType][_initPosIndexTemp];
		
		// DebugMes(gArrSleepersInitPosx);
		// DebugMes(myType);
		// DebugMes(_initPosIndexTemp);
		
		CameraSetPos(x, y);
		
		SendPos(x, y);
	}
}

if(myPathDestX != undefined && myPathDestY != undefined) {
	if(floor(x) == floor(myPathDestX) && floor(y) == floor(myPathDestY)) {
		MyPathStop();
		
		if(willSleep) {
			willSleep = false;
			
			var _bedInsList = ds_list_create();
			var _bedInsListLen = collision_circle_list(x, y, 32, obj_bed, false, true, _bedInsList, true);
			if(_bedInsListLen) {
				SendSleep(_bedInsList[| 0].bedSleepId);
			}
		}
	}
}

if(isMe) {
	var _overlayDecorateInsList = ds_list_create();
	
	var _listSiz = collision_point_list(x, y, obj_decorate, true, false, _overlayDecorateInsList, false);
	// DebugMes(place_meeting(x, y, obj_decorate));
	for(var i = 0; i < _listSiz; i++) {
		if(InstanceExists(_overlayDecorateInsList[| i])) {
			_overlayDecorateInsList[| i].MyOverlapSleeper();
		}
	}
	
	ds_list_destroy(_overlayDecorateInsList);
}
