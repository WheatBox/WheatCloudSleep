// #macro NewSleeperPosX 3300
// #macro NewSleeperPosY 2700
#macro NewSleeperPosX -100000
#macro NewSleeperPosY -100000


// 这里 SleeperType 的内容的顺序要和服务器上一样
enum SleeperType {
	Girl,
	Boy
};


globalvar gShowSleeperId;
gShowSleeperId = false;

globalvar myName, myType, mySleeperId;
myName = "";
// myType = SleeperType.Boy;
myType = -1;
mySleeperId = -1;

// gArrSleepersInitPosx [type][第几个随机位置]
// 例如：{ { 100, 200, 400 }, { 60, 600 } }
// 就是有两个睡客类型的出生点信息，type0的睡客有3个随机出生点（x = 100, x = 200, x = 300）,type1的睡客有3个随机出生点（x = 60, x = 600）
globalvar gArrSleepersInitPosx, gArrSleepersInitPosy;
gArrSleepersInitPosx = [];
gArrSleepersInitPosy = [];

function GetSleeperType(val) {
	/*
	switch(val) {
		case 0:
			return SleeperType.Girl;
		case 1:
			return SleeperType.Boy;
	}
	
	return SleeperType.Boy;
	*/
	return val;
}

/// @desc 创建睡客
function CreateSleeper(_x, _y) {
	var newins = instance_create_depth(_x, _y, 0, obj_sleeper);
	return newins;
}

