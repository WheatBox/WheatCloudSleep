#macro NULL 0

/* StringConverter.dll */
// https://github.com/JoyLeeSoft/StringConverter
// 我们使用的编译语句：
//		g++ --share .\StringConverter.cpp -o .\StringConverter.dll -std=c++20 -static -DUNICODE

// utf8 *StringConverter_MultiByteToUTF8(const multibyte *str)
function StringConverter_MultiByteToUTF8(str) {
	static dllid = external_define("dll\\StringConverter.dll", "StringConverter_MultiByteToUTF8", dll_cdecl, ty_string, 1, ty_string);
	return external_call(dllid, str);
}

// multibyte *StringConverter_UTF8ToMultiByte(const utf8 *str)
function StringConverter_UTF8ToMultiByte(str) {
	static dllid = external_define("dll\\StringConverter.dll", "StringConverter_UTF8ToMultiByte", dll_cdecl, ty_string, 1, ty_string);
	return external_call(dllid, str);
}



/* file_dll.dll */

/// @desc 获取文件大小，成功返回正数，失败返回-1 
function FileGetSize(file_name) {
	static dllid = external_define("dll\\file_dll.dll", "get_file_size", dll_cdecl, ty_real, 1, ty_string);
	file_name = StringConverter_UTF8ToMultiByte(file_name);
	return external_call(dllid, file_name);
}

/// @desc 读取文件，传入文件名，返回指向文件内容的指针，失败返回NULL，文件最大10M(内置10MB buffer) 
function FileRead(file_name) {
	static dllid = external_define("dll\\file_dll.dll", "read_file", dll_cdecl, ty_string, 1, ty_string);
	file_name = StringConverter_UTF8ToMultiByte(file_name);
	return external_call(dllid, file_name);
}

/// @desc 写文件，传入文件名和文件内容，成功返回0，失败返回其他 
function FileWrite(file_name, file_content) {
	static dllid = external_define("dll\\file_dll.dll", "write_file", dll_cdecl, ty_real, 2, ty_string, ty_string);
	file_name = StringConverter_UTF8ToMultiByte(file_name);
	return external_call(dllid, file_name, file_content);
}

/// @desc 拷贝文件，传入源文件名和目标文件名，成功返回0，失败返回其他 
function FileCopy(src_file_name, dst_file_name) {
	static dllid = external_define("dll\\file_dll.dll", "copy_file", dll_cdecl, ty_real, 2, ty_string, ty_string);
	src_file_name = StringConverter_UTF8ToMultiByte(src_file_name);
	dst_file_name = StringConverter_UTF8ToMultiByte(dst_file_name);
	return external_call(dllid, src_file_name, dst_file_name);
}

/// @desc 移动文件，传入源文件名和目标文件名，成功返回0，失败返回其他 
function FileMove(src_file_name, dst_file_name) {
	static dllid = external_define("dll\\file_dll.dll", "move_file", dll_cdecl, ty_real, 2, ty_string, ty_string);
	src_file_name = StringConverter_UTF8ToMultiByte(src_file_name);
	dst_file_name = StringConverter_UTF8ToMultiByte(dst_file_name);
	return external_call(dllid, src_file_name, dst_file_name);
}

/// @desc 删除文件，传入文件名，成功返回0，失败返回其他 
function FileRemove(file_name) {
	static dllid = external_define("dll\\file_dll.dll", "remove_file", dll_cdecl, ty_real, 1, ty_string);
	file_name = StringConverter_UTF8ToMultiByte(file_name);
	return external_call(dllid, file_name);
}



/* systemCmd.dll */

/// @desc system("");
function systemCmd(str) {
	static dllid = external_define("dll\\systemCmd.dll", "systemCmd", dll_cdecl, ty_real, 1, ty_string);
	static strPrev = "";
	if(strPrev != str) {
		str = StringConverter_UTF8ToMultiByte(str);
		strPrev = str;
	}
	return external_call(dllid, str);
}



/* AudioPlayerDLL.dll */

/// @desc 打开音频，正常播放返回 0，出错返回错误码
function MciOpenAudio(filename, aliasname) {
	static dllid = external_define("dll\\AudioPlayerDLL.dll", "MciOpenAudio", dll_cdecl, ty_real, 2, ty_string, ty_string);
	/* 不写上这段也能正常播放 wav
	var fname = GetNameFromFileName(filename, true);
	if(string_copy(fname, string_length(fname) - 3, 4) == ".wav") {
		aliasname += " type waveaudio";
	}
	*/
	static fnamePrev = "";
	static anamePrev = "";
	if(fnamePrev != filename) {
		filename = StringConverter_UTF8ToMultiByte(filename);
		fnamePrev = filename;
	}
	if(anamePrev != aliasname) {
		aliasname = StringConverter_UTF8ToMultiByte(aliasname);
		anamePrev = aliasname;
	}
	return external_call(dllid, "\"" + filename + "\"", aliasname);
}

