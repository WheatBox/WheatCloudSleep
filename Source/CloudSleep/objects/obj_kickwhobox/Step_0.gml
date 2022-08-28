if(sleeperId == -1 || OnVote) {
	instance_destroy();
}

var str = "投票踢出 @" + name;
var _x = GetPositionXOnGUI(x);
var _y = GetPositionYOnGUI(y);
var strW = string_width(str);
var strH = string_height(str);
var mx = GetPositionXOnGUI(mouse_x);
var my = GetPositionYOnGUI(mouse_y);

if(mouse_check_button(mb_left)) {
	if(mx >= _x - strW / 2 && mx < _x + strW / 2 && my >= _y - strH / 2 && my < _y + strH / 2) {
		voteLoading++;
	} else {
		CameraUnlock();
		instance_destroy();
	}
} else if(voteLoading > 0) {
	voteLoading--;
}

if(voteLoading >= voteLoadingMax) {
	CameraUnlock();
	SendKick(sleeperId);
	instance_destroy();
}

