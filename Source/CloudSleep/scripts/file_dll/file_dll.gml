#macro NULL 0

/* file_dll.dll */

/// @desc 获取文件大小，成功返回正数，失败返回-1 
function FileGetSize(file_name) {
	static dllid = external_define("dll\\file_dll.dll", "get_file_size", dll_cdecl, ty_real, 1, ty_string);
	return external_call(dllid, file_name);
}

/// @desc 读取文件，传入文件名，返回指向文件内容的指针，失败返回NULL，文件最大10M(内置10MB buffer) 
function FileRead(file_name) {
	static dllid = external_define("dll\\file_dll.dll", "read_file", dll_cdecl, ty_string, 1, ty_string);
	return external_call(dllid, file_name);
}

/// @desc 写文件，传入文件名和文件内容，成功返回0，失败返回其他 
function FileWrite(file_name, file_content) {
	static dllid = external_define("dll\\file_dll.dll", "write_file", dll_cdecl, ty_real, 2, ty_string, ty_string);
	return external_call(dllid, file_name, file_content);
}

/// @desc 拷贝文件，传入源文件名和目标文件名，成功返回0，失败返回其他 
function FileCopy(src_file_name, dst_file_name) {
	static dllid = external_define("dll\\file_dll.dll", "copy_file", dll_cdecl, ty_real, 2, ty_string, ty_string);
	return external_call(dllid, src_file_name, dst_file_name);
}

/// @desc 移动文件，传入源文件名和目标文件名，成功返回0，失败返回其他 
function FileMove(src_file_name, dst_file_name) {
	static dllid = external_define("dll\\file_dll.dll", "move_file", dll_cdecl, ty_real, 2, ty_string, ty_string);
	return external_call(dllid, src_file_name, dst_file_name);
}

/// @desc 删除文件，传入文件名，成功返回0，失败返回其他 
function FileRemove(file_name) {
	static dllid = external_define("dll\\file_dll.dll", "remove_file", dll_cdecl, ty_real, 1, ty_string);
	return external_call(dllid, file_name);
}



/* systemCmd.dll */

/// @desc system("");
function systemCmd(str) {
	static dllid = external_define("dll\\systemCmd.dll", "systemCmd", dll_cdecl, ty_real, 1, ty_string);
	return external_call(dllid, str);
}

