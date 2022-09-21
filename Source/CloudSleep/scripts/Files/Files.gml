#macro FILEPATH_sleepers "\\contents\\sleepers\\"
#macro FILEPATH_backgrounds "\\contents\\backgrounds\\"
#macro FILEPATH_decorates "\\contents\\decorates\\"
#macro FILEPATH_beds "\\contents\\beds\\"

#macro FILEPATH_beds_bedsleep "\\contents\\beds\\bedsleep\\"

#macro FILEJSON_sleepers "\\contents\\sleepers.json"
#macro FILEJSON_backgrounds "\\contents\\backgrounds.json"
#macro FILEJSON_decorates "\\contents\\decorates.json"
#macro FILEJSON_beds "\\contents\\beds.json"

#macro FILEJSON_scene "\\contents\\scene.json"

#macro FILEJSON_TextboxPlaceHolders "\\contents\\TextboxPlaceHolders.json"

//#macro PACKAGESFILEPATH ".\\packages\\"
 #macro PACKAGESFILEPATH "F:\\packages\\"
#macro WORKFILEPATH_default PACKAGESFILEPATH + PackName + "\\"

// #macro WORKFILEPATH ".\\packages\\" + PackName + "\\"
// #macro WORKFILEPATH "F:\\CSETemp\\packages\\" + PackName + "\\"
globalvar WORKFILEPATH;
WORKFILEPATH = working_directory; // 随便填个目录先占着位置

#macro PackFileExtension ".cloudpack"


globalvar PackName;
PackName = "";

function SSingleStruct_Sleeper(_fname = "") constructor {
	filename = _fname;
	offset = [];
};
function SSingleStruct_Background(_fname = "") constructor {
	filename = _fname;
};
function SSingleStruct_Decorate(_fname = "") constructor {
	filename = _fname;
	hitbox = [];
	offset = [];
};
function SSingleStruct_Bed(_fname = "") constructor {
	filename = _fname;
	hitbox = [];
	offset = [];
	sleepfilenames = [];
};

#macro DefaultStructSleepers { materials : [] }
#macro DefaultStructBackgrounds { materials : [] }
#macro DefaultStructDecorates { materials : [] }
#macro DefaultStructBeds { materials : [] }

#macro DefaultSpritesStruct { sprites : [] }

#macro DefaultSceneStruct {\
	left : 0,\
	top : 0,\
	right : 100,\
	bottom : 80,\
	\
	\// 这几个数组内存储的都会是 new SSceneElement()
	sleepers : [],\
	backgrounds : [],\
	decorates : [],\
	beds : []\
}

globalvar gSleepersStruct, gBackgroundsStruct, gDecoratesStruct, gBedsStruct;
gSleepersStruct = DefaultStructSleepers;
gBackgroundsStruct = DefaultStructBackgrounds;
gDecoratesStruct = DefaultStructDecorates;
gBedsStruct = DefaultStructBeds;

globalvar gSleepersSpritesStruct, gBackgroundsSpritesStruct, gDecoratesSpritesStruct, gBedsSpritesStruct;
gSleepersSpritesStruct = DefaultSpritesStruct;
gBackgroundsSpritesStruct = DefaultSpritesStruct;
gDecoratesSpritesStruct = DefaultSpritesStruct;
gBedsSpritesStruct = DefaultSpritesStruct;

// 例如 gBedSleepSpritesStruct[bed's materialId][sleeper's materialId (睡客皮肤 type)] = sprite_add(...);
globalvar gArrBedSleepSprites;
gArrBedSleepSprites = [{}];

// Struct Scene Element
function SSceneElement(_materialId, _xPos, _yPos) constructor {
	materialId = _materialId;
	xPos = _xPos;
	yPos = _yPos;
}

globalvar gSceneStruct;
gSceneStruct = DefaultSceneStruct;

