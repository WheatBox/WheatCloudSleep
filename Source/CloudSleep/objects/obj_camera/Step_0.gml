if(canControlDelayTime > 0) {
	canControlDelayTime--;
	exit;
}

if(IsMouseOnGUI == false) {
	mouseCameraMoveLock = false;
} else {
	mouseCameraMoveLock = true;
}

var _px = 0;
var _py = 0;
if(obj_client.MyCanUseSleeperId(mySleeperId)) {
	_px = obj_client.sleepers[mySleeperId].x;
	_py = obj_client.sleepers[mySleeperId].y - 64;
}

var cameraW = camera_get_view_width(view_camera[0]);
var cameraH = camera_get_view_height(view_camera[0]);
if(IsMouseOnGUI == false && mouse_wheel_up() && CameraScale(0, true) > 0.1 && CameraScale(1, true) > 0.1) {
	camera_set_view_size(view_camera[0], cameraW * scaleMulitply, cameraH * scaleMulitply);
} else if(IsMouseOnGUI == false && mouse_wheel_down() && CameraScale(0, true) < 3 && CameraScale(1, true) < 3) {
	camera_set_view_size(view_camera[0], cameraW / scaleMulitply, cameraH / scaleMulitply);
}

cameraW = camera_get_view_width(view_camera[0]);
cameraH = camera_get_view_height(view_camera[0]);

mouseXPrevious ??= mouse_x;
mouseYPrevious ??= mouse_y;
// show_debug_message([gMouseOnGUI, mouseCameraMoveLock]);
if(mouse_check_button(mb_left) && mouseCameraMoveLock == false) {
	cameraCenterX -= mouse_x - mouseXPrevious;
	cameraCenterY -= mouse_y - mouseYPrevious;
	
	findingPlayer = false;
}

var _distanceTemp = point_distance(cameraCenterX, cameraCenterY, _px, _py);
if(_distanceTemp > CameraMaxDragDistance) {
	var _dirTemp = point_direction(cameraCenterX, cameraCenterY, _px, _py);
	cameraCenterX -= lengthdir_x(CameraMaxDragDistance - _distanceTemp, _dirTemp);
	cameraCenterY -= lengthdir_y(CameraMaxDragDistance - _distanceTemp, _dirTemp);
}

camera_set_view_pos(view_camera[0], cameraCenterX - cameraW / 2, cameraCenterY - cameraH / 2);

mouseXPrevious = mouse_x;
mouseYPrevious = mouse_y;


if(keyboard_check_pressed(vk_space) && findingPlayer == false && mouseCameraMoveLock == false && instance_exists(obj_client)) {
	if(obj_client.MyCanUseSleeperId(mySleeperId)) {
		findingPlayer = true;
		findingPlayerCurveX = 0;
		findingPlayerStartX = cameraCenterX;
		findingPlayerStartY = cameraCenterY;
	}
}


if(findingPlayer && InstanceExists(obj_client))
if(obj_client.MyCanUseSleeperId(mySleeperId)) {
	findingPlayerCurveX += 0.01;
	cameraCenterX = MyCameraLinear(findingPlayerCurveX, findingPlayerStartX, obj_client.sleepers[mySleeperId].x);
	cameraCenterY = MyCameraLinear(findingPlayerCurveX, findingPlayerStartY, obj_client.sleepers[mySleeperId].y - 44);
	// cameraCenterX = _px;
	// cameraCenterY = _py;
}


if(__MouseOnGUIBackswing > 0) {
	__MouseOnGUIBackswing--;
}
if(gMouseOnGUI) {
	gMouseOnGUI = false;
	
	__MouseOnGUIBackswing = 1;
}

if(__MouseOnOurPhoneBackswing > 0) {
	__MouseOnOurPhoneBackswing--;
}
if(gMouseOnOurPhone) {
	gMouseOnOurPhone = false;
	
	__MouseOnOurPhoneBackswing = 1;
}