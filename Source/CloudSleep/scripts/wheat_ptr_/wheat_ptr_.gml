enum EWheatPtrType {
	Global = 0,
	Struct = 1,
	Ins = 2,
}

/// @desc 小麦指针，不是指针的指针，UwU 有小麦麦在这里帮你指着就不怕找不到了哦喵呜
/// @arg {Real} _EWheatPtrType_Or_wheat_ptr 变量的类型，例如 EWheatPtrType.Global，也可以直接填写一个 wheat_ptr，若这么做，则会跳过后面两个参数
/// @arg {Struct} _varMasterStructOrIns 如果变量类型为 EWheatPtrType.Struct或Ins，此处请填入目标结构体或实例，若为 Global 请跳过
/// @arg {String} _variableName 变量名称（填入一个字符串）
function wheat_ptr(_EWheatPtrType_Or_wheat_ptr = EWheatPtrType.Global, _varMasterStructOrIns = noone, _variableName = "") constructor {
	type = _EWheatPtrType_Or_wheat_ptr;
	varMaster = _varMasterStructOrIns;
	varName = _variableName;
	
	if(is_struct(_EWheatPtrType_Or_wheat_ptr)) {
		type = _EWheatPtrType_Or_wheat_ptr.type;
		varMaster = _EWheatPtrType_Or_wheat_ptr.varMaster;
		varName = _EWheatPtrType_Or_wheat_ptr.varName;
	}
	
	/// @desc 指向目标
	/// @arg {Enum} _EWheatPtrType_Or_wheat_ptr 变量的类型，例如 EWheatPtrType.Global，也可以直接填写一个 wheat_ptr，若这么做，则会跳过后面两个参数
	/// @arg {Struct} _varMasterStructOrIns 如果变量类型为 EWheatPtrType.Struct或Ins，此处请填入目标结构体或实例，若为 Global 请跳过
	/// @arg {String} _variableName 变量名称（填入一个字符串）
	static point = function(_EWheatPtrType_Or_wheat_ptr = EWheatPtrType.Global, _varMasterStructOrIns = noone, _variableName = "") {
		type = _EWheatPtrType_Or_wheat_ptr;
		varMaster = _varMasterStructOrIns;
		varName = _variableName;
		
		if(is_struct(_EWheatPtrType_Or_wheat_ptr)) {
			type = _EWheatPtrType_Or_wheat_ptr.type;
			varMaster = _EWheatPtrType_Or_wheat_ptr.varMaster;
			varName = _EWheatPtrType_Or_wheat_ptr.varName;
		}
	}
	
	/// @desc 获取值，若获取失败会返回 undefined
	static value = function() {
		switch(type) {
			case EWheatPtrType.Global:
				if(variable_global_exists(varName)) {
					return variable_global_get(varName);
				}
				break;
				
			case EWheatPtrType.Struct:
				if(is_struct(varMaster))
				if(variable_struct_exists(varMaster, varName)) {
					return variable_struct_get(varMaster, varName);
				}
				break;
				
			case EWheatPtrType.Ins:
				if(instance_exists(varMaster))
				if(variable_instance_exists(varMaster, varName)) {
					return variable_instance_get(varMaster, varName);
				}
				break;
		}
		
		return undefined;
	}
	
	/// @desc 设定值到指向的变量，成功返回 true，失败返回 false
	static set = function(val) {
		if(varName == "") {
			return false;
		}
		switch(type) {
			case EWheatPtrType.Global:
				variable_global_set(varName, val);
				return true;
				
			case EWheatPtrType.Struct:
				if(is_struct(varMaster)) {
					variable_struct_set(varMaster, varName, val);
					return true;
				}
				break;
				
			case EWheatPtrType.Ins:
				if(instance_exists(varMaster)) {
					variable_instance_set(varMaster, varName, val);
					return true;
				}
				break;
		}
		
		return false;
	}
	
	/// @desc 返回该 wheat_ptr 所指向的目标相关的数据，返回结果也是一个结构体，但是并非用 new 创建，所以不需要手动释放内存
	static get = function() {
		var _res = {};
		
		_res.type = type;
		_res.varMaster = varMaster;
		_res.varName = varName;
		
		_res.point = point;
		_res.value = value;
		_res.set = set;
		_res.get = get;
		_res.swap = swap;
		
		return _res;
	}
	
	/// @desc 互换两个 wheat_ptr 所指向的目标（不会对被指向的变量的值产生影响），成功返回 true，失败返回 false
	static swap = function(_wheat_ptr) {
		if(is_struct(_wheat_ptr)) {
			var _temp = [ type, varMaster, varName ];
			
			type = _wheat_ptr.type;
			varMaster = _wheat_ptr.varMaster;
			varName = _wheat_ptr.varName;
			
			_wheat_ptr.type = _temp[0];
			_wheat_ptr.varMaster = _temp[1];
			_wheat_ptr.varName = _temp[2];
			
			return true;
		}
		
		return false;
	}
}

/// @desc 小麦指针，不是指针的指针，UwU 有小麦麦在这里帮你指着就不怕找不到了哦喵呜，使用该函数创建的 wheat_ptr 不需要手动 delete 来释放内存呢~
/// @arg {Real} _EWheatPtrType_Or_wheat_ptr 变量的类型，例如 EWheatPtrType.Global，也可以直接填写一个 wheat_ptr，若这么做，则会跳过后面两个参数
/// @arg {Struct} _varMasterStructOrIns 如果变量类型为 EWheatPtrType.Struct或Ins，此处请填入目标结构体或实例，若为 Global 请跳过
/// @arg {String} _variableName 变量名称（填入一个字符串）
function make_wheat_ptr(_EWheatPtrType_Or_wheat_ptr = EWheatPtrType.Global, _varMasterStructOrIns = noone, _variableName = "") {
	var _temp = new wheat_ptr(_EWheatPtrType_Or_wheat_ptr, _varMasterStructOrIns, _variableName);
	var _res = _temp.get();
	delete _temp;
	return _res;
}