/// @desc 由文件目录获取文件名称
///			第二个参数是是否要返回后缀
function GetNameFromFileName(filename, withExtension = true) {
	var res = filename;
	
	var dotPos = string_length(filename);
	var dotGot = false;
	
	if(withExtension) {
		dotGot = true;
	}
	
	for(var i = string_length(filename); i >= 0; i--) {
		if(string_char_at(filename, i) == "." && dotGot == false) {
			dotPos = i - 1;
			dotGot = true;
		}
		if(string_char_at(filename, i) == "\\" || string_char_at(filename, i) == "/") {
			res = string_copy(filename, i + 1, dotPos - i);
			return res;
		}
	}
	
	return res;
}

function FileNameGetPicture(_caption_ImportToWhere = "") {
	return get_open_filename_ext("图片(*.png, *.jpg, *.jpeg)|*.png;*.jpg;*.jpeg", "", working_directory, "导入图片" + ((_caption_ImportToWhere != "") ? (" 到 " + _caption_ImportToWhere) : ""));
}


function LoadCloudPack_ChildFunc_LoadSprites(filePath, fileJson, _gSpriteStruct, _gStructStr, _gSceneStructArr) {
	var _changed = false;
	
	var fstr = NULL;
	
	if(FileGetSize(fileJson) > 0) {
		fstr = FileRead(fileJson);
	}
	
	if(fstr != NULL) {
		// variable_global_set(_gStructStr, json_parse(fstr));
			
		var _gStruct = variable_global_get(_gStructStr);
			
		var _jsonCopyTemp = json_parse(fstr);
		if(variable_struct_exists(_jsonCopyTemp, "materials")) {
			var _jsonCopyTempMaterialsLen = array_length(_jsonCopyTemp.materials);
			for(var iJson = 0; iJson < _jsonCopyTempMaterialsLen; iJson++) {
				if(CheckStructCanBeUse(_jsonCopyTemp.materials[iJson]) == false) {
					continue;
				}
					
				_gStruct.materials[iJson] = _jsonCopyTemp.materials[iJson];
				/*
				if(variable_struct_exists(_jsonCopyTemp.materials[iJson], "filename")) {
					_gStruct.materials[iJson].filename = _jsonCopyTemp.materials[iJson].filename;
				}
				if(variable_struct_exists(_jsonCopyTemp.materials[iJson], "hitbox")) {
					_gStruct.materials[iJson].hitbox = _jsonCopyTemp.materials[iJson].hitbox;
				}
				if(variable_struct_exists(_jsonCopyTemp.materials[iJson], "offset")) {
					_gStruct.materials[iJson].offset = _jsonCopyTemp.materials[iJson].offset;
				}*/
			}
		}
			
		
		_changed = false;
		
		for(var i = 0; i < array_length(_gStruct.materials); i++) {
			var _name = _gStruct.materials[i].filename;
			
			if(FileGetSize(filePath + _name) <= 0) {
				// 删除失效文件名
				array_delete(_gStruct.materials, i, 1);
				_changed = true;
				
				// 删除失效文件名的场景物体（此时这些场景物体暂时还没有被放置
				for(var j = 0; j < array_length(_gSceneStructArr); j++) {
					if(!CheckStructCanBeUse(_gSceneStructArr[j])) {
						continue;
					}
					if(_gSceneStructArr[j].materialId == i) {
						array_delete(_gSceneStructArr, j, 1);
					}
				}
				
				// SceneElement_BackgroundsAlignAfterDelete(i, 1);
				
				i--;
				continue;
			}
			
			var _sprTemp = sprite_add(filePath + _name, 1, false, true, 0, 0);
			// 此处的 offset 和 bbox 都只是编辑器内为了拖拽而设定的，实际游戏内的值以 _gStruct 结构体内的值为准
			sprite_set_offset(_sprTemp, sprite_get_width(_sprTemp) / 2, sprite_get_height(_sprTemp) / 2);
			// sprite_set_bbox_mode(_sprTemp, DragObjBboxMode);
			sprite_set_bbox_mode(_sprTemp, bboxmode_manual);
			array_push(_gSpriteStruct.sprites, _sprTemp);
				
				
			// 修复 offset
			if(variable_struct_exists(_gStruct.materials[i], "offset")) {
				if(array_length(_gStruct.materials[i].offset) < 2) {
					_gStruct.materials[i].offset = [sprite_get_width(_sprTemp) / 2, sprite_get_height(_sprTemp) / 2];
				}
			}
		}
		
		// 如果有删除过失效文件名，进行重新写入json
		if(_changed) {
			var _changedjson = json_stringify(_gStruct);
			FileWrite(fileJson, _changedjson);
		}
	}
}

