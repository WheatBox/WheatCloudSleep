draw_set_color(c_white);
draw_set_alpha(1.0);

if(chatTime > 0) {
	chatTime--;
	
	var chatPosX = GetPositionXOnGUI(x);
	var chatPosY = 0;
	
	if(gSleepersLabelScale <= 0 || gSleepersLabelAlpha <= 0) {
		chatPosY = GetPositionYOnGUI(bbox_top - 42);
	} else {
		chatPosY = GetPositionYOnGUI(bbox_top - 72);
	}
	
	DrawChat(chatPosX, chatPosY, chatText);
}



