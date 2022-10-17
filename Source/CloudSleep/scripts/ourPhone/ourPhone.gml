#macro OurPhoneDepth -11000
#macro OurAppDepth -11100

#macro OurPhoneScreenWidth 243
#macro OurPhoneScreenHeight 432
#macro OurAppIconBboxWidth 50 // OurApp 的碰撞体积
#macro OurAppIconBboxHeight 50

#macro FILEPATH_ourPhoneWallpapers (SavePath + "ourPhoneWallpapers\\")

globalvar FILEPATH_ourPhoneMusics;
FILEPATH_ourPhoneMusics = "";
#macro MciOpenAudio_Aliasname_OurPhoneMusic "music"


#macro OurAppStepEventHead {\
	event_inherited();\
	if(working == false) {\
		exit;\
	}\
	surface_set_target(surf);\
}

#macro OurAppStepEventTail {\
	surface_reset_target();\
	pressed = false;\
}


globalvar gMouseOnOurPhoneX, gMouseOnOurPhoneY;
gMouseOnOurPhoneX = 0;
gMouseOnOurPhoneY = 0;

globalvar gOurPhoneWallpaperSprite;
gOurPhoneWallpaperSprite = spr_ourPhoneWallpaper;

function OurPhone_WriteWallpaper(wallpaperFilenameWithoutPath) {
	try {
		ini_open(FILEINI_Settings);
		
		ini_write_string("ourPhone", "wallpaperFilename", wallpaperFilenameWithoutPath);
		
		ini_close();
	} catch(error) {
		DebugMes([error.script, error.message]);
	}
}

function OurPhone_LoadWallpaper() {
	try {
		ini_open(FILEINI_Settings);
		
		var fname = FILEPATH_ourPhoneWallpapers + ini_read_string("ourPhone", "wallpaperFilename", "");
		if(fname != "") {
			var sprTemp = sprite_add(fname, 1, false, true, 0, 0);
			if(sprite_exists(sprTemp)) {
				if(sprite_exists(gOurPhoneWallpaperSprite) && gOurPhoneWallpaperSprite != spr_ourPhoneWallpaper) {
					sprite_delete(gOurPhoneWallpaperSprite);
				}
				gOurPhoneWallpaperSprite = sprTemp;
			}
		}
		
		ini_close();
	} catch(error) {
		DebugMes([error.script, error.message]);
	}
}

function OurPhone_LoadWallpaperDefault() {
	try {
		if(sprite_exists(gOurPhoneWallpaperSprite) && gOurPhoneWallpaperSprite != spr_ourPhoneWallpaper) {
			sprite_delete(gOurPhoneWallpaperSprite);
		}
		gOurPhoneWallpaperSprite = spr_ourPhoneWallpaper;
	} catch(error) {
		DebugMes([error.script, error.message]);
	}
}


function OurPhone_CreateOurApp(_ourAppObj, _iconSpr) {
	return {
		// 该ins的(x, y)坐标会由创建该ourApp的obj_ourPhone来控制
		ins : instance_create_depth(0, 0, OurAppDepth, _ourAppObj),
		iconSpr : _iconSpr
	};
}


function OurPhone_WriteMusicDirectory(_newDir) {
	if(_newDir == "") {
		return false;
	}
	
	try {
		ini_open(FILEINI_Settings);
		
		if(!directory_exists(_newDir)) {
			MakeFolder(_newDir);
		}
		if(directory_exists(_newDir)) {
			ini_write_string("ourPhone", "musicDir", _newDir);
			
			ini_close();
			
			return true;
		}
		
		ini_close();
	} catch(error) {
		DebugMes([error.script, error.message]);
		
		return false;
	}
	
	return false;
}

function OurPhone_ReadMusicDirectory() {
	try {
		ini_open(FILEINI_Settings);
		
		var _newDir = ini_read_string("ourPhone", "musicDir", "D:\\Music\\");
		if(!directory_exists(_newDir)) {
			MakeFolder(_newDir);
		}
		if(directory_exists(_newDir)) {
			if(string_char_at(_newDir, string_length(_newDir)) != "\\") {
				 _newDir += "\\";
			}
			FILEPATH_ourPhoneMusics = _newDir;
		}
		
		ini_close();
	} catch(error) {
		DebugMes([error.script, error.message]);
	}
}


function OurPhone_WriteMusicLoopMode(_musicLoopMode) {
	try {
		ini_open(FILEINI_Settings);
		
		ini_write_real("ourPhone", "musicLoopMode", _musicLoopMode);
		
		ini_close();
	} catch(error) {
		DebugMes([error.script, error.message]);
	}
}

function OurPhone_ReadMusicLoopMode() {
	var _newDir = 0;
	
	try {
		ini_open(FILEINI_Settings);
		
		_newDir = ini_read_real("ourPhone", "musicLoopMode", 0);
		
		ini_close();
	} catch(error) {
		DebugMes([error.script, error.message]);
	}
	
	return _newDir;
}

