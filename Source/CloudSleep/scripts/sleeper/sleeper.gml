// 这里 SleeperType 的内容的顺序要和服务器上一样
enum SleeperType {
	Girl,
	Boy
};

globalvar myName, myType;
myName = "";
myType = SleeperType.Boy;

function GetSleeperType(val) {
	switch(val) {
		case 0:
			return SleeperType.Girl;
		case 1:
			return SleeperType.Boy;
	}
	
	return SleeperType.Boy;
}