/// @desc 播放音频，正常播放返回 0，出错返回错误码
/// @arg filename 可以为文件名(filename)，也可以别名(aliasname)，推荐使用别名
function MciPlayAudio(filename) {
	static dllid = external_define("dll\\AudioPlayerDLL.dll", "MciPlayAudio", dll_cdecl, ty_real, 1, ty_string);
	static fnamePrev = "";
	if(fnamePrev != filename) {
		filename = StringConverter_UTF8ToMultiByte(filename);
		fnamePrev = filename;
	}
	return external_call(dllid, filename);
}

/// @desc 暂停音频，正常暂停返回 0，出错返回错误码
/// @arg filename 可以为文件名(filename)，也可以别名(aliasname)，推荐使用别名
function MciPauseAudio(filename) {
    static dllid = external_define("dll\\AudioPlayerDLL.dll", "MciPauseAudio", dll_cdecl, ty_real, 1, ty_string);
	static fnamePrev = "";
	if(fnamePrev != filename) {
		filename = StringConverter_UTF8ToMultiByte(filename);
		fnamePrev = filename;
	}
	return external_call(dllid, filename);
}

/// @desc 继续播放暂停的音频，正常回复返回 0，出错返回错误码
/// @arg filename 可以为文件名(filename)，也可以别名(aliasname)，推荐使用别名
function MciResumeAudio(filename) {
    static dllid = external_define("dll\\AudioPlayerDLL.dll", "MciResumeAudio", dll_cdecl, ty_real, 1, ty_string);
	static fnamePrev = "";
	if(fnamePrev != filename) {
		filename = StringConverter_UTF8ToMultiByte(filename);
		fnamePrev = filename;
	}
	return external_call(dllid, filename);
}

/// @desc 停止且关闭音频，正常关闭返回 0，出错返回错误码
/// @arg filename 可以为文件名(filename)，也可以别名(aliasname)，推荐使用别名
function MciCloseAudio(filename) {
    static dllid = external_define("dll\\AudioPlayerDLL.dll", "MciCloseAudio", dll_cdecl, ty_real, 1, ty_string);
	static fnamePrev = "";
	if(fnamePrev != filename) {
		filename = StringConverter_UTF8ToMultiByte(filename);
		fnamePrev = filename;
	}
	return external_call(dllid, filename);
}

/// @desc 获取音频状态，出错返回-1
/// @arg filename 可以为文件名(filename)，也可以别名(aliasname)，推荐使用别名
/// @arg status 要获取的状态
function MciGetAudioStatus(filename, status) {
	static dllid = external_define("dll\\AudioPlayerDLL.dll", "MciGetAudioStatus", dll_cdecl, ty_real, 2, ty_string, ty_string);
	static fnamePrev = "";
	if(fnamePrev != filename) {
		filename = StringConverter_UTF8ToMultiByte(filename);
		fnamePrev = filename;
	}
	return external_call(dllid, filename, status);
}


/// @desc 获取音频时长，单位：s，精确到 0.001s，出错返回-1
/// @arg filename 可以为文件名(filename)，也可以别名(aliasname)，推荐使用别名
function MciGetAudioLength(filename) {
    static dllid = external_define("dll\\AudioPlayerDLL.dll", "MciGetAudioLength", dll_cdecl, ty_real, 1, ty_string);
	static fnamePrev = "";
	if(fnamePrev != filename) {
		filename = StringConverter_UTF8ToMultiByte(filename);
		fnamePrev = filename;
	}
	return external_call(dllid, filename);
}

/// @desc 获取音频当前播放进度，单位：s，精确到 0.001s，出错返回-1
/// @arg filename 可以为文件名(filename)，也可以别名(aliasname)，推荐使用别名
function MciGetAudioPosition(filename) {
    static dllid = external_define("dll\\AudioPlayerDLL.dll", "MciGetAudioPosition", dll_cdecl, ty_real, 1, ty_string);
	static fnamePrev = "";
	if(fnamePrev != filename) {
		filename = StringConverter_UTF8ToMultiByte(filename);
		fnamePrev = filename;
	}
	return external_call(dllid, filename);
}

/// @desc 设置音频当前播放进度，单位：s，精确到 0.001s，出错返回错误码
/// @arg filename 可以为文件名(filename)，也可以别名(aliasname)，推荐使用别名
function MciSeekAudioPosition(filename, destPosition) {
	static dllid = external_define("dll\\AudioPlayerDLL.dll", "MciSeekAudioPosition", dll_cdecl, ty_real, 2, ty_string, ty_real);
	static fnamePrev = "";
	if(fnamePrev != filename) {
		filename = StringConverter_UTF8ToMultiByte(filename);
		fnamePrev = filename;
	}
	return external_call(dllid, filename, destPosition);
}

