beds = [];

/*
var _initBedSleepId = 0;
for(var iy = 0; iy < 16; iy++) {
	for(var ix = 0; ix < 16; ix++) {
		var _offsetY = 320 + 256;
		var _offsetX = 768 + 128 + (iy % 2 == 0 ? 128 : 0);
		beds[_initBedSleepId] = CreateBed(ix * 320 + _offsetX, iy * 288 + _offsetY, _initBedSleepId);
		_initBedSleepId++;
	}
}*/

var _arrSiz = 0;
_arrSiz = array_length(gSceneStruct.backgrounds);
for(var i = 0; i < _arrSiz; i++) {
	CreateBackground(gSceneStruct.backgrounds[i].xPos + gridOffsetXAdd, gSceneStruct.backgrounds[i].yPos + gridOffsetYAdd, gSceneStruct.backgrounds[i].materialId);
}
_arrSiz = array_length(gSceneStruct.decorates);
for(var i = 0; i < _arrSiz; i++) {
	CreateDecorate(gSceneStruct.decorates[i].xPos + gridOffsetXAdd, gSceneStruct.decorates[i].yPos + gridOffsetYAdd, gSceneStruct.decorates[i].materialId);
}
_arrSiz = array_length(gSceneStruct.beds);
for(var i = 0; i < _arrSiz; i++) {
	beds[i] = CreateBed(gSceneStruct.beds[i].xPos + gridOffsetXAdd, gSceneStruct.beds[i].yPos + gridOffsetYAdd, i, gSceneStruct.beds[i].materialId);
}

alarm_set(1, 2);

// mp_grid_add_instances(grid, obj_bed, false);

sleepers = [];

SendPackGuid();
SendName();
SendType();

synchPosRateTime = 5 * 60; // 五秒向服务器发送一次自己的坐标，让其它客户端进行同步
alarm_set(0, synchPosRateTime);

MyGetSleeperIdMax = function() {
	return array_length(sleepers) - 1;
}

MyCanUseSleeperId = function(sleeperId) {
	var sleeperIdMax = MyGetSleeperIdMax();
	if(sleeperIdMax < sleeperId || sleeperId < 0) {
		return false;
	}
	if(!instance_exists(sleepers[sleeperId])) {
		return false;
	}
	return true;
}

vecChatHistory = new vector(); 
vecChatHistorySleeperId = new vector();
vecChatHistoryColor = new vector();
vecChatHistorySizeMax = ChatHistoryMaxLines;
chatHistoryOn = false;
surfChatHistory = undefined;
chatHistoryMaximumWidth = 0;
chatHistoryShowSizeMax = 15;
chatHistoryScrollY = 0;
chatHistoryScrollYSpeed = GUIScrollYSpeed;
chatHistoryStringSingleLineHeight = string_height("乐");

MyChatHistoryAdd_Basic = function(str, sleeperId = -1, color = c_white) {
	vecChatHistory.push_back(string(str));
	vecChatHistorySleeperId.push_back(sleeperId);
	vecChatHistoryColor.push_back(color);
	
	if(vecChatHistory.size() > vecChatHistorySizeMax) {
		array_delete(vecChatHistory.Container, 0, 1);
		array_delete(vecChatHistorySleeperId.Container, 0, 1);
		array_delete(vecChatHistoryColor.Container, 0, 1);
	}
	
	MyChatHistorySurfRefresh();
}

MyChatHistoryAdd = function(sleeperId, str) {
	if(MyCanUseSleeperId(sleeperId) == false || MyCanUseSleeperId(mySleeperId) == false) {
		return;
	}
	
	if(point_distance(sleepers[mySleeperId].x, sleepers[mySleeperId].y, sleepers[sleeperId].x, sleepers[sleeperId].y) > ChatHistoryRecordMaxDistance) {
		return;
	}
	
	MyChatHistoryAdd_Basic("[@" + string(sleepers[sleeperId].name) + "]: " + string(str), sleeperId);
}

MyChatHistorySurfInit = function() {
	surfChatHistory = surface_create(display_get_width(), vecChatHistorySizeMax * chatHistoryStringSingleLineHeight);
}
MyChatHistorySurfInit();

MyChatHistorySurfRefresh = function() {
	if(surface_exists(surfChatHistory) == false) {
		MyChatHistorySurfInit();
	}
	
	surface_set_target(surfChatHistory);
	
	SurfaceClear();
	
	draw_set_alpha(1);
	
	var chatHistoryLen = vecChatHistory.size();
	var strChatHistory = "";
	for(var i = 0; i < chatHistoryLen; i++) {
		strChatHistory = "";
		if(gShowSleeperId) {
			if(vecChatHistorySleeperId.Container[i] >= 0)
				strChatHistory += string(vecChatHistorySleeperId.Container[i]);
		}
		strChatHistory += vecChatHistory.Container[i];
		
		draw_set_color(vecChatHistoryColor.Container[i]);
		draw_text(0, 0 + i * chatHistoryStringSingleLineHeight, strChatHistory);
	}
	
	surface_reset_target();
	draw_set_color(c_white);
	
	
	if(vecChatHistory.size() > 0) {
		chatHistoryMaximumWidth = string_width(vecChatHistory.back());
		if(gShowSleeperId) {
			chatHistoryMaximumWidth += string_width(string(vecChatHistorySleeperId.back()));
		}
		for(var i = 1; i < min(chatHistoryShowSizeMax, vecChatHistory.size()); i++) {
			var _checkingIndex = vecChatHistory.size() - i - 1;
			if(gShowSleeperId) {
				chatHistoryMaximumWidth = max(string_width(vecChatHistory.Container[_checkingIndex] + string(vecChatHistorySleeperId.Container[_checkingIndex])), chatHistoryMaximumWidth);
			} else {
				chatHistoryMaximumWidth = max(string_width(vecChatHistory.Container[_checkingIndex]), chatHistoryMaximumWidth);
			}
		}
	}
}

