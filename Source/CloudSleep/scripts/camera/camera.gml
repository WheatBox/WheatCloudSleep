function CameraX() {
	return camera_get_view_x(view_camera[0]);
}

function CameraY() {
	return camera_get_view_y(view_camera[0]);
}

function CameraWidth() {
	return camera_get_view_width(view_camera[0]);
}

function CameraHeight() {
	return camera_get_view_height(view_camera[0]);
}

function CameraScale() {
	return CameraWidth() / 1280;
}

function CameraLock() {
	if(instance_exists(obj_camera)) {
		obj_camera.mouseCameraMoveLock = true;
	}
}

function CameraUnlock() {
	if(instance_exists(obj_camera)) {
		obj_camera.mouseCameraMoveLock = false;
	}
}

