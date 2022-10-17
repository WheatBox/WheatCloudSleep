GUI_SetCursorDefault();


var windW = window_get_width();
var windH = window_get_height();

if((windowWidth != windW || windowHeight != windH) && surface_exists(application_surface) && (windW != 0 && windH != 0)) {
	DebugMes(["WindowResize", windW, windH]);
	
	surface_resize(application_surface, windW, windH);
	
	camera_set_view_size(view_camera[0], windW * CameraScale(), windH * CameraScale());
	
	windowWidth = windW;
	windowHeight = windH;
}

