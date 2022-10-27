GUI_SetCursorDefault();


var w = window_get_width();
var h = window_get_height();


gWindowResized = false;
if((w != windowWidth || h != windowHeight) && surface_exists(application_surface) && (w != 0 && h != 0)) {
	DebugMes(["WindowResize", w, h]);
	gWindowResized = true;
	
	var camw = CameraWidth();
	var camh = CameraHeight();
	
	if(w / h > 16 / 9) { // 拉长了，比16:9长
		camh = camw * (h / w);
	} else { // 拉高了，比16:9高
		camw = camh * (w / h);
	}
	
	surface_resize(application_surface, w, h);
	
	camera_set_view_size(view_camera[0], camw, camh);
	
	windowWidth = w;
	windowHeight = h;
}

InstancesOptimize();

