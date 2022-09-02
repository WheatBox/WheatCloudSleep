draw_set_color(#B3CCB6);
draw_set_alpha(0.5);

draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

// 聊天记录绘制
if(myTextBox != noone) {
	draw_set_color(c_black);
	draw_set_alpha(0.3);
	var strChatHistory = "";
	var chatHistoryLen = vecChatHistory.size();
	for(var i = 0; i < chatHistoryLen; i++) {
		strChatHistory += vecChatHistory.Container[i] + "\n";
	}
	draw_rectangle(0, 720 - 48 - 6, string_width(strChatHistory), 720 - 48 - 6 - string_height(strChatHistory), false);
	draw_set_color(c_white);
	draw_text(0, 720 - 48 - 6 - string_height(strChatHistory), strChatHistory);
}

if(myTextBox != noone) {
	draw_set_color(c_white);
	draw_set_alpha(0.5);
	draw_rectangle(12, 720 - 48, 12 + 950, 720 - 48 + 28, false);
}

draw_set_alpha(1.0);
draw_set_color(c_white);