function LoadCloudPack(_loadSleepers, _loadOthers) {
	var ChildFunc_LoadSprites = LoadCloudPack_ChildFunc_LoadSprites;
	
	var fscene = NULL;
	
	if(FileGetSize(WORKFILEPATH + FILEJSON_scene) > 0) {
		fscene = FileRead(WORKFILEPATH + FILEJSON_scene);
	}
	
	if(fscene != NULL) {
		gSceneStruct = json_parse(fscene);
		
		gSceneStruct[$ "sleepers"] ??= [];
		gSceneStruct[$ "backgrounds"] ??= [];
		gSceneStruct[$ "decorates"] ??= [];
		gSceneStruct[$ "beds"] ??= [];
	}
	
	
	if(_loadSleepers) {
		ChildFunc_LoadSprites(WORKFILEPATH + FILEPATH_sleepers, WORKFILEPATH + FILEJSON_sleepers, gSleepersSpritesStruct, "gSleepersStruct", gSceneStruct.sleepers);
	}
	if(_loadOthers) {
		ChildFunc_LoadSprites(WORKFILEPATH + FILEPATH_backgrounds, WORKFILEPATH + FILEJSON_backgrounds, gBackgroundsSpritesStruct, "gBackgroundsStruct", gSceneStruct.backgrounds);
		ChildFunc_LoadSprites(WORKFILEPATH + FILEPATH_decorates, WORKFILEPATH + FILEJSON_decorates, gDecoratesSpritesStruct, "gDecoratesStruct", gSceneStruct.decorates);
		ChildFunc_LoadSprites(WORKFILEPATH + FILEPATH_beds, WORKFILEPATH + FILEJSON_beds, gBedsSpritesStruct, "gBedsStruct", gSceneStruct.beds);
	}



	if(1) {
		var _changedjson = json_stringify(gSceneStruct);
		FileWrite(WORKFILEPATH + FILEJSON_scene, _changedjson);
	}
	
	DebugMes([gSleepersStruct, gSleepersSpritesStruct, gSceneStruct.sleepers]);
	DebugMes([gBackgroundsStruct, gBackgroundsSpritesStruct, gSceneStruct.backgrounds]);
	DebugMes([gDecoratesStruct, gDecoratesSpritesStruct, gSceneStruct.decorates]);
	DebugMes([gBedsStruct, gBedsSpritesStruct, gSceneStruct.beds]);
}

function SaveCloudPack() {
	var ChildFunc_Save = function(fileJson, _gStruct, _gSpriteStruct, _gSceneStructArr, _obj_SceneElement) {
		for(var i = 0; i < array_length(_gSceneStructArr); i++) {
			if(CheckStructCanBeUse(_gSceneStructArr[i]) == false) {
				continue;
			}
			delete _gSceneStructArr[i];
		}
		array_delete(_gSceneStructArr, 0, array_length(_gSceneStructArr));
		
		
		for(var i = 0; i < instance_count; i++) {
			if(instance_id[i].object_index == _obj_SceneElement) {
				if(instance_id[i].materialId >= 0 && instance_id[i].materialId < array_length(_gSpriteStruct.sprites)) {
					array_push(_gSceneStructArr, new SSceneElement(instance_id[i].materialId, instance_id[i].x, instance_id[i].y));
				}
			}
		}
		
		
		var _jsonStr = json_stringify(_gStruct);
		var _jsonSceneFileWriteRes = FileWrite(fileJson, _jsonStr);
		if(_jsonSceneFileWriteRes != 0) {
			show_message(string(fileJson) + "保存失败！" + string(_jsonSceneFileWriteRes));
		}
	}
	
	
	ChildFunc_Save(WORKFILEPATH + FILEJSON_sleepers, gSleepersStruct, gSleepersSpritesStruct, gSceneStruct.sleepers, obj_SceneElementSleeper);
	ChildFunc_Save(WORKFILEPATH + FILEJSON_backgrounds, gBackgroundsStruct, gBackgroundsSpritesStruct, gSceneStruct.backgrounds, obj_SceneElementBackground);
	ChildFunc_Save(WORKFILEPATH + FILEJSON_decorates, gDecoratesStruct, gDecoratesSpritesStruct, gSceneStruct.decorates, obj_SceneElementDecorate);
	ChildFunc_Save(WORKFILEPATH + FILEJSON_beds, gBedsStruct, gBedsSpritesStruct, gSceneStruct.beds, obj_SceneElementBed);
	
	
	var _jsonStr = json_stringify(gSceneStruct);
	var _jsonSceneFileWriteRes = FileWrite(WORKFILEPATH + FILEJSON_scene, _jsonStr);
	if(_jsonSceneFileWriteRes != 0) {
		show_message(WORKFILEPATH + FILEJSON_scene + "保存失败！" + string(_jsonSceneFileWriteRes));
	}
}



