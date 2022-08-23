globalvar serverIP, serverPort, socket;
serverIP = "";
serverPort = -1;
socket = undefined;

globalvar sendMessageQueue;
sendMessageQueue = new vector();

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
	
	file_text_close(file);
	
	return result;
}

function SendMessage(str) {
	var strSize = string_byte_length(str) + 1;
	
	var buf = buffer_create(strSize, buffer_fixed, 1);
	buffer_write(buf, buffer_string, str);
	
	network_send_raw(socket, buf, strSize);
	
	buffer_delete(buf);
}

function SendName(name = myName) {
	sendMessageQueue.push_back(CommandMakeMessage(CommandType.name, name));
}

function SendType(type = myType) {
	sendMessageQueue.push_back(CommandMakeMessage(CommandType.type, [type]));
}

function SendSleep(_bedSleepId) {
	sendMessageQueue.push_back(CommandMakeMessage(CommandType.sleep, [_bedSleepId]));
}

function SendGetup() {
	sendMessageQueue.push_back(CommandMakeMessage(CommandType.getup));
}

function SendChat(_chatStr) {
	sendMessageQueue.push_back(CommandMakeMessage(CommandType.chat, _chatStr));
}

function SendMove(_x, _y) {
	sendMessageQueue.push_back(CommandMakeMessage(CommandType.move, [round(_x), round(_y)]));
}

function SendPos(_x, _y) {
	sendMessageQueue.push_back(CommandMakeMessage(CommandType.pos, [round(_x), round(_y)]));
}

