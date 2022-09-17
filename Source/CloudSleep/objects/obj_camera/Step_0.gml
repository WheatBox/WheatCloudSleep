if(canControlDelayTime > 0) {
	canControlDelayTime--;
	exit;
}

if(gMouseOnGUI == false) {
	mouseCameraMoveLock = false;
} else {
	mouseCameraMoveLock = true;
}

var cameraW = camera_get_view_width(view_camera[0]);
var cameraH = camera_get_view_height(view_camera[0]);
if(gMouseOnGUI == false && mouse_wheel_up() && CameraScale(0, true) > 0.1 && CameraScale(1, true) > 0.1) {
	camera_set_view_size(view_camera[0], cameraW * scaleMulitply, cameraH * scaleMulitply);
} else if(gMouseOnGUI == false && mouse_wheel_down() && CameraScale(0, true) < 3 && CameraScale(1, true) < 3) {
	camera_set_view_size(view_camera[0], cameraW / scaleMulitply, cameraH / scaleMulitply);
}

cameraW = camera_get_view_width(view_camera[0]);
cameraH = camera_get_view_height(view_camera[0]);

if(0) {
mouseXPrevious ??= mouse_x;
mouseYPrevious ??= mouse_y;
// show_debug_message([gMouseOnGUI, mouseCameraMoveLock]);
if(mouse_check_button(mb_left) && mouseCameraMoveLock == false) {
	cameraCenterX -= mouse_x - mouseXPrevious;
	cameraCenterY -= mouse_y - mouseYPrevious;
	
	findingPlayer = false;
}
} else findingPlayer = true;
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


if(findingPlayer && InstanceExists(obj_client)) {
	if(obj_client.MyCanUseSleeperId(mySleeperId)) {
		findingPlayerCurveX += 0.01;
		// cameraCenterX = MyCameraLinear(findingPlayerCurveX, findingPlayerStartX, obj_client.sleepers[mySleeperId].x);
		// cameraCenterY = MyCameraLinear(findingPlayerCurveX, findingPlayerStartY, obj_client.sleepers[mySleeperId].y - 44);
		cameraCenterX = obj_client.sleepers[mySleeperId].x;
		cameraCenterY = obj_client.sleepers[mySleeperId].y - 64;
	}
}



gMouseOnGUI = false;