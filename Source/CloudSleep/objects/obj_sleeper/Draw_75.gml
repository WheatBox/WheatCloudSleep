draw_set_color(c_white);
draw_set_alpha(1.0);

if(chatTime > 0) {
	chatTime--;
	
	var chatPosX = GetPositionXOnGUI(x);
	var chatPosY = GetPositionYOnGUI(y - 200);
	
	DrawChat(chatPosX, chatPosY, chatText);
}



