event_inherited();

scrollY = 0;
scrollYSpeed = 50;

arrWallpaperFilenameDefault = [
	":opendir", // 非文件名的前面加个":"防止和文件名弄混（因为文件名里无法包含":")
	":refresh",
	":defaultSpr",
	// 从后面开始就是文件名了（不带文件路径
	// （统一存在 FILEPATH_ourPhoneWallpapers 里
];

arrWallpaperFilename = [];

MyRefresh = function() {
	array_delete(arrWallpaperFilename, 0, array_length(arrWallpaperFilename));
	array_copy(arrWallpaperFilename, 0, arrWallpaperFilenameDefault, 0, array_length(arrWallpaperFilenameDefault));
	
	var _arrFnameExtentionsTemp = ["*.png", "*.jpg", "*.jpeg"];
	for(var i = 0; i < array_length(_arrFnameExtentionsTemp); i++) {
		var _fnameFind = file_find_first(FILEPATH_ourPhoneWallpapers + _arrFnameExtentionsTemp[i], 0);
		while(_fnameFind != "") {
			array_push(arrWallpaperFilename, _fnameFind);
			_fnameFind = file_find_next();
		}
		file_find_close();
	}
}
MyRefresh();

