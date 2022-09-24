OurAppStepEventHead

if(pressed) {
	if(directory_exists(FILEPATH_ourPhoneWallpapers) == false) {
		systemCmd("md " + FILEPATH_ourPhoneWallpapers);
	}
}



draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(0, 0, screenWidth, screenHeight, false);

draw_set_color(c_white);
draw_set_alpha(1.0);

var _mouseLeftPressed = MouseLeftPressed();

var textScale = 0.8;
var yTempAdd = 28;
var yTemp = 8;
var arrWallpaperFilenameSiz = array_length(arrWallpaperFilename);
for(var i = 0; i < arrWallpaperFilenameSiz; i++) {
	switch(arrWallpaperFilename[i]) {
		case ":opendir":
			draw_text_transformed(16, yTemp, "打开壁纸存放文件夹", textScale, textScale, 0);
			break;
		case ":refresh":
			draw_text_transformed(16, yTemp, "刷新列表", textScale, textScale, 0);
			break;
		case ":defaultSpr":
			draw_text_transformed(16, yTemp, "默认壁纸", textScale, textScale, 0);
			break;
		default:
			draw_text_transformed(16, yTemp, arrWallpaperFilename[i], textScale, textScale, 0);
	}
	
	var _highlightX = 0;
	var _highlightY = yTemp;
	var _highlightWidth = screenWidth;
	var _highlightHeight = yTemp + yTempAdd - 1;
	if(point_in_rectangle(gMouseOnOurPhoneX, gMouseOnOurPhoneY, _highlightX, _highlightY, _highlightWidth, _highlightHeight)) {
		draw_set_alpha(0.3);
		draw_rectangle(_highlightX, _highlightY, _highlightWidth, _highlightHeight, false);
		draw_set_alpha(1.0);
		
		GUI_SetCursorHandpoint();
		
		if(_mouseLeftPressed) {
			switch(arrWallpaperFilename[i]) {
				case ":opendir":
					systemCmd("start " + FILEPATH_ourPhoneWallpapers);
					break;
				case ":refresh":
					if(_mouseLeftPressed) {
						MyRefresh();
						arrWallpaperFilenameSiz = array_length(arrWallpaperFilename);
					}
					break;
				case ":defaultSpr":
					OurPhone_LoadWallpaperDefault();
					break;
				default:
					OurPhone_WriteWallpaper(arrWallpaperFilename[i]);
					OurPhone_LoadWallpaper();
			}
		}
	}
	
	yTemp += yTempAdd;
}

OurAppStepEventTail
