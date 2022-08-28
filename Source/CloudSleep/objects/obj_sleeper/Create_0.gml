// mask_index = spr_SleeperHitbox;

timeI = irandom_range(-180, 180);
moveTimeI = 0;
anglePositive = choose(-1, 1);

isMe = false; // 是不是我自己，也就是说是不是本客户端的睡客

name = "";
type = SleeperType.Boy;

myPath = path_add();
mySpeed = 3;

MyPathCanGo = function(destX, destY) {
	var pathTemp = path_add();
	return mp_grid_path(grid, pathTemp, x, y, destX, destY, true);
}
MyPathGenerate = function(destX, destY) {
	return mp_grid_path(grid, myPath, x, y, destX, destY, true);
}
MyPathGo = function(destX, destY) {
	if(MyPathGenerate(destX, destY)) {
		path_set_kind(myPath, 1);
		path_set_precision(myPath, 8);
		path_start(myPath, mySpeed, path_action_stop, true);
		
		myPathDestX = destX;
		myPathDestY = destY;
		
		anglePositive = choose(-1, 1);
	}
}
MyPathIsRunning = function() {
	return myPathDestX != undefined;
}
MyPathStop = function() {
	path_end();
	myPathDestX = undefined;
	myPathDestY = undefined;
}
MySetPos = function(destX, destY) {
	x = destX;
	y = destY;
	
	var pathDestXtemp = myPathDestX;
	var pathDestYtemp = myPathDestY;
	MyPathStop();
	if(pathDestXtemp != undefined) {
		MyPathGo(pathDestXtemp, pathDestYtemp);
	}
}
MyChat = function(_chatText) {
	chatText = _chatText;
	chatTime = 7 * 60; // 七秒后消失
}

chatText = "";
chatTime = 0;

myPathDestX = undefined;
myPathDestY = undefined;

MySleep = function(_sleepBedId) {
	if(!instance_exists(obj_client)) {
		return;
	}
	
	obj_client.beds[_sleepBedId].MySleep(type);
	
	sleepingBedId = _sleepBedId;
	xBeforeSleep = x;
	yBeforeSleep = y;
	
	x = obj_client.beds[_sleepBedId].x;
	y = obj_client.beds[_sleepBedId].y + 88;
}
MyGetup = function() {
	if(!instance_exists(obj_client) || sleepingBedId == -1) {
		return;
	}
	
	obj_client.beds[sleepingBedId].MyGetup();
	
	sleepingBedId = -1;
	x = xBeforeSleep;
	y = yBeforeSleep;
}

willSleep = false;
sleepingBedId = -1;
xBeforeSleep = x;
yBeforeSleep = y;

sleeperId = -1;

