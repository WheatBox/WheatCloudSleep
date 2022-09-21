#macro SCENE_CellSize 32
#macro SCENE_MinimumSize 10

function SCENE_MouseOnMe(left, top, right, bottom) {
	var mx = mouse_x;
	var my = mouse_y;
	var x1 = left;
	var y1 = top;
	var x2 = right;
	var y2 = bottom;
	if(point_in_rectangle(mx, my, x1, y1, x2, y2)) {
		return true;
	}
	return false;
}

function SCENE_MouseOnMe_Radius(_x, _y, _radius) {
	var mx = mouse_x;
	var my = mouse_y;
	if(point_in_rectangle(mx, my, _x - _radius, _y - _radius, _x + _radius, _y + _radius)) {
		return true;
	}
	return false;
}

function SCENE_DrawRectangleOnGui(left, top, right, bottom, outline = false) {
	draw_rectangle(
		GetPositionXOnGUI(left),
		GetPositionYOnGUI(top),
		GetPositionXOnGUI(right),
		GetPositionYOnGUI(bottom),
		outline
	);
}

function SCENE_DrawRectangleOnGui_Radius(_x, _y, _radius, outline = false) {
	draw_rectangle(
		GetPositionXOnGUI(_x) - _radius,
		GetPositionYOnGUI(_y) - _radius,
		GetPositionXOnGUI(_x) + _radius,
		GetPositionYOnGUI(_y) + _radius,
		outline
	);
}