MyChatHistoryAddSystemMes = function(str) {
	MyChatHistoryAdd_Basic(str, , c_yellow);
}



buttonOpenOurPhoneX = 0;
buttonOpenOurPhoneY = 0;
buttonOpenOurPhone = noone;

slidingRodSleepersLabelAlphaIns = noone;
slidingRodSleepersLabelScaleIns = noone;
slidingRodSleepersChatScaleIns = noone;

slidingRodOutFocusLayerAlphaIns = noone;

slidingRodShowSleeperIdIns = noone;
slidingRodHideVoteKickIns = noone;

alarm_set(2, 1); // 初始化各个 GUI组件


MySynchMyGuiElementsPosition = function() {
	static _SynchSlidingRodXScreenLeftFunc = function(_insTemp, _xToLeftMultiply = 1, _xToLeftMultiplyMax = 1) {
		if(InstanceExists(_insTemp)) {
			var _xTemp = _insTemp.x;
			var _yTemp = _insTemp.y;
			var _wTemp = _insTemp.width + 1;
			var _hTemp = _insTemp.height;
			if(GUI_MouseGuiOnMe(0 - 48, _yTemp, _xTemp + _wTemp + 48 + _wTemp * (_xToLeftMultiplyMax - _xToLeftMultiply), _yTemp + _hTemp) && GetPositionXOnGUI(mouse_x) > -48) {
				_xTemp = lerp(_xTemp, 0 + _wTemp * (_xToLeftMultiply - 1), 0.2);
			} else {
				_xTemp = lerp(_xTemp, 0 + 32 - _wTemp * (_xToLeftMultiplyMax - _xToLeftMultiply + 1), 0.2);
			}
			_insTemp.x = _xTemp;
		}
	}
	static _SynchSlidingRodXScreenRightFunc = function(_insTemp, _xToRightMultiply = 1, _xToRightMultiplyMax = 1) {
		if(InstanceExists(_insTemp)) {
			var _guiW = GuiWidth();
			
			var _xTemp = _insTemp.x;
			var _yTemp = _insTemp.y;
			var _wTemp = _insTemp.width + 1;
			var _hTemp = _insTemp.height;
			if(GUI_MouseGuiOnMe(_xTemp - 48 - _wTemp * (_xToRightMultiplyMax - _xToRightMultiply), _yTemp, _guiW + 48, _yTemp + _hTemp) && GetPositionXOnGUI(mouse_x) < _guiW + 48) {
				_xTemp = lerp(_xTemp, _guiW - _wTemp * _xToRightMultiply, 0.2);
			} else {
				_xTemp = lerp(_xTemp, _guiW - 32 + _wTemp * (_xToRightMultiplyMax - _xToRightMultiply), 0.2);
			}
			_insTemp.x = _xTemp;
		}
	}
	
	var _guiW = GuiWidth();
	var _guiH = GuiHeight();
	if(InstanceExists(buttonOpenOurPhone)) {
		buttonOpenOurPhoneX = _guiW - 64;
		buttonOpenOurPhoneY = _guiH - 32;
		buttonOpenOurPhone.x = buttonOpenOurPhoneX;
		buttonOpenOurPhone.y = buttonOpenOurPhoneY;
	}
	
	_SynchSlidingRodXScreenRightFunc(slidingRodSleepersLabelAlphaIns, 1, 3);
	_SynchSlidingRodXScreenRightFunc(slidingRodSleepersLabelScaleIns, 2, 3);
	_SynchSlidingRodXScreenRightFunc(slidingRodSleepersChatScaleIns, 3, 3);
	
	_SynchSlidingRodXScreenRightFunc(slidingRodOutFocusLayerAlphaIns, 1, 1);
	
	_SynchSlidingRodXScreenLeftFunc(slidingRodShowSleeperIdIns, 1, 2.5);
	_SynchSlidingRodXScreenLeftFunc(slidingRodHideVoteKickIns, 2.5, 2.5);
}
MySynchMyGuiElementsPosition();

showSleeperIdPrev = gShowSleeperId;


myTextBox = noone;

textboxPlaceHolders = [""];

try {
	if(file_exists(WORKFILEPATH + FILEJSON_TextboxPlaceHolders)) {
		var _jsonTemp = "";
		
		var file = file_text_open_read(WORKFILEPATH + FILEJSON_TextboxPlaceHolders);
		while(!file_text_eoln(file)) {
			var _lineTemp = file_text_readln(file);
			
			_lineTemp = string_replace_all(_lineTemp, "$NAME", string(myName));
			
			_jsonTemp += _lineTemp;
		}
		file_text_close(file);
		
		if(_jsonTemp != "") {
			textboxPlaceHolders = json_parse(_jsonTemp);
		}
	}
} catch(error) {
	DebugMes([error.script, error.message]);
	
	textboxPlaceHolders = ["无法正确读取聊天框背景占位文字"];
}




if(DEBUGMODE) {
	debugStrBufs = "";
}
