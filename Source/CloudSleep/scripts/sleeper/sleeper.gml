#macro NewSleeperPosX 640
#macro NewSleeperPosY 360

// 这里 SleeperType 的内容的顺序要和服务器上一样
enum SleeperType {
	Girl,
	Boy
};

globalvar myName, myType, mySleeperId;
myName = "";
myType = SleeperType.Boy;
mySleeperId = -1;

function GetSleeperType(val) {
	switch(val) {
		case 0:
			return SleeperType.Girl;
		case 1:
			return SleeperType.Boy;
	}
	
	return SleeperType.Boy;
}

/// @desc 创建睡客
function CreateSleeper(_x, _y) {
	var newins = instance_create_depth(_x, _y, 0, obj_sleeper);
	return newins;
}

