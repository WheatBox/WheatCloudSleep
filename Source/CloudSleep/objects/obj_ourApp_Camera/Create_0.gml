event_inherited();

mycamsurf = -1;

MyCheckAndRemakeMycamsurf = function() {
	if(mycamsurf == -1 || surface_exists(mycamsurf) == false) {
		mycamsurf = surface_create(OurPhoneScreenWidth, OurPhoneScreenHeight);
	}
}

myshotWhiteAlphaMax = 0.2;
myshotWhiteAlpha = 0;

myshotButtonRadiusStart = 18;
myshotButtonRadiusEnd = 24;
myshotButtonRadius = myshotButtonRadiusStart;

MyShot = function() {
	static _i_datetime = 0; // 这张照片是该 datetime 里拍摄的第几张
	static _datetimePrev = undefined;
	
	if(surface_exists(mycamsurf) == false) {
		return;
	}
	
	var _datetime = date_current_datetime();
	
	if(_datetime != _datetimePrev) {
		_datetimePrev = _datetime;
		
		_i_datetime = 0;
	} else {
		_i_datetime++;
	}
	
	var _fname = FILEPATH_ourPhonePhotos
		+ string(date_get_year(_datetime)) + "_"
		+ string(date_get_month(_datetime)) + "_"
		+ string(date_get_day(_datetime)) + "_"
		+ string(date_get_hour(_datetime)) + "_"
		+ string(date_get_minute(_datetime)) + "_"
		+ string(date_get_second(_datetime)) + "_"
		+ string(_i_datetime) + ".png"
	;
	
	try {
		if(!directory_exists(FILEPATH_ourPhonePhotos)) {
			MakeFolder(FILEPATH_ourPhonePhotos);
		}
		if(directory_exists(FILEPATH_ourPhonePhotos)) {
			
		} else {
			show_message_async("无法正确访问或创建照片文件夹：" + FILEPATH_ourPhonePhotos);
			
			return;
		}
	} catch(error) {
		DebugMes([error.script, error.message]);
		
		return;
	}
	
	surface_save(mycamsurf, _fname);
	
	myshotWhiteAlpha = myshotWhiteAlphaMax;
}
