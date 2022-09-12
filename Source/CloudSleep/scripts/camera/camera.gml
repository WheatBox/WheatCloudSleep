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

function CameraScale(useWidth_0_OrHeight_1_ = 0, useDefaultGuiSize = false) {
	if(useWidth_0_OrHeight_1_) {
		if(useDefaultGuiSize) {
			return CameraHeight() / 720;
		} else {
			return CameraHeight() / GuiHeight();
		}
	}
	if(useDefaultGuiSize) {
		return CameraWidth() / 1280;
	} else {
		return CameraWidth() / GuiWidth();
	}
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

function GuiWidth() {
	return display_get_gui_width();
}

function GuiHeight() {
	return display_get_gui_height();
}

