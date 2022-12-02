globalvar serverIP, serverPort, socket;
serverIP = "";
serverPort = -1;
socket = undefined;

globalvar PackGuid, PackMainClient, PackMainClientHowToGet, PackArrCompatibleClients, PackIpPort, PackDescription;
PackGuid = "";
PackMainClient = "";
PackMainClientHowToGet = "";
PackArrCompatibleClients = [""];
PackIpPort = "";
PackDescription = "";

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


function SendCommandEasy(_CommandType, _params = undefined) {
	sendMessageQueue.push_back(CommandMakeMessage(_CommandType, _params));
}

function SendName(name = myName) {
	// sendMessageQueue.push_back(StringConverter_UTF8ToMultiByte(CommandMakeMessage(CommandType.name, [name])));
	SendCommandEasy(CommandType.name, [name]);
}

function SendType(type = myType) {
	SendCommandEasy(CommandType.type, [type]);
}

function SendSleep(_bedSleepId) {
	SendCommandEasy(CommandType.sleep, [_bedSleepId]);
}

function SendGetup() {
	SendCommandEasy(CommandType.getup);
}

function SendChat(_chatStr) {
	if(!ChatCommand(_chatStr)) {
		// sendMessageQueue.push_back(StringConverter_UTF8ToMultiByte(CommandMakeMessage(CommandType.chat, [_chatStr])));
		SendCommandEasy(CommandType.chat, [_chatStr]);
	}
}

function SendMove(_x, _y) {
	SendCommandEasy(CommandType.move, [round(_x), round(_y)]);
}

function SendPos(_x, _y) {
	SendCommandEasy(CommandType.pos, [round(_x), round(_y)]);
}

function SendKick(sleeperId) {
	SendCommandEasy(CommandType.kick, [sleeperId]);
}

function SendAgree() {
	SendCommandEasy(CommandType.agree);
}

function SendRefuse() {
	SendCommandEasy(CommandType.refuse);
}

function SendPackGuid() {
	SendCommandEasy(CommandType.packguid);
}

function SendEmote(_emoteId) {
	SendCommandEasy(CommandType.emote, [_emoteId]);
}

function SendReport(_reportContent) {
	SendCommandEasy(CommandType.report, [_reportContent]);
}

function SendPriChat(_destSleeperId, _chatStr) {
	SendCommandEasy(CommandType.prichat, [_destSleeperId, _chatStr]);
}


function ChatCommand(str) {
	var isChatCommand = true;
	
	var args = CutStringToArray(str, " ");
	var argnum = array_length(args);
	DebugMes([argnum, args]);
	
	switch(args[0]) {
		case "/kick":
			if(argnum >= 2) {
				var strTemp = string_digits(args[1]);
				if(strTemp != "") {
					SendKick(real(strTemp));
				}
			}
			break;
			
		case "/report":
			if(argnum >= 2) {
				var strTemp = "";
				for(var i = 1; i < argnum; i++) {
					strTemp += string(args[i]) + " ";
				}
				if(strTemp != "" && string_length(strTemp) != string_count(" ", strTemp)) {
					SendReport(strTemp);
				}
			}
			break;
			
		default:
			isChatCommand = false;
	}
	
	return isChatCommand;
}

