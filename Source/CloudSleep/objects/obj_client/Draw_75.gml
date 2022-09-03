// 聊天记录绘制
if(myTextBox != noone) {
	draw_set_color(c_black);
	draw_set_alpha(0.5);
	
	if(chatHistoryOn == true) {
		var strChatHistory = "按下 Tab 键关闭聊天记录面板\n";
		var chatHistoryLen = vecChatHistory.size();
		for(var i = 0; i < chatHistoryLen; i++) {
			if(gShowSleeperId) {
				strChatHistory += string(vecChatHistorySleeperId.Container[i]);
			}
			strChatHistory += vecChatHistory.Container[i] + "\n";
		}
	} else {
		var strChatHistory = "按下 Tab 键开启聊天记录面板";
	}
	
	draw_rectangle(0, 720 - 48 - 6, string_width(strChatHistory), 720 - 48 - 6 - string_height(strChatHistory), false);
	draw_set_color(c_white);
	draw_set_alpha(1.0);
	draw_text(0, 720 - 48 - 6 - string_height(strChatHistory), strChatHistory);
	
	if(keyboard_check_pressed(vk_tab)) {
		chatHistoryOn = !chatHistoryOn;
	}
}