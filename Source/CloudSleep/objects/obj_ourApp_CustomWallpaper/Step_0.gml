OurAppStepEventHead

if(pressed) {
	if(directory_exists(FILEPATH_ourPhoneWallpapers) == false) {
		MakeFolder(FILEPATH_ourPhoneWallpapers);
	}
}


if(point_in_rectangle(gMouseOnOurPhoneX, gMouseOnOurPhoneY, 0, 0, screenWidth, screenHeight)) {
	mouseOnMe = true;
	
	scrollY = ScrollYCalculate(scrollY, scrollYSpeed, 0, 0 + screenHeight, 8 + array_length(arrWallpaperFilename) * wallpaperFilenameLineHeight);
} else {
	mouseOnMe = false;
}


SurfaceClear();


draw_set_color(c_black);
draw_set_alpha(0.8);
draw_rectangle(0, 0, screenWidth, screenHeight, false);

draw_set_color(c_white);
draw_set_alpha(1.0);

var _mouseLeftPressed = MouseLeftPressed();

var textScale = 0.8;
var xTemp = 10;
var yTempAdd = wallpaperFilenameLineHeight;
var yTemp = 8 + scrollY;
var arrWallpaperFilenameSiz = array_length(arrWallpaperFilename);
for(var i = 0; i < arrWallpaperFilenameSiz; { i++; yTemp += yTempAdd; }) {
	if(yTemp + yTempAdd < 0 || yTemp > screenHeight) {
		continue;
	}
	
	switch(arrWallpaperFilename[i]) {
		case ":opendir":
			draw_text_transformed(xTemp, yTemp, "打开壁纸存放文件夹", textScale, textScale, 0);
			break;
		case ":refresh":
			draw_text_transformed(xTemp, yTemp, "刷新列表", textScale, textScale, 0);
			break;
		case ":defaultSpr":
			draw_text_transformed(xTemp, yTemp, "默认壁纸", textScale, textScale, 0);
			break;
		default:
			draw_text_transformed(xTemp, yTemp, arrWallpaperFilename[i], textScale, textScale, 0);
	}
	
	var _highlightX = 0;
	var _highlightY = yTemp;
	var _highlightWidth = screenWidth;
	var _highlightHeight = yTemp + yTempAdd - 1;
	
	if(mouseOnMe)
	if(point_in_rectangle(gMouseOnOurPhoneX, gMouseOnOurPhoneY, _highlightX, _highlightY, _highlightWidth, _highlightHeight)) {
		draw_set_alpha(0.3);
		draw_rectangle(_highlightX, _highlightY, _highlightWidth, _highlightHeight, false);
		draw_set_alpha(1.0);
		
		GUI_SetCursorHandpoint();
		
		if(_mouseLeftPressed) {
			switch(arrWallpaperFilename[i]) {
				case ":opendir":
					if(!directory_exists(FILEPATH_ourPhoneWallpapers)) {
						MakeFolder(FILEPATH_ourPhoneWallpapers);
					}
					if(directory_exists(FILEPATH_ourPhoneWallpapers)) {
						OpenInExplorer(FILEPATH_ourPhoneWallpapers);
					} else {
						show_message_async("路径不存在且无法被建立：\n" + FILEPATH_ourPhoneWallpapers);
					}
					break;
				case ":refresh":
					MyRefresh();
					arrWallpaperFilenameSiz = array_length(arrWallpaperFilename);
					break;
				case ":defaultSpr":
					OurPhone_LoadWallpaperDefault();
					
					OurPhone_WriteWallpaper("");
					break;
				default:
					OurPhone_WriteWallpaper(arrWallpaperFilename[i]);
					OurPhone_LoadWallpaper();
			}
		}
	}
}

OurAppStepEventTail
