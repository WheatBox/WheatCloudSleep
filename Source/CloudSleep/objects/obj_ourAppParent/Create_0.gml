// 这两个变量会由创建该ourApp的obj_ourPhone来控制
// 作用是确定实际的屏幕位置来用作与输入相关的事情
x = 0;
y = 0;

// 鼠标坐标（对于我的surf来说的坐标）
mouseXOnSurf = 0;
mouseYOnSurf = 0;

screenWidth = OurPhoneScreenWidth;
screenHeight = OurPhoneScreenHeight;

pressed = false; // 该ourApp是否被点击
working = false; // 该ourApp是否有在允许

surf = -1;

MySurfCreate = function() {
	MySurfFree();
	surf = surface_create(OurPhoneScreenWidth, OurPhoneScreenHeight);
}

MySurfFree = function() {
	if(surf != -1)
	if(surface_exists(surf)) {
		surface_free(surf);
		surf = -1;
	}
}

