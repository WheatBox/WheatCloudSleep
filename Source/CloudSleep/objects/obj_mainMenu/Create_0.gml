textboxNameX = 288;
textboxNameY = 0;
textboxNameWidth = 640;
textboxNameHeight = 28;
textboxName = textbox_create(textboxNameX, textboxNameY, textboxNameWidth, textboxNameHeight, myName, "请新睡客在此处登记名称", 32, fontRegular, function() {});
textbox_set_font(textboxName, fontRegular, GUIDefaultColor, textboxNameHeight, 0);

textboxIpPortX = textboxNameX;
textboxIpPortY = 0;
textboxIpPortWidth = textboxNameWidth;
textboxIpPortHeight = textboxNameHeight;
textboxIpPort = textbox_create(textboxIpPortX, textboxIpPortY, textboxIpPortWidth, textboxIpPortHeight, myName, "要连接的服务器地址", 32, fontRegular, function() {});
textbox_set_font(textboxIpPort, fontRegular, GUIDefaultColor, textboxIpPortHeight, 0);

buttonEnterX = textboxNameX + textboxNameWidth + 96;
buttonEnterY = (textboxNameY + textboxIpPortY + textboxNameHeight) / 2;
buttonEnterWidth = 128;
buttonEnterHeight = abs(textboxNameY - textboxIpPortY) + textboxNameHeight + 2 * 2;
buttonEnter = GuiElement_CreateButton_ext(buttonEnterX, buttonEnterY, "进去睡觉", buttonEnterWidth, buttonEnterHeight
	, , function() {
		
	}
);

buttonAboutLabel = "关于 " + ClientVersion
buttonAboutWidth = string_width(buttonAboutLabel) + 16;
buttonAboutHeight = 32;
buttonAboutX = GuiWidth() - buttonAboutWidth / 2;
buttonAboutY = buttonAboutHeight / 2;
buttonAbout = GuiElement_CreateButton_ext(buttonAboutX, buttonAboutY, buttonAboutLabel, buttonAboutWidth, buttonAboutHeight
	, , function() {
		show_message("客户端版本号\n" + ClientVersion + "\n--------------------\n" + ClientAbout);
	}
);

MyAsyncTextBoxsGUI = function() {
	textboxNameY = GuiHeight() - textboxNameHeight - 32;
	textbox_set_position(textboxName, textboxNameX, textboxNameY, false);
	textboxIpPortY = GuiHeight() - textboxIpPortHeight - 96;
	textbox_set_position(textboxIpPort, textboxIpPortX, textboxIpPortY, false);
	
	buttonEnterY = (textboxNameY + textboxIpPortY + textboxNameHeight) / 2;
	buttonEnter.y = buttonEnterY;
	buttonEnterHeight = abs(textboxNameY - textboxIpPortY) + textboxNameHeight + 2 * 2;
	buttonEnter.height = buttonEnterHeight;
	
	buttonAboutX = GuiWidth() - buttonAboutWidth / 2;
	buttonAbout.x = buttonAboutX;
}
MyAsyncTextBoxsGUI();


pageWidth = 256;

packagesPage = GuiElement_CreatePage(0, 0, "场景包列表", pageWidth, GuiHeight());

WORKFILEPATH = PACKAGESFILEPATH;

systemCmd("md " + PACKAGESFILEPATH);

GuiElement_PageAddElement(packagesPage, GuiElement_CreateButton_ext(pageWidth / 2, 0, "打开场景包所在文件夹", pageWidth - 32, 36
	, , function() {
		systemCmd("md " + PACKAGESFILEPATH);
		systemCmd("start " + PACKAGESFILEPATH);
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

packNamePrevious = PackName;

myImageMinimumWidthHeight = 160;

