function GuiElement_CreateImportSleeperButton(_xGui, _yGui, _label, _width = undefined, _height = undefined) {
	return GuiElement_CreateImportButton("睡客"
		, WORKFILEPATH + FILEPATH_sleepers
		, WORKFILEPATH + FILEJSON_sleepers
		, gSleepersStruct
		, gSleepersSpritesStruct
		, "gSleepersStruct"
		, SSingleStruct_Sleeper
		, _xGui, _yGui, _label, _width, _height
	);
}

function GuiElement_CreateImportBackgroundButton(_xGui, _yGui, _label, _width = undefined, _height = undefined) {
	return GuiElement_CreateImportButton("背景"
		, WORKFILEPATH + FILEPATH_backgrounds
		, WORKFILEPATH + FILEJSON_backgrounds
		, gBackgroundsStruct
		, gBackgroundsSpritesStruct
		, "gBackgroundsStruct"
		, SSingleStruct_Background
		, _xGui, _yGui, _label, _width, _height
	);
}

function GuiElement_CreateImportDecorateButton(_xGui, _yGui, _label, _width = undefined, _height = undefined) {
	return GuiElement_CreateImportButton("不可互动物体"
		, WORKFILEPATH + FILEPATH_decorates
		, WORKFILEPATH + FILEJSON_decorates
		, gDecoratesStruct
		, gDecoratesSpritesStruct
		, "gDecoratesStruct"
		, SSingleStruct_Decorate
		, _xGui, _yGui, _label, _width, _height
	);
}

function GuiElement_CreateImportBedButton(_xGui, _yGui, _label, _width = undefined, _height = undefined) {
	return GuiElement_CreateImportButton("床"
		, WORKFILEPATH + FILEPATH_beds
		, WORKFILEPATH + FILEJSON_beds
		, gBedsStruct
		, gBedsSpritesStruct
		, "gBedsStruct"
		, SSingleStruct_Bed
		, _xGui, _yGui, _label, _width, _height
	);
}

function GuiElement_CreateImportButton(explorerCaption, filePath, fileJson, gStruct, gSpriteStruct, gStructStr, structgStructMaterialsPush, _xGui, _yGui, _label, _width = undefined, _height = undefined) {
	var ins = GuiElement_CreateButton_ext(_xGui, _yGui, _label, _width, _height,
		[explorerCaption, filePath, fileJson, gStruct, gSpriteStruct, gStructStr, structgStructMaterialsPush],
		function(args) {
			var __ExplorerCaption = args[0];
			var __FilePath = args[1];
			var __FileJson = args[2];
			var __gStruct = args[3];
			var __gSpriteStruct = args[4];
			var __gStructStr = args[5];
			var __structgStructMaterialsPush = args[6];
			
			var filename = FileNameGetPicture(__ExplorerCaption);
			if(filename != "") {
				var _name = GetNameFromFileName(filename, true);
				
				var _conflicted = false;
				// 检查是否重复了
				for(var i = 0; i < array_length(__gStruct.materials); i++) {
					if(__gStruct.materials[i].filename == _name) {
						_conflicted = true;
						show_message("导入的图片与已有的图片名称冲突！");
						break;
					}
				}
				
				if(_conflicted == false) {
					
					// 复制文件
					var _copyRes = FileCopy(filename, __FilePath + _name);
					DebugMes([filename, " copy to ", __FilePath + _name]);
					
					if(_copyRes != 0) {
						show_message("文件复制失败！\n请确认文件目录或文件名中没有使用中文");
						return;
					}
					
					var _jsonName = __FileJson;
					
					// 写入
					if(_jsonName != "") {
						array_push(__gStruct.materials, new __structgStructMaterialsPush(_name));
						var _jsonDest = json_stringify(__gStruct);
						FileWrite(_jsonName, _jsonDest);
					}
					
					// 读取
					/*
					if(FileGetSize(_jsonName) > 0) {
						var _jsonStr = FileRead(_jsonName);
						variable_global_set(__gStructStr, json_parse(_jsonStr));
					} else {
						variable_global_set(__gStructStr, DefaultStruct);
					}*/
				
					// 将图片转换为 spr 并刷新（添加 DragObj）
					if(object_index == obj_sandboxSceneElementsPages) {
						var _sprTemp = sprite_add(__FilePath + _name, 1, false, true, 0, 0);
						sprite_set_offset(_sprTemp, sprite_get_width(_sprTemp) / 2, sprite_get_height(_sprTemp) / 2);
						sprite_set_bbox_mode(_sprTemp, DragObjBboxMode);
						array_push(__gSpriteStruct.sprites, _sprTemp);
						
						// 设定 offset
						if(variable_struct_exists(__gStruct.materials[i], "offset")) {
							__gStruct.materials[i].offset = [sprite_get_width(_sprTemp) / 2, sprite_get_height(_sprTemp) / 2];
						}
					
						MyRefreshPage();
					}
				}
			}
		}
	);
	
	return ins;
}


