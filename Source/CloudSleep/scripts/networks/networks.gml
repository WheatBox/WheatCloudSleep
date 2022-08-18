globalvar serverIP, serverPort, socket;
serverIP = "";
serverPort = -1;
socket = undefined;

/// @desc 从文件中读取IP地址
///			返回一个数组，内含2个 字符串，[0] = IP，[1] = Port
///			如果无法打开文件或读取失败，则返回 -1
/// @returns {Array<String>}
function ReadAddress(filename) {
	var file = file_text_open_read(filename);
	if(file == -1) {
		show_debug_message("ReadAddress(" + filename + "): Can not find the file!");
		return -1;
	}
	
	var result = [undefined, undefined];
	
	var srcString = file_text_read_string(file);
	var left = 0, right = 0, c = "";
	do {
		c = string_char_at(srcString, right);
		if(c == ":") {
			result[0] = string_copy(srcString, left, right - 1 - left);
			
			right++;
			left = right;
			
			continue;
		}
		
		right++;
	} while_(c != "");
	
	if(result[0] == undefined) {
		show_debug_message("ReadAddress(" + filename + "): result[0] = undefined!");
		return -1;
	}
	
	result[1] = string_copy(srcString, left, right - left);
	
	return result;
}