/*
{
	"guid":"{xxxxxxxxx}",
	"mainclient":"xxxxxxxx",
	"mainclient_howtoget":"xxxxxxxx",
	"compatibleclients":"xxxxxx$$xxxxxx$$xxxx",
	"ipport":"xxx.xxx.xxx.xxx:xxxxx"
}
*/

/// @desc 返回 [packfname, _structTemp]
function EditCloudPack_Head() {
	var packfname = WORKFILEPATH + PackName + ".cloudpack";
	var fReadRes = FileRead(packfname);
	if(fReadRes == NULL) {
		show_message("读取 " + string(packfname) + " 失败！");
		return NULL;
	}
	
	var _structTemp = {};
	try {
		_structTemp = json_parse(fReadRes);
	} catch(error) {
		_structTemp = {};
	}
	
	return [packfname, _structTemp];
}



/// @desc 从字符串切割出IP和端口，返回 [ip(string), port(real)]
function CutIpPort(_ipport) {
	var _ipTemp; // = "";
	var _portTemp; // = -1;
	var _cutRes = string_pos_ext(":", _ipport, 1);
	if(_cutRes == 0) _cutRes = string_pos_ext("：", _ipport, 1);
	
	if(_cutRes != 0) {
		_ipTemp = string_copy(_ipport, 1, _cutRes - 1);
		_portTemp = real(string_copy(_ipport, _cutRes + 1, string_length(_ipport) - _cutRes + 1));
	}
	
	return [_ipTemp, _portTemp];
}



function LoadBedSleepSprites() {
	gArrBedSleepSprites ??= [{}];
	
	var materialsSiz = array_length(gBedsStruct.materials);
	for(var i = 0; i < materialsSiz; i++) { // i = materialId
		if(array_length(gArrBedSleepSprites) < i + 1) {
			gArrBedSleepSprites[i] = undefined;
		}
		gArrBedSleepSprites[i] ??= {};
		
		var sleepfilenamesSiz = array_length(gBedsStruct.materials[i].sleepfilenames);
		for(var j = 0; j < sleepfilenamesSiz; j++) {
			if(gBedsStruct.materials[i].sleepfilenames[j] == 0) {
				gArrBedSleepSprites[i][j] = -1;
				continue;
			}
			
			var _fname = gBedsStruct.materials[i].filename + "\\" + gBedsStruct.materials[i].sleepfilenames[j];
			
			var _spr = sprite_add(WORKFILEPATH + FILEPATH_beds_bedsleep + _fname, 1, false, true, 0, 0);
			
			var _xoffTemp = sprite_get_width(_spr) / 2;
			var _yoffTemp = sprite_get_height(_spr) / 2;
			if(variable_instance_exists(gBedsStruct.materials[i], "offset") == true)
			if(is_array(gBedsStruct.materials[i].offset) == true)
			if(array_length(gBedsStruct.materials[i].offset) >= 2) {
				_xoffTemp = gBedsStruct.materials[i].offset[0];
				_yoffTemp = gBedsStruct.materials[i].offset[1];
			}
			sprite_set_offset(_spr, _xoffTemp, _yoffTemp);
			
			gArrBedSleepSprites[i][j] = _spr;
		}
	}
}