/// @arg _xGui x
/// @arg _yGui y
/// @arg _label _labelText
/// @arg _pressedFunc 按下后触发的函数
/// @arg _disposable 是否为一次性的（鼠标左键或右键单击后会删除实例（不管有没有点到按钮本身））
function GuiElement_CreateButton(_xGui, _yGui, _label, _pressedFunc, _disposable = false, _color = GUIDefaultColor) {
	return GuiElement_CreateButton_ext(_xGui, _yGui, _label, , , , _pressedFunc, _disposable, _color);
}

/// @arg _xGui x
/// @arg _yGui y
/// @arg _label _labelText
/// @arg _width 宽
/// @arg _height 高
/// @arg _pressedFuncArgs 按下后触发的函数
/// @arg _pressedFunc 按下后触发的函数的参数
/// @arg _disposable 是否为一次性的（鼠标左键或右键单击后会删除实例（不管有没有点到按钮本身））
function GuiElement_CreateButton_ext(_xGui, _yGui, _label, _width = undefined, _height = undefined, _pressedFuncArgs = undefined, _pressedFunc, _disposable = false, _color = GUIDefaultColor) {
	var ins = instance_create_depth(_xGui, _yGui,
		GUIDepth, obj_GuiElement_Button);
	ins.labelText = _label;
	ins.width = _width;
	ins.height = _height;
	ins.MyPressedFunction = _pressedFunc;
	ins.MyPressedFunctionArgs = _pressedFuncArgs;
	ins.Disposable = _disposable;
	ins.color = _color;
	
	if(_width == undefined) {
		ins.width = GUI_GetStringWidth(_label) + 8;
	}
	if(_height == undefined) {
		ins.height = GUI_GetStringHeight(_label) + 2;
	}
	
	return ins;
}

function GuiElement_CreatePage(_xGui, _yGui, _label, _width = undefined, _height = undefined) {
	var ins = instance_create_depth(_xGui, _yGui,
		GUIPageDepth, obj_GuiElement_Page);
	ins.labelText = _label;
	if(_width != undefined) {
		ins.width = _width;
	}
	if(_height != undefined) {
		ins.height = _height
	} else {
		ins.height = display_get_gui_height() - _yGui;
	}
	
	return ins;
}

function GuiElement_CreateDragObj(_xGui, _yGui, _materialId, _sprite, _filename, _ESandboxSceneElementsLayer, _masterPage, _MaxWorH = 224) {
	var ins = noone;
	
	switch(_ESandboxSceneElementsLayer) {
		case ESandboxSceneElementsLayers.sleepers:
		case ESandboxSceneElementsLayers.backgrounds:
		case ESandboxSceneElementsLayers.decorates:
		case ESandboxSceneElementsLayers.beds:
			ins = instance_create_depth(_xGui, _yGui, GUIDragObjDepth, obj_GuiElement_DragObj);
			break;
	}
	
	ins.materialId = _materialId;
	ins.sprite_index = _sprite;
	
	if(ins.sprite_width > ins.sprite_height) {
		SetSizeLockAspect_Width(_MaxWorH, ins);
	} else {
		SetSizeLockAspect_Height(_MaxWorH, ins);
	}
	
	ins.width = ins.sprite_width;
	ins.height = ins.sprite_height;
	
	ins.myFilename = _filename;
	ins.masterPage = _masterPage;
	ins.mySandboxSceneElementsLayer = _ESandboxSceneElementsLayer;
	
	return ins;
}

function GuiElement_CreateOffsetSetter(_materialMasterArr, _materialId, _sprite) {
	var ins = instance_create_depth(0, 0, GUIDepth, obj_GuiElement_OffsetSetter);
	ins.materialMasterArr = _materialMasterArr;
	ins.materialId = _materialId;
	ins.sprite = _sprite;
	
	return ins;
}

function GuiElement_CreateHitboxSetter(_materialMasterArr, _materialId, _sprite) {
	var ins = instance_create_depth(0, 0, GUIDepth, obj_GuiElement_HitboxSetter);
	ins.materialMasterArr = _materialMasterArr;
	ins.materialId = _materialId;
	ins.sprite = _sprite;
	
	return ins;
}

function GuiElement_CreateBedSleepSetter(_materialMasterArr, _materialId, _sprite) {
	var ins = instance_create_depth(0, 0, GUIDepth, obj_GuiElement_BedSleepSetter);
	ins.materialMasterArr = _materialMasterArr;
	ins.materialId = _materialId;
	ins.sprite = _sprite;
	
	return ins;
}

