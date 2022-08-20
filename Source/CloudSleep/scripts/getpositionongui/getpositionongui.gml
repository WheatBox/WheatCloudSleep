/// @desc 获取某一坐标x投影到GUI上的位置
/// @param {real} _x x
/// @param {real} _cameraIndex 默认为0
/// @returns {real} 投影后的 x坐标
function GetPositionXOnGUI(_x, _cameraIndex = 0) {
	var destX = _x;
	
	destX -= camera_get_view_x(view_camera[_cameraIndex]);
	destX *= (display_get_gui_width() / camera_get_view_width(view_camera[_cameraIndex]));
	
	return destX;
}

/// @desc 获取某一坐标y投影到GUI上的位置
/// @param {real} _y y
/// @param {real} _cameraIndex 默认为0
/// @returns {real} 投影后的 y坐标
function GetPositionYOnGUI(_y, _cameraIndex = 0) {
	var destY = _y;
	
	destY -= camera_get_view_y(view_camera[_cameraIndex]);
	destY *= (display_get_gui_height() / camera_get_view_height(view_camera[_cameraIndex]));
	
	return destY;
}

