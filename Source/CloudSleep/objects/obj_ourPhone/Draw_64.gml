// 绘制壁纸
draw_set_color(c_white);
draw_set_alpha(1.0);
if(sprite_exists(gOurPhoneWallpaperSprite)) {
	var scales = SetSize_Generic(screenWidth, screenHeight, sprite_get_width(gOurPhoneWallpaperSprite), sprite_get_height(gOurPhoneWallpaperSprite));
	GUI_DrawSprite_ext(gOurPhoneWallpaperSprite, 0, x, y, scales[0], scales[1], 0, c_white, 1.0);
}

// 绘制各个ourApp图标
if(myOurAppSurf == -1) {
	myOurAppIconAlpha = lerp(myOurAppIconAlpha, 1.0, myOurAppTransLerpAmount);
} else {
	myOurAppIconAlpha = lerp(myOurAppIconAlpha, 0.0, myOurAppTransLerpAmount);
}
if(myOurAppIconAlpha > 0.05) {
	var arrOurAppsSiz = array_length(arrOurApps);
	var j = 0, ij = 0;
	for(var i = 0; ij < arrOurAppsSiz; { i++; j = 0; ij = j + (4 * i); }) {
		for(; j < 4 && ij < arrOurAppsSiz; { j++; ij = j + (4 * i); }) {
			if(InstanceExists(arrOurApps[ij].ins) && sprite_exists(arrOurApps[ij].iconSpr)) {
				
				// 关于ourApp里的x和y的作用详见 obj_ourAppParent
				arrOurApps[ij].ins.x = myOurAppSurfX + x;
				arrOurApps[ij].ins.y = myOurAppSurfY + y;
				
				var _xTemp = x + 1 + 30 + 60 * j;
				var _yTemp = y + screenHeight - 34 - 60 * i;
				GUI_DrawSprite_ext(arrOurApps[ij].iconSpr, 0, _xTemp, _yTemp, 1.0, 1.0, 0, c_white, myOurAppIconAlpha);
				
				if(myOurAppSurf == -1) { // 目前没有 ourApp 在运行
					if(GUI_MouseGuiOnMe(_xTemp - OurAppIconBboxWidth / 2, _yTemp - OurAppIconBboxHeight / 2
						, _xTemp + OurAppIconBboxWidth / 2, _yTemp + OurAppIconBboxHeight / 2)) {
						GUI_SetCursorHandpoint();
						
						if(MouseLeftPressed()) {
							myOurAppSurfX = _xTemp - x;
							myOurAppSurfY = _yTemp - y;
							myOurAppWorkingIconX = myOurAppSurfX;
							myOurAppWorkingIconY = myOurAppSurfY;
							
							MyPressApp(ij);
						}
					}
				}
			}
		}
	}
}

// 绘制时间文字
draw_set_color(c_black);
draw_set_alpha(1.0);
GUI_DrawTextTransformed(x + screenWidth / 2, y + 24, GetCurrentTimeString(false), 1.2, 1.2, 0, true);

// 绘制ourApp的画面
if(myOurAppSurf != -1) {
	if(surface_exists(myOurAppSurf)) {
		if(!surface_exists(myOurAppSurfStatic)) {
			myOurAppSurfStatic = surface_create(screenWidth, screenHeight);
		}
		surface_copy(myOurAppSurfStatic, 0, 0, myOurAppSurf);
		
		myOurAppSurfAlpha = lerp(myOurAppSurfAlpha, 2.0, myOurAppTransLerpAmount);
		myOurAppSurfX = lerp(myOurAppSurfX, 0, myOurAppTransLerpAmount);
		myOurAppSurfY = lerp(myOurAppSurfY, 0, myOurAppTransLerpAmount);
		myOurAppSurfXscale = lerp(myOurAppSurfXscale, 1.0, myOurAppTransLerpAmount);
		myOurAppSurfYscale = lerp(myOurAppSurfYscale, 1.0, myOurAppTransLerpAmount);
		// GUI_DrawSurface_ext(myOurAppSurf, myOurAppSurfX, myOurAppSurfY, myOurAppSurfXscale, myOurAppSurfYscale, 0, c_white, 1.0);
	} else {
		myOurAppSurf = -1;
	}
}
if(myOurAppSurf == -1) {
	myOurAppSurfAlpha = lerp(myOurAppSurfAlpha, 0.0, myOurAppTransLerpAmount);
	myOurAppSurfX = lerp(myOurAppSurfX, myOurAppWorkingIconX - 24, myOurAppTransLerpAmount);
	myOurAppSurfY = lerp(myOurAppSurfY, myOurAppWorkingIconY, myOurAppTransLerpAmount);
	myOurAppSurfXscale = lerp(myOurAppSurfXscale, 0.2, myOurAppTransLerpAmount);
	myOurAppSurfYscale = lerp(myOurAppSurfYscale, 0.05, myOurAppTransLerpAmount);
}
if(surface_exists(myOurAppSurfStatic) && myOurAppSurfAlpha > 0.05) {
	GUI_DrawSurface_ext(myOurAppSurfStatic, x + myOurAppSurfX, y + myOurAppSurfY, myOurAppSurfXscale, myOurAppSurfYscale, 0, c_white, myOurAppSurfAlpha);
}
gMouseOnOurPhoneX = (GetPositionXOnGUI(mouse_x) - myOurAppSurfX - x) / myOurAppSurfXscale;
gMouseOnOurPhoneY = (GetPositionYOnGUI(mouse_y) - myOurAppSurfY - y) / myOurAppSurfYscale;

// 绘制ourPhone外观
draw_set_color(c_white);
draw_set_alpha(1.0);
GUI_DrawSprite(spr_ourPhone, 0, x, y);

// 绘制ourPhone的Home按钮
GUI_DrawSprite(spr_ourPhone_ButtonHome, 0, buttonHomeX, buttonHomeY);
if(buttonHomeMouseOnMe) {
	draw_set_color(c_black);
	draw_set_alpha(GUIHighLightAlpha);
	GUI_DrawRectangle(buttonHomeX - buttonHomeWidth / 2, buttonHomeY - buttonHomeHeight / 2
		, buttonHomeX + buttonHomeWidth / 2, buttonHomeY + buttonHomeHeight / 2);
	
	if(MouseLeftPressed()) {
		MyPressApp();
	}
}

