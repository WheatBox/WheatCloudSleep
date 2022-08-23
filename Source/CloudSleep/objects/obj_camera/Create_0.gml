cameraCenterX = NewSleeperPosX;
cameraCenterY = NewSleeperPosY;

scaleMulitply = 0.9;

mouseXPrevious = undefined;
mouseYPrevious = undefined;

camera_set_view_pos(view_camera[0], cameraCenterX - camera_get_view_width(view_camera[0]) / 2, cameraCenterY - camera_get_view_height(view_camera[0]) / 2);

canControlDelayTime = 2;

