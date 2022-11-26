blockAreaDir = 360 / blocksInOnePage;

var _outOfRange = radius + 160 < point_distance(x, y, GetPositionXOnGUI(mouse_x), GetPositionYOnGUI(mouse_y));

if(
	keyboard_check_direct(0xC0) // "`“ 和 ”~" 键
	&& window_has_focus()
) {
	if(instance_exists(obj_client))
	if(InstanceExists(obj_client.myTextBox)) {
		if(obj_client.myTextBox.curt.fo == false) {
			working = true;
		}
	} else {
		working = true;
	}
} else {
	if(working) {
		if(_outOfRange) {
			// 啥也不做
		} else {
			// 发送表情消息
			SendEmote(MyEmoteIdStandard(pointBlockIndex));
		}
	}
	working = false;
}

if(working) {
	draw_set_color(c_black);
	draw_set_alpha(0.5);
	
	GUI_DrawRectangle(0, 0, GuiWidth(), GuiHeight(), false);
	
	draw_set_color(c_white);
	draw_set_alpha(1);
	
	pointDirection += 0.2 * angle_difference(point_direction(x, y, GetPositionXOnGUI(mouse_x), GetPositionYOnGUI(mouse_y)), pointDirection);
	
	pointBlockIndex = round(pointDirection / blockAreaDir);
	
	draw_arrow(x, y, x + lengthdir_x(radius / 2, pointDirection), y + lengthdir_y(radius / 2, pointDirection), 32);
	
	var _iMin = -floor(blocksInOnePage / 2);
	var _iMax = floor(blocksInOnePage / 2) - 1;
	for(var i = _iMin; i <= _iMax; i++) {
		var _emoteIndex = MyEmoteIdStandard(pointBlockIndex + i);
		
		var _dirTemp = (pointBlockIndex + i) * blockAreaDir;
		// var _scaleTemp = ((i - _iMin) / (_iMax + 1) - 1) * 0.4 + 1;
		var _scaleTemp = (_dirTemp - pointDirection) / 360 + 1;
		// var _alphaTemp = ((blocksInOnePage / 2 - abs(i)) / (blocksInOnePage / 2) - 1) * 0.9 + 1;
		var _alphaTemp = (1 - abs(_dirTemp - pointDirection) / (360 / 2) - 1) * 1.1 + 1;
		GUI_DrawSprite_ext(arrEmoteSprites[_emoteIndex], 0
			, x + spriteOffsetX - spriteWidth / 2 + lengthdir_x(radius, _dirTemp)
			, y + spriteOffsetY - spriteHeight / 2 + lengthdir_y(radius, _dirTemp)
			, _scaleTemp, _scaleTemp
			, 0, (i != 0 || _outOfRange) ? #AAAAAA : #FFFFFF
			, _alphaTemp
		);
	}
}


if(InstanceExists(mySlidingRodIns)) {
	if(working) {
		mySlidingRodIns.x = x - mySlidingRodIns.width / 2;
		mySlidingRodIns.y = GuiHeight() - mySlidingRodIns.height;
	} else {
		mySlidingRodIns.x = -1000;
	}
}
