/*if(IsNight()) {
	draw_set_color(#000000);
	draw_set_alpha(0.7);
	
	draw_rectangle(0, 0, GuiWidth(), GuiHeight(), false);
}*/

if(surface_exists(surfChatHistory) == false) {
	MyChatHistorySurfRefresh();
}

// 聊天记录绘制
if(myTextBox != noone) {
	draw_set_color(c_black);
	draw_set_alpha(0.5);
	
	var strChatHistory = "";
	if(chatHistoryOn == true) {
		strChatHistory = "按下 Tab 键关闭聊天记录面板";
	} else {
		strChatHistory = "按下 Tab 键开启聊天记录面板";
	}
	strChatHistory += "(最远记录距离=" + string(ChatHistoryRecordMaxDistance) + "px)";
	
	var _offy = GuiHeight() - 48 - 6;
	
	chatHistoryMaximumWidth = max(string_width(strChatHistory), chatHistoryMaximumWidth);
	
	var _strSingleLineHeight = chatHistoryStringSingleLineHeight;
	var _strHeight = min(vecChatHistory.size(), chatHistoryShowSizeMax) * _strSingleLineHeight;
	
	if(chatHistoryOn == true) {
		draw_rectangle(0, _offy, chatHistoryMaximumWidth, _offy - _strHeight - _strSingleLineHeight, false);
		
		draw_set_color(c_white);
		draw_set_alpha(1.0);
		
		var surfPartLeft = 0;
		var surfPartTop = vecChatHistory.size() * _strSingleLineHeight - _strHeight;
		var surfPartRight = chatHistoryMaximumWidth;
		var surfPartBottom = vecChatHistory.size() * _strSingleLineHeight;
		var surfX = 0;
		var surfY = _offy - _strHeight;
		
		draw_surface_part(surfChatHistory, surfPartLeft, surfPartTop - chatHistoryScrollY, surface_get_width(surfChatHistory) /* surfPartRight - surfPartLeft */, surfPartBottom - surfPartTop, surfX, surfY);
		draw_text(0, _offy - string_height(strChatHistory) - _strHeight, strChatHistory);
		
		if(GUI_MouseGuiOnMe(surfX + surfPartLeft, surfY, surfX + surfPartRight, surfY + _strHeight)) {
			gMouseOnGUI = true;
			
			chatHistoryScrollY = ScrollYCalculate(chatHistoryScrollY, chatHistoryScrollYSpeed, surfPartTop, surfPartBottom, surfPartBottom)
		}
		
	} else {
		draw_rectangle(0, _offy, chatHistoryMaximumWidth, _offy - _strSingleLineHeight, false);
		
		draw_set_color(c_white);
		draw_set_alpha(1.0);
		
		draw_text(0, _offy - string_height(strChatHistory), strChatHistory);
	}
	
	if(keyboard_check_pressed(vk_tab)) {
		chatHistoryOn = !chatHistoryOn;
	}
}

draw_set_color(c_black);
draw_set_alpha(0.5);

var _emoteTipTest = "按住~键打开表情轮盘";
GUI_DrawRectangle(0, 0, string_width(_emoteTipTest) * 0.8, 32 * 0.8);

draw_set_color(c_white);

GUI_DrawTextTransformed(0, 0, _emoteTipTest, 0.8, 0.8, 0, false);

draw_set_alpha(1.0);

