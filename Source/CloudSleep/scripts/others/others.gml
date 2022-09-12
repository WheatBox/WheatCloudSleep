#macro while_ until !

globalvar gWindowResized;
gWindowResized = false;

randomize();

function DrawTextSetLU() {
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}

function DrawTextSetMid() {
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
}

function DrawChat(_x, _y, _chatText) {
	draw_set_color(c_black);
	draw_set_font(fontRegular);
	
	var baseWidth = 58;
	
	draw_sprite_ext(spr_ChatBackground, 0, _x, _y + 2, (string_width(_chatText) + baseWidth) / sprite_get_width(spr_ChatBackground), 1, 0, c_white, 0.8);
	draw_set_alpha(0.8);
	draw_sprite(spr_ChatBackgroundTail, 0, _x, _y + 2);
	
	draw_set_alpha(1.0);
	
	DrawTextSetMid();
	draw_text(_x, _y, _chatText);
	DrawTextSetLU();
	
	draw_set_color(c_white);
}

function IsNight() {
	static nightBeginHour = 22, nightBeginMinute = 30;
	static nightEndHour = 6;
	
	// show_debug_message([current_hour, current_minute]);
	
	if((current_hour > nightBeginHour || (current_hour == nightBeginHour && current_minute >= nightBeginMinute)) || current_hour <= nightEndHour) {
		return true;
	}
	
	return false;
}



/// @desc DebugMes
/// @arg {Any} arg
function DebugMes(arg, inScript = false) {
	str = string(arg);
	if(inScript) {
		show_debug_message(str);
	} else {
		show_debug_message(object_get_name(object_index) + "-" + string(id) + ": " + str);
	}
}

function CheckStructCanBeUse(_structVal) {
	if(is_struct(_structVal) == true
		&& _structVal != NULL
		&& _structVal != "null"
		&& _structVal != pointer_null
		&& _structVal != undefined
	) {
		return true;
	} else {
		return false;
	}
}

function InstanceExists(ins) {
	if(ins == undefined || ins == noone) {
		return false;
	}
	return instance_exists(ins);
}


// 虽然这两个函数的运算其实完全一样，但是还是稍微像这样区分着规范一下比较好
function GetPositionXGridStandardization(_x, gridCellSize = SCENE_CellSize) {
	return floor((_x + gridCellSize / 2) / gridCellSize) * gridCellSize;
}
function GetPositionYGridStandardization(_y, gridCellSize = SCENE_CellSize) {
	return GetPositionXGridStandardization(_y, gridCellSize);
}


function ArrayReverse(arr) {
	var len = array_length(arr);
	for(var i = 0; i < len / 2; i++) {
		var t = arr[i];
		arr[i] = arr[len - i - 1];
		arr[len - i - 1] = t;
	}
}


/// @desc 同步 depth
function AsyncDepth(_y = y) {
	depth = - GetPositionYOnGUI(_y) + SceneDepthDynamicAdd;
}


/// @desc 生成GUID
/// @arg {bool} withBrace 是否带有首尾的大括号，默认 true
function GuidGenerate(withBrace = true) {
	var S4 = function() {
		var str = DECtoHEX((1 + irandom_range(0, 999999) / 1000000) * 0x10000 | 0);
		return string_copy(str, 1 + 1, string_length(str) - 1);
	}
	
	var res = S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4();
	
	if(withBrace) {
		return "{" + res + "}";
	}
	
	return res;
}

