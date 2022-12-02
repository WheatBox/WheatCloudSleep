event_inherited();

eMyScene = {
	AllSleepers : 0,	// 全部在线睡客
	RecentSleepers : 1,	// 最近打开
	UnReadSleepers : 2,	// 未读消息
	
	Chat : 3, // 聊天页面
};

myScene = eMyScene.AllSleepers;
chatScenePrevScene = myScene; // 聊天页面返回到哪个页面

MyChangeScene = function(_eMyScene) {
	myScene = _eMyScene;
	
	if(myScene != eMyScene.Chat) {
		chattingTarget = -1;
		
		// MyChatSurfFree();
	}
}

chattingTarget = -1;

scrollY = 0;
scrollYChatScene = 0;
scrollYSpeed = 50;

scrollYChatSceneLockToBottom = true;

titleHeight = 32;
bottomHeight = 32;

arrRecentSleeperId = [];

// 用以标记睡客ID是否已经在arrRecentSleeperId里了
arrSleeperIdInRecent = [];
// arrSleeperIdInRecent[SleeperId]：0 = 不在，1 = 在

arrMyChatHistoryMaxLen = 128;
arrMyChatHistory = [];
// arrMyChatHistory[对方的SleeperId][第几条][0]：0 = 自己，1 = 对方
// arrMyChatHistory[对方的SleeperId][第几条][1]：聊天信息

// 用以标记是否有新消息
arrMyChatTokenNewMes = [];
// arrMyChatTokenNewMes[对方的SleeperId]：新消息数量

