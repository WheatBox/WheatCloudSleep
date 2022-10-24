event_inherited();

eMyScene = {
	AllSleepers : 0,
	RecentSleepers : 1,
	Chat : 2,
};

myScene = eMyScene.AllSleepers;
chatScenePrevScene = myScene; // 聊天页面返回到哪个页面

MyChangeScene = function(_eMyScene) {
	myScene = _eMyScene;
}

chattingTarget = -1;

scrollY = 0;

titleHeight = 32;
bottomHeight = 32;

arrRecentSleeperId = [];

MySleeperBlock = function(iy, _sleeperId) {
	var _scale = 0.8;
	
	var _xoff = 10;
	var _yoff = titleHeight + 1 + scrollY;
	var _blockHeight = 32 * _scale;
	
	var _strTemp = string(_sleeperId);
	if(obj_client.MyCanUseSleeperId(_sleeperId)) {
		_strTemp += "@" + string(obj_client.sleepers[_sleeperId].name);
	}
	draw_text_transformed(_xoff, _yoff, _strTemp, _scale, _scale, 0);
	
	if(gMouseOnOurPhoneY > titleHeight)
	if(gMouseOnOurPhoneY < OurPhoneScreenHeight - bottomHeight)
	if(OurPhoneGUI_MouseGuiOnMe(0, _yoff + _blockHeight * iy, OurPhoneScreenWidth, _yoff + _blockHeight * (iy + 1) - 1)) {
		draw_set_alpha(0.3);
		draw_rectangle(0, _yoff + _blockHeight * iy, OurPhoneScreenWidth, _yoff + _blockHeight * (iy + 1) - 1, false);
		draw_set_alpha(1.0);
		
		GUI_SetCursorHandpoint();
		
		if(MouseLeftPressed()) {
			chattingTarget = _sleeperId;
			
			chatScenePrevScene = myScene;
			MyChangeScene(eMyScene.Chat);
		}
	}
}

MySelectSleepersScene = function() {
	var _mouseLeftPressed = MouseLeftPressed();

	SurfaceClear();

	draw_set_color(c_black);
	draw_set_alpha(0.8);
	draw_rectangle(0, 0, OurPhoneScreenWidth, OurPhoneScreenHeight, false);

	if(InstanceExists(obj_client)) {
		var _sleeperIdMin = obj_client.MyGetSleeperIdMin();
		var _sleeperIdMax = obj_client.MyGetSleeperIdMax();
	
		draw_set_color(c_white);
		draw_set_alpha(1.0);
	
		if(myScene == eMyScene.AllSleepers) {
			var iy = 0;
			for(var i = _sleeperIdMin; i <= _sleeperIdMax; i++) {
				if(obj_client.MyCanUseSleeperId(i)) {
					MySleeperBlock(iy, i);
					iy++;
				}
			}
		} else if(myScene == eMyScene.AllSleepers) {
			var _arrlen = array_length(arrRecentSleeperId);
			for(var j = 0; j < _arrlen; j++) {
				MySleeperBlock(j, arrRecentSleeperId[j]);
			}
		}
	
		SurfaceClearArea(0, 0, OurPhoneScreenWidth, titleHeight);
		SurfaceClearArea(0, OurPhoneScreenHeight - bottomHeight, OurPhoneScreenWidth, OurPhoneScreenHeight);
	
		draw_set_color(c_black);
		draw_set_alpha(0.6);
		draw_rectangle(0, 0, OurPhoneScreenWidth, titleHeight, false);
		draw_rectangle(0, OurPhoneScreenHeight - bottomHeight, OurPhoneScreenWidth, OurPhoneScreenHeight, false);
	
		draw_set_color(c_white);
		draw_set_alpha(1.0);
		var _titleText = "";
		switch(myScene) {
			case eMyScene.AllSleepers:
				_titleText = "全部在线睡客：";
				break;
			case eMyScene.RecentSleepers:
				_titleText = "最近打开：";
				break;
		}
		draw_text(8, 2, _titleText);
	
		var _buttonSceneAllText = "全部";
		var _buttonSceneRecentText = "最近";
		var _buttonSceneTextY = OurPhoneScreenHeight - bottomHeight;
		draw_text(-string_width(_buttonSceneAllText) / 2 + 1 * OurPhoneScreenWidth / 4, _buttonSceneTextY, _buttonSceneAllText);
		draw_text(-string_width(_buttonSceneRecentText) / 2 + 3 * OurPhoneScreenWidth / 4, _buttonSceneTextY, _buttonSceneRecentText);
	
		if(OurPhoneGUI_MouseGuiOnMe(0, _buttonSceneTextY, OurPhoneScreenWidth / 2 - 1, OurPhoneScreenHeight)) {
			draw_set_alpha(0.5);
			draw_rectangle(0, _buttonSceneTextY, OurPhoneScreenWidth / 2 - 1, OurPhoneScreenHeight, false);
		
			GUI_SetCursorHandpoint();
		
			if(_mouseLeftPressed) {
				MyChangeScene(eMyScene.AllSleepers);
			}
		} else if(OurPhoneGUI_MouseGuiOnMe(OurPhoneScreenWidth / 2, _buttonSceneTextY, OurPhoneScreenWidth, OurPhoneScreenHeight)) {
			draw_set_alpha(0.5);
			draw_rectangle(OurPhoneScreenWidth / 2, _buttonSceneTextY, OurPhoneScreenWidth, OurPhoneScreenHeight, false);
		
			GUI_SetCursorHandpoint();
		
			if(_mouseLeftPressed) {
				MyChangeScene(eMyScene.RecentSleepers);
			}
		}
	
		draw_set_alpha(1.0);
		draw_set_color(c_white);
	}
}

