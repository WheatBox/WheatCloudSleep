packagesPage.height = GuiHeight();
MySynchTextBoxsGUI();

if(PackName != packNamePrevious) {
	var _canUpdatePackNamePrev = true;
	
	var _structTemp = EditCloudPack_Head()[1];
	try {
		PackGuid = _structTemp.guid;
		PackMainClient = _structTemp.mainclient;
		PackMainClientHowToGet = _structTemp.mainclient_howtoget;
		
		var _cli = _structTemp.compatibleclients;
		var _arrcli = [];
		var _cutPos = 1;
		var _cutRes = string_pos_ext("$$", _cli, _cutPos);
		while(_cutRes != 0) {
			array_push(_arrcli, string_copy(_cli, _cutPos, _cutRes - _cutPos));
			_cutPos = _cutRes + 2;
			_cutRes = string_pos_ext("$$", _cli, _cutPos);
		}
		array_push(_arrcli, string_copy(_cli, _cutPos, string_length(_cli) - _cutPos + 1));
		
		PackArrCompatibleClients = _arrcli;
		
		PackIpPort = _structTemp.ipport;
		
		DebugMes(PackGuid);
		DebugMes(PackMainClient);
		DebugMes(PackMainClientHowToGet);
		DebugMes(PackArrCompatibleClients);
		DebugMes(PackIpPort);
		
	} catch(error) {
		PackName = packNamePrevious;
		_canUpdatePackNamePrev = false;
		show_message("无法正确打开场景包");
	}
	
	if(_canUpdatePackNamePrev) {
		myEnterLock = false;
		
		attentionText = "";
		if(ClientVersion != PackMainClient) {
			attentionText = PackMainClientHowToGet;
			
			var _isCompatible = false;
			for(var iTemp = 0; iTemp < array_length(PackArrCompatibleClients); iTemp++) {
				if(ClientVersion == PackArrCompatibleClients[iTemp]) {
					_isCompatible = true;
					break;
				}
			}
			
			if(_isCompatible) {
				attentionText = "当前客户端版本与场景包兼容，但可能会有错误\n通过以下方式获得最合适于该场景包的客户端：\n" + attentionText;
				attentionTextColor = GUIWarningColor;
			} else {
				attentionText = "当前客户端版本与场景包不兼容\n通过以下方式获得最合适于该场景包的客户端：\n" + attentionText;
				attentionTextColor = GUIDangerousColor;
				
				myEnterLock = true;
			}
		}
		
		
		myType = -1;
		
		packNamePrevious = PackName;
		TextboxSetText(textboxIpPort, PackIpPort);
		
		// 删除上一个读取的场景包的读取的睡客结构
		if(CheckStructCanBeUse(gSleepersSpritesStruct))
		if(variable_struct_exists(gSleepersSpritesStruct, "sprites"))
		if(is_array(gSleepersSpritesStruct.sprites)) {
			for(var ispr = 0; ispr < array_length(gSleepersSpritesStruct.sprites); ispr++) {
				sprite_delete(gSleepersSpritesStruct.sprites[ispr]);
			}
			array_delete(gSleepersSpritesStruct.sprites, 0, array_length(gSleepersSpritesStruct.sprites));
			array_delete(gSleepersStruct.materials, 0, array_length(gSleepersStruct.materials));
		}
		
		if(CheckStructCanBeUse(gSceneStruct))
		if(variable_struct_exists(gSceneStruct, "sleepers"))
		if(is_array(gSceneStruct.sleepers))
		array_delete(gSceneStruct.sleepers, 0, array_length(gSceneStruct.sleepers));
		
		// LoadCloudPack_ChildFunc_LoadSprites(WORKFILEPATH + FILEPATH_sleepers, WORKFILEPATH + FILEJSON_sleepers, gSleepersSpritesStruct, "gSleepersStruct", gSceneStruct.sleepers);
		LoadCloudPack(true, false);
	}
}

if(keyboard_check_pressed(vk_enter)) {
	MyEnterToBedRoom();
}