MySleeperBlock = function(iy, _sleeperId, _scale, _blockHeight) {
	var _xoff = 10;
	var _yoff = titleHeight + 1 + scrollY;
	
	_yoff += _blockHeight * iy;
	
	draw_set_color(c_white);
	draw_set_alpha(1.0);
	
	var _strTemp = string(_sleeperId);
	if(obj_client.MyCanUseSleeperId(_sleeperId)) {
		_strTemp += "@" + string(obj_client.sleepers[_sleeperId].name);
	} else {
		_strTemp = "(已离去)" + _strTemp;
	}
	if(_sleeperId == mySleeperId) {
		_strTemp = "(我)" + _strTemp;
	}
	draw_text_transformed(_xoff, _yoff, _strTemp, _scale, _scale, 0);
	
	if(array_length(arrMyChatTokenNewMes) > _sleeperId)
	if(arrMyChatTokenNewMes[_sleeperId] > 0) {
		var _strTokenNewMesTemp = arrMyChatTokenNewMes[_sleeperId] > 99 ? "99+" : string(arrMyChatTokenNewMes[_sleeperId]);
		
		draw_set_color(c_red);
		draw_set_alpha(0.8);
		draw_roundrect_ext(
			OurPhoneScreenWidth - 36
			, _yoff + 4
			, OurPhoneScreenWidth - 36 + 4 + string_width(_strTokenNewMesTemp) * _scale
			, _yoff + _blockHeight - 5
			, 8, 8
			, false
		);
		
		draw_set_color(c_white);
		draw_set_alpha(1.0);
		draw_text_transformed(OurPhoneScreenWidth - 36 + 3, _yoff + 1
			, _strTokenNewMesTemp
			, _scale, _scale, 0);
	}
	
	if(gMouseOnOurPhoneY > titleHeight)
	if(gMouseOnOurPhoneY < OurPhoneScreenHeight - bottomHeight)
	if(OurPhoneGUI_MouseGuiOnMe(0, _yoff, OurPhoneScreenWidth, _yoff + _blockHeight - 1)) {
		draw_set_alpha(0.3);
		draw_rectangle(0, _yoff, OurPhoneScreenWidth, _yoff + _blockHeight - 1, false);
		draw_set_alpha(1.0);
		
		GUI_SetCursorHandpoint();
		
		if(MouseLeftPressed()) {
			chattingTarget = _sleeperId;
			arrMyChatTokenNewMes[_sleeperId] = 0;
			
			scrollYChatScene = 0;
			scrollYChatSceneLockToBottom = true;
			
			MySignRecentSleeperId(_sleeperId);
			
			chatScenePrevScene = myScene;
			MyChangeScene(eMyScene.Chat);
			
			MyChatSurfClear();
			MyChatSurfRefresh();
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
	
		var _sleeperBlockNum = 0;
		var _sleeperBlockScale = 0.8;
		var _sleeperBlockHeight = 32 * 0.8;
		if(myScene == eMyScene.AllSleepers) {
			for(var i = _sleeperIdMin; i <= _sleeperIdMax; i++) {
				if(obj_client.MyCanUseSleeperId(i)) {
					MySleeperBlock(_sleeperBlockNum, i, _sleeperBlockScale, _sleeperBlockHeight);
					_sleeperBlockNum++;
				}
			}
		} else if(myScene == eMyScene.RecentSleepers) {
			var _arrlen = array_length(arrRecentSleeperId);
			for(var j = 0; j < _arrlen; j++) {
				MySleeperBlock(j, arrRecentSleeperId[j], _sleeperBlockScale, _sleeperBlockHeight);
				_sleeperBlockNum++;
			}
		} else if(myScene == eMyScene.UnReadSleepers) {
			var _iMaxTemp = min(_sleeperIdMax, array_length(arrMyChatTokenNewMes) - 1);
			
			for(var i = _sleeperIdMin; i <= _iMaxTemp; i++) {
				if(
					( // 如果 该睡客ID可用 或 睡客ID被用户打开过，这样做主要是为了防止有陌生人发奇怪的骚扰消息然后迅速退出服务器
						obj_client.MyCanUseSleeperId(i)
						|| MyIsSleeperIdInRecent(i)
					)
					&& arrMyChatTokenNewMes[i] > 0
				) {
					MySleeperBlock(_sleeperBlockNum, i, _sleeperBlockScale, _sleeperBlockHeight);
					_sleeperBlockNum++;
				}
			}
		}
		
		scrollY = ScrollYCalculate(scrollY, scrollYSpeed
			, 0, OurPhoneScreenHeight - titleHeight - bottomHeight
			, _sleeperBlockNum * _sleeperBlockHeight
		);
	
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
			case eMyScene.UnReadSleepers:
				_titleText = "未读消息：";
				break;
		}
		draw_text(8, 2, _titleText);
		
		var _numText = "(" + string(_sleeperBlockNum) + ")";
		draw_text(OurPhoneScreenWidth - 8 - string_width(_numText), 2, _numText);
	
		var _buttonSceneAllText = "全部";
		var _buttonSceneRecentText = "最近";
		var _buttonSceneUnReadText = "未读";
		var _buttonSceneTextY = OurPhoneScreenHeight - bottomHeight;
		draw_text(-string_width(_buttonSceneAllText) / 2 + 1 * OurPhoneScreenWidth / 6, _buttonSceneTextY, _buttonSceneAllText);
		draw_text(-string_width(_buttonSceneRecentText) / 2 + 3 * OurPhoneScreenWidth / 6, _buttonSceneTextY, _buttonSceneRecentText);
		draw_text(-string_width(_buttonSceneUnReadText) / 2 + 5 * OurPhoneScreenWidth / 6, _buttonSceneTextY, _buttonSceneUnReadText);
	
		if(OurPhoneGUI_MouseGuiOnMe(0, _buttonSceneTextY, OurPhoneScreenWidth / 3 - 1, OurPhoneScreenHeight)) {
			draw_set_alpha(0.5);
			draw_rectangle(0, _buttonSceneTextY, OurPhoneScreenWidth / 3 - 1, OurPhoneScreenHeight, false);
		
			GUI_SetCursorHandpoint();
		
			if(_mouseLeftPressed) {
				MyChangeScene(eMyScene.AllSleepers);
			}
		} else if(OurPhoneGUI_MouseGuiOnMe(OurPhoneScreenWidth / 3, _buttonSceneTextY, 2 * OurPhoneScreenWidth / 3 - 1, OurPhoneScreenHeight)) {
			draw_set_alpha(0.5);
			draw_rectangle(OurPhoneScreenWidth / 3, _buttonSceneTextY, 2 * OurPhoneScreenWidth / 3 - 1, OurPhoneScreenHeight, false);
		
			GUI_SetCursorHandpoint();
		
			if(_mouseLeftPressed) {
				MyChangeScene(eMyScene.RecentSleepers);
			}
		} else if(OurPhoneGUI_MouseGuiOnMe(2 * OurPhoneScreenWidth / 3, _buttonSceneTextY, OurPhoneScreenWidth, OurPhoneScreenHeight)) {
			draw_set_alpha(0.5);
			draw_rectangle(2 * OurPhoneScreenWidth / 3, _buttonSceneTextY, OurPhoneScreenWidth, OurPhoneScreenHeight, false);
		
			GUI_SetCursorHandpoint();
		
			if(_mouseLeftPressed) {
				MyChangeScene(eMyScene.UnReadSleepers);
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
	, "输入文本（按下Alt+S发送）"
	, 0.8
);

myChatSendMessageButton = new OurPhoneGuiElement_Button(
	OurPhoneScreenWidth - 40 + 4
	, OurPhoneScreenHeight - chatBottomHeight
	, 36, chatBottomHeight - 4
	, "发\n送"
	, 
	, function() {
		MyChatSendMes();
	}
	, , 0.8, , 0.8,
);

MyChatSendMes = function() {
	if(CheckStructCanBeUse(myChatTextbox)) {
		var _strTemp = myChatTextbox.GetContent();
		if(_strTemp != "") {
			SendPriChat(chattingTarget, _strTemp);
			myChatTextbox.ClearContent();
		}
	}
}

MyChatScene = function() {
	var _mouseLeftPressed = MouseLeftPressed();

	SurfaceClear();

	draw_set_color(c_black);
	draw_set_alpha(0.8);
	draw_rectangle(0, 0, OurPhoneScreenWidth, OurPhoneScreenHeight, false);
	
	if(InstanceExists(obj_client)) {
		MyCheckAndCreateChatSurf();
		
		if(myChatSurf != -1)
		if(surface_exists(myChatSurf)) {
			var _scrollYChatSceneMaxTemp = OurPhoneScreenHeight - titleHeight - chatBottomHeight - myChatSurfContentBottom;
			if(myChatSurfContentBottom < OurPhoneScreenHeight - titleHeight - chatBottomHeight) {
				_scrollYChatSceneMaxTemp = 0;
			}
			if(scrollYChatSceneLockToBottom) {
				scrollYChatScene = _scrollYChatSceneMaxTemp;
			}
			
			scrollYChatScene = ScrollYCalculate(
				scrollYChatScene
				, scrollYSpeed
				, 0, OurPhoneScreenHeight - titleHeight - chatBottomHeight
				, myChatSurfContentBottom
			);
			
			if(scrollYChatScene > _scrollYChatSceneMaxTemp) {
				scrollYChatSceneLockToBottom = false;
			} else {
				scrollYChatSceneLockToBottom = true;
			}
			
			draw_set_color(c_white);
			draw_set_alpha(1.0);
			draw_surface_part(myChatSurf
				, 0, -scrollYChatScene, OurPhoneScreenWidth, min(OurPhoneScreenHeight - titleHeight - chatBottomHeight, surface_get_height(myChatSurf))
				, 0, titleHeight
			);
		}
		
		SurfaceClearArea(0, 0, OurPhoneScreenWidth, titleHeight);
		// SurfaceClearArea(0, OurPhoneScreenHeight - chatBottomHeight, OurPhoneScreenWidth, OurPhoneScreenHeight);
	
		draw_set_color(c_black);
		draw_set_alpha(0.6);
		draw_rectangle(0, 0, OurPhoneScreenWidth, titleHeight, false);
		draw_set_color(#DDDDDD);
		draw_set_alpha(0.85);
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
		if(chattingTarget != -1) {
			if(obj_client.MyCanUseSleeperId(chattingTarget)) {
				_titleText += "@" + string(obj_client.sleepers[chattingTarget].name);
			} else {
				_titleText = "(已离去)" + _titleText;
			}
			if(chattingTarget == mySleeperId) {
				_titleText = "(我)" + _titleText;
			}
		}
		draw_text(28, 2, _titleText);
		
		myChatTextbox.WorkEasy();
		myChatSendMessageButton.WorkEasy();
		
		// Alt + S 也可发送消息
		if(myChatTextbox.haveFocus)
		if(keyboard_check(vk_alt) && keyboard_check_pressed(ord("S"))) {
			MyChatSendMes();
		}
	}
	
	draw_set_color(c_white);
	draw_set_alpha(1.0);
}

myChatSurf = -1;
myChatSurfContentBottom = 0; // myChatSurf 的有内容的最底部

MyReceiveMessage = function(_srcSleeperId, _destSleeperId, _chatStr) {
	if(_srcSleeperId != mySleeperId && _destSleeperId != mySleeperId) {
		// 如果根本不是 某人与自己沟通 或 自己与某人沟通 的消息，return;
		return;
	}
	
	var _anotherSleeperId = _destSleeperId;
	if(_anotherSleeperId == mySleeperId) {
		_anotherSleeperId = _srcSleeperId;
	}
	
	if(array_length(arrMyChatHistory) <= _anotherSleeperId) {
		arrMyChatHistory[_anotherSleeperId][0] = [_anotherSleeperId == _srcSleeperId, _chatStr];
	} else {
		if(is_array(arrMyChatHistory[_anotherSleeperId]) == false)
			arrMyChatHistory[_anotherSleeperId] = [];
		array_push(arrMyChatHistory[_anotherSleeperId], [_anotherSleeperId == _srcSleeperId, _chatStr]);
	}
	
	if(_anotherSleeperId != chattingTarget) {
		if(array_length(arrMyChatTokenNewMes) <= _anotherSleeperId)
			arrMyChatTokenNewMes[_anotherSleeperId] = 0;
		arrMyChatTokenNewMes[_anotherSleeperId]++;
	}
	
	if(_anotherSleeperId == chattingTarget) {
		MyChatSurfRefresh();
	}
	
	if(array_length(arrMyChatHistory[_anotherSleeperId]) > arrMyChatHistoryMaxLen) {
		array_delete(arrMyChatHistory[_anotherSleeperId], 0, 1);
	}
}

MyChatSurfFree = function() {
	if(myChatSurf != -1)
	if(surface_exists(myChatSurf)) {
		surface_free(myChatSurf);
		myChatSurf = -1;
	}
}

MyChatSurfRefresh = function() {
	// MyChatSurfFree();
	MyCheckAndCreateChatSurf(true);
}

MyCheckAndCreateChatSurf = function(_refresh = false) {
	if(array_length(arrMyChatHistory) <= chattingTarget) {
		return;
	}
	if(myChatSurf != -1 && surface_exists(myChatSurf)) {
		// return;
	} else {
		myChatSurf = surface_create(OurPhoneScreenWidth, 16384);
		_refresh = true;
	}
	
	if(_refresh == false)
		return;
	
	var _surfTargetTemp = surface_get_target();
	if(_surfTargetTemp != -1) {
		surface_reset_target();
	}
	
	surface_set_target(myChatSurf);
	
	SurfaceClear();
	
	var _scale = 0.8;
	
	var len = array_length(arrMyChatHistory[chattingTarget]);
	var _toEdgeLR = 12;
	var chatBlocksSpace = 4;
	
	var _yoff = 8;
	for(var i = 0; i < len; i++) {
		var _strTemp = arrMyChatHistory[chattingTarget][i][1];
		_strTemp = StringAutoWarp(_strTemp, (OurPhoneScreenWidth - _toEdgeLR - 32) / _scale);
		
		var _xoffL = 0, _xoffR = 0;
		if(arrMyChatHistory[chattingTarget][i][0] == 1) {
			_xoffL = _toEdgeLR;
			_xoffR = _xoffL + string_width(_strTemp) * _scale;
		} else {
			_xoffR = OurPhoneScreenWidth - _toEdgeLR;
			_xoffL = _xoffR - string_width(_strTemp) * _scale;
		}
		
		var _heightTemp = string_height(_strTemp) * _scale;
		
		for(var _j = 0; _j <= 1; _j++) {
			if(_j == 0) {
				draw_set_color(c_black);
				draw_set_alpha(0.9);
			} else {
				draw_set_color(c_white);
				draw_set_alpha(0.4);
			}
			draw_roundrect_ext(
				_xoffL - 4
				, _yoff
				, _xoffR + 4
				, _yoff + _heightTemp
				, 16, 16, _j
			);
		}
		
		draw_set_color(c_white);
		draw_set_alpha(1.0);
		draw_text_transformed(_xoffL, _yoff, _strTemp, _scale, _scale, 0);
		
		_yoff += _heightTemp + chatBlocksSpace;
	}
	draw_set_color(c_white);
	draw_set_alpha(1.0);
	
	surface_reset_target();
	
	if(_surfTargetTemp != -1) {
		surface_set_target(_surfTargetTemp);
	}
	
	myChatSurfContentBottom = _yoff;
}

MySignRecentSleeperId = function(_sleeperId) {
	var len = array_length(arrRecentSleeperId);
	
	if(MyIsSleeperIdInRecent(_sleeperId))
	for(var i = 0; i < len; i++) {
		if(arrRecentSleeperId[i] == _sleeperId) {
			array_delete(arrRecentSleeperId, i, 1);
			break;
		}
	}
	
	array_insert(arrRecentSleeperId, 0, _sleeperId);
	
	arrSleeperIdInRecent[_sleeperId] = 1;
}

MyIsSleeperIdInRecent = function(_sleeperId) {
	if(array_length(arrSleeperIdInRecent) <= _sleeperId) {
		return false;
	}
	return arrSleeperIdInRecent[_sleeperId] != 0;
}

MyChatSurfClear = function() {
	if(myChatSurf != -1)
	if(surface_exists(myChatSurf)) {
		var _surfTargetTemp = surface_get_target();
		if(_surfTargetTemp != -1)
			surface_reset_target();
		surface_set_target(myChatSurf);
		SurfaceClear();
		surface_reset_target();
		if(_surfTargetTemp != -1)
			surface_set_target(_surfTargetTemp);
	}
}
