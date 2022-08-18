var cameraW = camera_get_view_width(view_camera[0]);
var cameraH = camera_get_view_height(view_camera[0]);
if(mouse_wheel_up()) {
	camera_set_view_size(view_camera[0], cameraW * scaleMulitply, cameraH * scaleMulitply);
} else if(mouse_wheel_down()) {
	camera_set_view_size(view_camera[0], cameraW / scaleMulitply, cameraH / scaleMulitply);
}

cameraW = camera_get_view_width(view_camera[0]);
cameraH = camera_get_view_height(view_camera[0]);

mouseXPrevious ??= mouse_x;
mouseYPrevious ??= mouse_y;

if(mouse_check_button(mb_right)) {
	cameraCenterX -= mouse_x - mouseXPrevious;
	cameraCenterY -= mouse_y - mouseYPrevious;
}

camera_set_view_pos(view_camera[0], cameraCenterX - cameraW / 2, cameraCenterY - cameraH / 2);

mouseXPrevious = mouse_x;
mouseYPrevious = mouse_y;