chatBottomHeight = 72;

myChatTextbox = new OurPhoneGuiElement_TextBox(
	4, OurPhoneScreenHeight - chatBottomHeight
	, OurPhoneScreenWidth - 4 - 40
	, chatBottomHeight - 4
	, // 39
	, "输入文本"
	, 0.8
);

myChatSendMessageButton = new OurPhoneGuiElement_Button(
	OurPhoneScreenWidth - 40 + 4
	, OurPhoneScreenHeight - chatBottomHeight
	, 36, chatBottomHeight - 4
	, "发\n送"
	, 
	, 
	, , 0.8, , 0.8,
);

MyChatScene = function() {
	var _mouseLeftPressed = MouseLeftPressed();

	SurfaceClear();

	draw_set_color(c_black);
	draw_set_alpha(0.8);
	draw_rectangle(0, 0, OurPhoneScreenWidth, OurPhoneScreenHeight, false);
	
	if(InstanceExists(obj_client)) {
		
		SurfaceClearArea(0, 0, OurPhoneScreenWidth, titleHeight);
		// SurfaceClearArea(0, OurPhoneScreenHeight - chatBottomHeight, OurPhoneScreenWidth, OurPhoneScreenHeight);
	
		draw_set_color(c_black);
		draw_set_alpha(0.6);
		draw_rectangle(0, 0, OurPhoneScreenWidth, titleHeight, false);
		draw_set_color(#DDDDDD);
		draw_set_alpha(0.8);
		draw_rectangle(4, OurPhoneScreenHeight - chatBottomHeight, OurPhoneScreenWidth - 40, OurPhoneScreenHeight - 4, false);
	
		draw_set_color(c_white);
		draw_set_alpha(1.0);
		
		draw_text(8, 2, "<");
		if(OurPhoneGUI_MouseGuiOnMe(0, 0, 24, titleHeight)) {
			draw_set_alpha(0.5);
			draw_rectangle(0, 0, 24, titleHeight, false);
			
			GUI_SetCursorHandpoint();
			
			if(_mouseLeftPressed) {
				myChatTextbox.ClearContent();
				
				MyChangeScene(chatScenePrevScene);
			}
		}
		
		draw_set_alpha(1.0);
		var _titleText = string(chattingTarget);
		if(obj_client.MyCanUseSleeperId(chattingTarget)) {
			_titleText += "@" + string(obj_client.sleepers[chattingTarget].name);
		}
		draw_text(28, 2, _titleText);
		
		myChatTextbox.WorkEasy();
		myChatSendMessageButton.WorkEasy();
	}
	
	draw_set_color(c_white);
	draw_set_alpha(1.0);
}

