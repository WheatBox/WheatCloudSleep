depth = -11451;

cameraCenterX = NewSleeperPosX;
cameraCenterY = NewSleeperPosY;

scaleMulitply = 0.9;

mouseXPrevious = undefined;
mouseYPrevious = undefined;

camera_set_view_pos(view_camera[0], cameraCenterX - camera_get_view_width(view_camera[0]) / 2, cameraCenterY - camera_get_view_height(view_camera[0]) / 2);

canControlDelayTime = 2;

findingPlayer = true;
findingPlayerCurveX = 0;
findingPlayerStartX = cameraCenterX;
findingPlayerStartY = cameraCenterY;

mouseCameraMoveLock = false;

MyCameraLinear = function(curveX, a, b) {
	var curve = animcurve_get(animcurve_cameraLinear);
	var curveY = animcurve_channel_evaluate(curve.channels[0], curveX);
	return a + (b - a) * curveY;
}

windowWidth = 1280;
windowHeight = 720;

