var str = string(whoVoteSleeperId) + "[@" + whoVoteName + "] 发起投票是否踢出 " + string(kickSleeperId) + "[@" + kickName + "]";
str += "\n按下F1 同意踢出，当前同意人数：" + string(agreesNum);
str += "\n按下F2 反对踢出，当前反对人数：" + string(refusesNum);

var _scale = 0.8;

var _offX = 64 * _scale;
var _offY = 64;

var _strH = string_height(str);

// 绘制红色底色
draw_set_alpha(0.8);
draw_set_color(#76000C);
draw_rectangle(_offX, _offY * _scale, _offX + string_width(str) * _scale, (_offY + _strH) * _scale, false);

// 绘制踢人的字符串
draw_set_color(c_white);
draw_text_transformed(_offX, _offY * _scale, str, _scale, _scale, 0);


var _showChatHistoryStr1 = "鼠标悬停以显示 " + string(whoVoteSleeperId) + " 最近的聊天记录";
var _showChatHistoryStr1Width = string_width(_showChatHistoryStr1) * _scale;
var _showChatHistoryStr2 = "鼠标悬停以显示 " + string(kickSleeperId) + " 最近的聊天记录";
var _showChatHistoryStr2Width = string_width(_showChatHistoryStr2) * _scale;

// 绘制“鼠标悬停以显示最近的聊天记录”标签的黑色底色
var _offYTempBasic = (_offY + _strH + 1) * _scale + 16;
var _offYTemp = _offYTempBasic;
var _offYTempAdd = 32 + 1;
draw_set_color(c_black);
draw_rectangle(_offX, _offYTemp, _offX + _showChatHistoryStr1Width, _offYTemp + 32 * _scale, false);
_offYTemp += _offYTempAdd;
draw_rectangle(_offX, _offYTemp, _offX + _showChatHistoryStr2Width, _offYTemp + 32 * _scale, false);

// 绘制“鼠标悬停以显示最近的聊天记录”标签的文字
_offYTemp = _offYTempBasic;
draw_set_color(c_white);
draw_text_transformed(_offX, _offYTemp, _showChatHistoryStr1, _scale, _scale, 0);
_offYTemp += _offYTempAdd;
draw_text_transformed(_offX, _offYTemp, _showChatHistoryStr2, _scale, _scale, 0);

// 绘制聊天记录
_offYTemp = _offYTempBasic;
var _arrChatHistoryTemp = undefined;
var _strChatHistory = "";
if(InstanceExists(obj_client)) {
	if(obj_client.MyCanUseSleeperId(whoVoteSleeperId))
	if(InstanceExists(obj_client.sleepers[whoVoteSleeperId]))
	if(GUI_MouseGuiOnMe(_offX, _offYTemp, _offX + _showChatHistoryStr1Width, _offYTemp + 32 * _scale)) {
		_arrChatHistoryTemp = obj_client.sleepers[whoVoteSleeperId].myArrChatHistory;
		_strChatHistory = string(whoVoteSleeperId) + "[@" + whoVoteName + "]";
	} else {
		_offYTemp += _offYTempAdd;
		if(obj_client.MyCanUseSleeperId(kickSleeperId))
		if(InstanceExists(obj_client.sleepers[kickSleeperId]))
		if(GUI_MouseGuiOnMe(_offX, _offYTemp, _offX + _showChatHistoryStr2Width, _offYTemp + 32 * _scale)) {
			_arrChatHistoryTemp = obj_client.sleepers[kickSleeperId].myArrChatHistory;
			_strChatHistory = string(kickSleeperId) + "[@" + kickName + "]";
		}
	}
}
if(_arrChatHistoryTemp != undefined) {
	_strChatHistory += "最近的" + string(array_length(_arrChatHistoryTemp)) + "条聊天记录:\n";
	var _arrLenTemp = array_length(_arrChatHistoryTemp);
	for(var i = 0; i < _arrLenTemp; i++) {
		_strChatHistory += _arrChatHistoryTemp[i] + "\n";
	}
	
	var _strChatHistoryX = _offX + _showChatHistoryStr1Width + 32;
	
	draw_set_color(c_black);
	draw_rectangle(_strChatHistoryX, _offYTempBasic, _strChatHistoryX + string_width(_strChatHistory) * _scale, _offYTempBasic + string_height(_strChatHistory) * _scale, false);
	
	draw_set_color(c_white);
	draw_text_transformed(_strChatHistoryX, _offYTempBasic, _strChatHistory, _scale, _scale, 0);
	
}


draw_set_alpha(1);

