if(working == false) {
	if(musicIsPlaying) {
		musicPosition = MciGetAudioPosition(MciOpenAudio_Aliasname_OurPhoneMusic);
	}
	
	MyMusicFinishCheck();
}
OurAppStepEventHead


if(point_in_rectangle(gMouseOnOurPhoneX, gMouseOnOurPhoneY, 0, 0, screenWidth, screenHeight)) {
	mouseOnMe = true;
	
	scrollY = ScrollYCalculate(scrollY, scrollYSpeed, 0, 0 + screenHeight - bottomHeight, 8 + array_length(arrMusicFilename) * musicFilenameLineHeight);
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
var yTempAdd = musicFilenameLineHeight;
var yTemp = 8 + scrollY;
var arrMusicFilenameSiz = array_length(arrMusicFilename);
for(var i = 0; i < arrMusicFilenameSiz; { i++; yTemp += yTempAdd; }) {
	if(yTemp + yTempAdd < 0 || yTemp > screenHeight) {
		continue;
	}
	
	switch(arrMusicFilename[i]) {
		case ":setdir":
			draw_text_transformed(xTemp, yTemp, "修改音乐存放文件夹", textScale, textScale, 0);
			break;
		case ":opendir":
			draw_text_transformed(xTemp, yTemp, "打开音乐存放文件夹", textScale, textScale, 0);
			break;
		case ":refresh":
			draw_text_transformed(xTemp, yTemp, "刷新列表", textScale, textScale, 0);
			break;
		default:
			if(i != musicPlayingIndex) {
				draw_text_transformed(xTemp, yTemp, arrMusicFilename[i], textScale, textScale, 0);
			} else {
				draw_text_transformed_color(xTemp, yTemp, arrMusicFilename[i], textScale, textScale, 0, #00D600, #00D600, #00D600, #00D600, 1.0);
				draw_rectangle_color(0, yTemp, 4, yTemp + yTempAdd - 1, #00D600, #00D600, #00D600, #00D600, false);
			}
	}
	
	var _highlightX = 0;
	var _highlightY = yTemp;
	var _highlightWidth = screenWidth;
	var _highlightHeight = yTemp + yTempAdd - 1;
	
	if(mouseOnMe)
	if(gMouseOnOurPhoneY < screenHeight - bottomHeight)
	if(point_in_rectangle(gMouseOnOurPhoneX, gMouseOnOurPhoneY, _highlightX, _highlightY, _highlightWidth, _highlightHeight)) {
		draw_set_alpha(0.3);
		draw_rectangle(_highlightX, _highlightY, _highlightWidth, _highlightHeight, false);
		draw_set_alpha(1.0);
		
		GUI_SetCursorHandpoint();
		
		if(_mouseLeftPressed) {
			switch(arrMusicFilename[i]) {
				case ":setdir":
					if(asyncDialogId_setdir == -1) {
						asyncDialogId_setdir = get_string_async("请输入文件夹完整路径", FILEPATH_ourPhoneMusics);
					}
					break;
				case ":opendir":
					if(!directory_exists(FILEPATH_ourPhoneMusics)) {
						systemCmd("md " + FILEPATH_ourPhoneMusics);
					}
					if(directory_exists(FILEPATH_ourPhoneMusics)) {
						systemCmd("start " + FILEPATH_ourPhoneMusics);
					} else {
						show_message_async("路径不存在且无法被建立：\n" + FILEPATH_ourPhoneMusics);
					}
					break;
				case ":refresh":
					MyRefresh();
					arrMusicFilenameSiz = array_length(arrMusicFilename);
					break;
				default:
					MyMusicPlay(i);
			}
		}
	}
}

if(musicIsPlaying) {
	musicPosition = MciGetAudioPosition(MciOpenAudio_Aliasname_OurPhoneMusic);
}


gpu_set_blendmode(bm_subtract);
draw_set_alpha(1.0);
draw_set_color(c_white);
draw_rectangle(0, screenHeight - bottomHeight, 0 + screenWidth, screenHeight, false);
gpu_set_blendmode(bm_normal);

draw_set_alpha(0.6);
draw_set_color(c_black);
draw_rectangle(0, screenHeight - bottomHeight, 0 + screenWidth, screenHeight, false);

var bottomYOff = screenHeight - bottomHeight;
{ // 播放/暂停按钮
	var playButtonX = 22;
	var playButtonY = bottomYOff + bottomHeight / 2 - 4;
	var playButtonRad = bottomHeight / 2 - 6;
	
	draw_set_alpha(0.7);
	draw_circle(playButtonX, playButtonY, playButtonRad, false);
	
	draw_set_color(c_white);
	if(musicIsPlaying) {
		draw_rectangle(playButtonX - 5 - 2, playButtonY - 8, playButtonX - 5 + 2, playButtonY + 8, false);
		draw_rectangle(playButtonX + 5 - 2, playButtonY - 8, playButtonX + 5 + 2, playButtonY + 8, false);
	} else {
		draw_triangle(playButtonX - 6, playButtonY - 10, playButtonX - 6, playButtonY + 10, playButtonX + 10, playButtonY, false);
	}
	
	if(point_in_circle(gMouseOnOurPhoneX, gMouseOnOurPhoneY, playButtonX, playButtonY, playButtonRad)) {
		GUI_SetCursorHandpoint();
		
		draw_set_alpha(0.3);
		draw_set_color(c_white);
		draw_circle(playButtonX, playButtonY, playButtonRad, false);
		
		if(MouseLeftPressed()) {
			musicIsPlaying = !musicIsPlaying;
			
			if(musicIsClose) {
				MyMusicPlay(musicPlayingIndex);
			} else if(musicIsPlaying) {
				MciResumeAudio(MciOpenAudio_Aliasname_OurPhoneMusic);
			} else {
				MciPauseAudio(MciOpenAudio_Aliasname_OurPhoneMusic);
			}
		}
	}
}

{ // 进度条
	var _barX = playButtonX + playButtonRad + 6;
	var _barY = bottomYOff + 24;
	var _barW = 160;
	var _barWWhite = _barW * (musicPosition / musicLength) - 1;
	
	if(point_in_rectangle(gMouseOnOurPhoneX, gMouseOnOurPhoneY
		, _barX, _barY, _barX + _barW, _barY + musicProgressBarHeightFocus)
		&& musicIsPlaying
	) {
		musicProgressBarHeight = lerp(musicProgressBarHeight, musicProgressBarHeightFocus, 0.2);
		
		if(MouseLeftPressed()) {
			musicPositionSetting = true;
		}
		if(MouseLeftHold() && musicPositionSetting) {
			musicPositionSetting = musicLength * ((gMouseOnOurPhoneX - _barX) / _barW);
			_barWWhite = _barW * ((gMouseOnOurPhoneX - _barX) / _barW);
		}
		if(MouseLeftReleased() && musicPositionSetting) {
			MyMusicSeek(musicPositionSetting);
			MciPlayAudio(MciOpenAudio_Aliasname_OurPhoneMusic);
			_barWWhite = _barW * ((gMouseOnOurPhoneX - _barX) / _barW);
		}
	} else {
		musicProgressBarHeight = lerp(musicProgressBarHeight, musicProgressBarHeightNature, 0.2);
	}
	
	if(MouseLeftHold() == false) {
		musicPositionSetting = false;
	}
	
	var _barH = musicProgressBarHeight;
	
	draw_set_color(c_black);
	draw_set_alpha(0.7);
	draw_rectangle(_barX, _barY, _barX + _barW - 1, _barY + _barH, false);
	
	draw_set_color(c_white);
	draw_set_alpha(1.0);
	if(musicPosition > 0) draw_rectangle(_barX, _barY, _barX + _barWWhite, _barY + _barH, false);
}


draw_set_color(c_white);
draw_set_alpha(1.0);
draw_text_transformed(playButtonX + playButtonRad + 6, bottomYOff + 2, musicPlayingName, 0.7, 0.7, 0);


MyMusicFinishCheck();


{ // 循环模式图标
	var _loopModeIconX = screenWidth - 32;
	var _loopModeIconY = screenHeight - 28;
	draw_sprite_ext(musicLoopIconSprs[musicLoopMode], 0, _loopModeIconX, _loopModeIconY
		, musicLoopIconSprsXscale, musicLoopIconSprsYscale, 0, c_white, 0.7);
	
	var _loopModeIconW = sprite_get_width(musicLoopIconSprs[musicLoopMode]) * musicLoopIconSprsXscale;
	var _loopModeIconH = sprite_get_height(musicLoopIconSprs[musicLoopMode]) * musicLoopIconSprsYscale;
	
	if(point_in_rectangle(gMouseOnOurPhoneX, gMouseOnOurPhoneY, _loopModeIconX, _loopModeIconY
		, _loopModeIconX + _loopModeIconW, _loopModeIconY + _loopModeIconH
	)) {
		draw_set_color(c_white);
		draw_set_alpha(0.3);
		draw_rectangle(_loopModeIconX, _loopModeIconY, _loopModeIconX + _loopModeIconW, _loopModeIconY + _loopModeIconH, false);
		
		GUI_SetCursorHandpoint();
		
		if(MouseLeftPressed()) {
			musicLoopMode++;
			if(musicLoopMode > musicLoopModeMax) {
				musicLoopMode = 0;
			}
			
			OurPhone_WriteMusicLoopMode(musicLoopMode);
		}
	}
}


draw_set_color(c_white);
draw_set_alpha(1.0);

OurAppStepEventTail
