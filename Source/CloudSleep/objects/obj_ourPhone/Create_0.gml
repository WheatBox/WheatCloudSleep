// arrOurApps[i].ins = id，arrOurApps[i].iconSpr = spr;
arrOurApps = [
	OurPhone_CreateOurApp(obj_ourApp_CustomWallpaper, spr_ourApp_CustomWallpaper),
	OurPhone_CreateOurApp(obj_ourApp_MusicPlayer, spr_ourApp_MusicPlayer),
	// OurPhone_CreateOurApp(obj_ourApp_WebBrowser, spr_ourApp_WebBrowser),
	OurPhone_CreateOurApp(obj_ourApp_Report, spr_ourApp_Report),
];

depth = OurPhoneDepth;

screenWidth = OurPhoneScreenWidth;
screenHeight = OurPhoneScreenHeight;

working = false;

yAddBegin = 320;
yAddEnd = -544;

yAdd = yAddBegin;
xAdd = x - 1280;

mouseOnMe = false;


MyWork = function() {
	working = true;
}
MyStopWork = function() {
	working = false;
}

MyPressApp = function(iArrOurApps = -1) {
	var arrOurAppsSiz = array_length(arrOurApps);
	for(var i = 0; i < arrOurAppsSiz; i++) {
		if(InstanceExists(arrOurApps[i].ins)) {
			arrOurApps[i].ins.working = false;
		}
	}
	if(iArrOurApps >= 0 && iArrOurApps < arrOurAppsSiz) {
		if(InstanceExists(arrOurApps[iArrOurApps].ins)) {
			arrOurApps[iArrOurApps].ins.pressed = true;
			arrOurApps[iArrOurApps].ins.working = true;
		}
	}
}


buttonHomeX = x;
buttonHomeY = y;
buttonHomeWidth = sprite_get_width(spr_ourPhone_ButtonHome);
buttonHomeHeight = sprite_get_height(spr_ourPhone_ButtonHome);
buttonHomeMouseOnMe = false;
MyCheckMouseOnButtonHome = function() {
	static widthHalf = buttonHomeWidth / 2;
	static heightHalf = buttonHomeHeight / 2;
	
	buttonHomeX = x + 200;
	buttonHomeY = y + 432 + 22;
	
	if(GUI_MouseGuiOnMe(buttonHomeX - widthHalf, buttonHomeY - heightHalf, buttonHomeX + widthHalf, buttonHomeY + heightHalf)) {
		return true;
	}
	return false;
}


// 该surface会由obj_ourApp_xxxx控制
myOurAppTransLerpAmount = 0.25;

myOurAppSurf = -1;
myOurAppSurfStatic = -1;

myOurAppSurfAlpha = 1.0;
myOurAppSurfX = 0;
myOurAppSurfY = 0;
myOurAppSurfXscale = 1.0;
myOurAppSurfYscale = 1.0;

myOurAppWorkingIconX = 0;
myOurAppWorkingIconY = 0;


myOurAppIconAlpha = 1.0;


OurPhone_LoadWallpaper();

