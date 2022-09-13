pageWidth = 256;

packagesPage = GuiElement_CreatePage(0, 0, "场景包列表", pageWidth, GuiHeight());

// WORKFILEPATH = ".\\packages\\";
WORKFILEPATH = "F:\\packages\\";

systemCmd("md " + WORKFILEPATH);

GuiElement_PageAddElement(packagesPage, GuiElement_CreateButton_ext(pageWidth / 2, 0, "打开场景包所在文件夹", pageWidth - 32, 36
	, , function() {
		systemCmd("md " + WORKFILEPATH);
		systemCmd("start " + WORKFILEPATH);
	}
));

if(directory_exists(WORKFILEPATH)) {
	var vecFolders = new vector();
	var _fnameFind = "";
	
	// 搜集 .\\packages\\ 下的所有场景包文件夹，存入 vecFolders
	_fnameFind = file_find_first(WORKFILEPATH + "*", fa_directory);
	while(_fnameFind != "") {
		if(directory_exists(WORKFILEPATH + _fnameFind)) {
			vecFolders.push_back(WORKFILEPATH + _fnameFind + "\\");
		}
		
		_fnameFind = file_find_next();
	}
	file_find_close();
	
	// 读取 vecFolders
	var vecFoldersSize = vecFolders.size();
	for(var i = 0; i < vecFoldersSize; i++) {
		_fnameFind = file_find_first(vecFolders.Container[i] + "*.cloudpack", fa_directory);
		
		if(_fnameFind != "") {
			_fnameFind = GetNameFromFileName("\\" + _fnameFind, false);
			
			GuiElement_PageAddElement(packagesPage, GuiElement_CreateButton_ext(pageWidth / 2, 0, _fnameFind, pageWidth, 36
				,[_fnameFind] , function(args) {
					PackName = args[0];
					WORKFILEPATH = WORKFILEPATH_default;
					
					DebugMes([PackName, WORKFILEPATH]);
				}
			));
		}
		
		file_find_close();
	}
}

packagesPage.MyStartWork();

windowWidth = 1280;
windowHeight = 720;
