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
textboxIpPort = textbox_create(textboxIpPortX, textboxIpPortY, textboxIpPortWidth, textboxIpPortHeight, PackIpPort, "要连接的服务器地址", 32, fontRegular, function() {});
textbox_set_font(textboxIpPort, fontRegular, GUIDefaultColor, textboxIpPortHeight, 0);


myEnterLock = false;
MyEnterToBedRoom = function() {
	if(myEnterLock) {
		return;
	}
	
	if(PackName == "") {
		show_message("请先选择一个场景包");
		return;
	}
	
	var _nameTemp = textbox_return(textboxName);
	
	if(string_length(_nameTemp) < NameMinimumLength) {
		show_message("名称太短了");
		return;
	}
	myName = _nameTemp;
	
	if(myType < 0) {
		show_message("请先选择一个你的睡客形象");
		return;
	}
	
	var _arrIpPort = [undefined, undefined];
	try {
		_arrIpPort = CutIpPort(textbox_return(textboxIpPort));
	} catch(error) {
		show_message("无法正常读取服务器地址\n" + error.message);
		return;
	}
	
	serverIP = _arrIpPort[0];
	serverPort = _arrIpPort[1];
	
	
	mp_grid_destroy(grid);
	
	gridOffsetXAdd = -gSceneStruct.left * gridCellSize;
	gridOffsetYAdd = -gSceneStruct.top * gridCellSize;
	grid = mp_grid_create(0, 0, gSceneStruct.right - gSceneStruct.left, gSceneStruct.bottom - gSceneStruct.top, gridCellSize, gridCellSize);
	
	
	// 初始化睡客出生点数组
	
	for(var i = 0; i < array_length(gSleepersStruct.materials); i++) {
		gArrSleepersInitPosx[i] = [];
		gArrSleepersInitPosy[i] = [];
	}
	
	var arrSceneSleepersSiz = array_length(gSceneStruct.sleepers);
	for(var i = 0; i < arrSceneSleepersSiz; i++) {
		if(array_length(gArrSleepersInitPosx[gSceneStruct.sleepers[i].materialId]) < 1) {
			gArrSleepersInitPosx[gSceneStruct.sleepers[i].materialId][0] = gSceneStruct.sleepers[i].xPos + gridOffsetXAdd;
			gArrSleepersInitPosy[gSceneStruct.sleepers[i].materialId][0] = gSceneStruct.sleepers[i].yPos + gridOffsetYAdd;
		} else {
			array_push(gArrSleepersInitPosx[gSceneStruct.sleepers[i].materialId], gSceneStruct.sleepers[i].xPos + gridOffsetXAdd);
			array_push(gArrSleepersInitPosy[gSceneStruct.sleepers[i].materialId], gSceneStruct.sleepers[i].yPos + gridOffsetYAdd);
		}
	}
	
	
	LoadCloudPack(false, true);
	
	for(var i = 0; i < array_length(gSleepersStruct.materials); i++) {
		var arroffs = gSleepersStruct.materials[i].offset;
		var spr = gSleepersSpritesStruct.sprites[i];
		
		sprite_set_bbox_mode(spr, bboxmode_automatic);
		
		if(array_length(arroffs) < 2) {
			sprite_set_offset(spr, sprite_get_width(spr) / 2, sprite_get_height(spr) / 2);
		} else {
			sprite_set_offset(spr, arroffs[0], arroffs[1]);
		}
	}
	for(var i = 0; i < array_length(gBackgroundsStruct.materials); i++) {
		var spr = gBackgroundsSpritesStruct.sprites[i];
		sprite_set_bbox_mode(spr, bboxmode_fullimage);
		sprite_set_offset(spr, sprite_get_width(spr) / 2, sprite_get_height(spr) / 2);
	}
	for(var i = 0; i < array_length(gDecoratesStruct.materials); i++) {
		var arroffs = gDecoratesStruct.materials[i].offset;
		var arrboxs = gDecoratesStruct.materials[i].hitbox;
		var spr = gDecoratesSpritesStruct.sprites[i];
		
		if(array_length(arrboxs) < 4) {
			sprite_set_bbox_mode(spr, bboxmode_automatic);
		} else {
			sprite_set_bbox_mode(spr, bboxmode_manual);
			sprite_set_bbox(spr, arrboxs[0], arrboxs[1], arrboxs[2], arrboxs[3]);
		}
		
		if(array_length(arroffs) < 2) {
			sprite_set_offset(spr, sprite_get_width(spr) / 2, sprite_get_height(spr) / 2);
		} else {
			sprite_set_offset(spr, arroffs[0], arroffs[1]);
		}
	}
	for(var i = 0; i < array_length(gBedsStruct.materials); i++) {
		var arroffs = gBedsStruct.materials[i].offset;
		var arrboxs = gBedsStruct.materials[i].hitbox;
		var spr = gBedsSpritesStruct.sprites[i];
		
		if(array_length(arrboxs) < 4) {
			sprite_set_bbox_mode(spr, bboxmode_automatic);
		} else {
			sprite_set_bbox_mode(spr, bboxmode_manual);
			sprite_set_bbox(spr, arrboxs[0], arrboxs[1], arrboxs[2], arrboxs[3]);
		}
		
		if(array_length(arroffs) < 2) {
			sprite_set_offset(spr, sprite_get_width(spr) / 2, sprite_get_height(spr) / 2);
		} else {
			sprite_set_offset(spr, arroffs[0], arroffs[1]);
		}
	}
	
	
	LoadBedSleepSprites();
	DebugMes(gArrBedSleepSprites);
	
	
	WriteMyName();
	
	room_goto(rm_bedroom);
}

buttonEnterX = textboxNameX + textboxNameWidth + 96;
buttonEnterY = (textboxNameY + textboxIpPortY + textboxNameHeight) / 2;
buttonEnterWidth = 128;
buttonEnterHeight = abs(textboxNameY - textboxIpPortY) + textboxNameHeight + 2 * 2;
buttonEnter = GuiElement_CreateButton_ext(buttonEnterX, buttonEnterY, "进去睡觉", buttonEnterWidth, buttonEnterHeight
	, , MyEnterToBedRoom
);


buttonAboutLabel = "关于 " + ClientVersion;
buttonAboutWidth = string_width(buttonAboutLabel) + 16;
buttonAboutHeight = 32;
buttonAboutX = GuiWidth() - buttonAboutWidth / 2;
buttonAboutY = buttonAboutHeight / 2;
buttonAbout = GuiElement_CreateButton_ext(buttonAboutX, buttonAboutY, buttonAboutLabel, buttonAboutWidth, buttonAboutHeight
	, , function() {
		show_message("客户端版本号\n" + ClientVersion + "\n--------------------\n" + ClientAbout);
	}
);

MySynchTextBoxsGUI = function() {
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
MySynchTextBoxsGUI();


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
					
					scrollY = 0;
					
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

scrollY = 0;
scrollYSpeed = GUIScrollYSpeed;

attentionText = "";
attentionTextColor = GUIWarningColor;

