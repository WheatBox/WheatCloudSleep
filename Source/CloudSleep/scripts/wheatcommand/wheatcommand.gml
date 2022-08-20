enum CommandType {
	unknown,
	
	name,
	type,
	
	sleep,
	getup,
	
	chat,
	
	move,
	pos,
};

function GetCommandTypeFromString(buf) {
	switch(buf) {
		case "name":
			return CommandType.name;
		case "type":
			return CommandType.type;
			
		case "sleep":
			return CommandType.sleep;
		case "getup":
			return CommandType.getup;
			
		case "chat":
			return CommandType.chat;
			
		case "move":
			return CommandType.move;
		case "pos":
			return CommandType.pos;
	}
	
	return CommandType.unknown;
}

/// 返回一个数组，[0] = CommandType，[1] = params（可能为字符串，数字，数组）
function CommandParse(buf) {
	var result = [undefined, undefined];
	
	/* 获取 result[0]，CommandTypes部分 */
	
	for(var i = 0; i < string_length(buf); i++) {
		if(string_char_at(buf, i) == "$") {
			result[0] = GetCommandTypeFromString(string_copy(buf, 0, i - 1));
			break;
		}
	}
	
	// 没找到分隔符号，自动设为 unknown
	if(i >= string_length(buf)) {
		result[0] = CommandType.unknown;
		
		return result;
	}
	
	/* 获取 result[1]，params部分 */
	
	var strTemp = string_copy(buf, i + 1, string_length(buf) - i);
	switch(result[0]) {
		case CommandType.name:
		// result[1] = 名称 (string)
			result[1] = strTemp;
			break;
			
		case CommandType.type:
		// result[1] = SleeperType.Girl/Boy等 (SleeperType)
			var _strTrans = string_digits(strTemp);
			if(string_length(_strTrans) < 1) {
				result[0] = CommandType.unknown;
				break;
			}
			result[1] = GetSleeperType(real(_strTrans));
			break;
			
		case CommandType.sleep:
		// result[1] = 床位编号 (int)
			
			// real(string_digits())的方式虽然和服务器上的 atoi()会有些差异，例如 "12AA3" 前者会返回 123，后者会返回 12
			// 但是实际上并不会出现 "12AA3" 这种奇怪的数据，所以没必要太下功夫，甚至完全没必要写
			// 而且都会经过服务器处理再发回来，旧更没必要写了
			// 但我依然这么写是为了防止我不知道哪天哪一秒脑子犯抽哪里出了错误真的出来了个 "12AA3"，至少能保证软件不会崩溃
			var _strTrans = string_digits(strTemp);
			if(string_length(_strTrans) < 1) {
				result[0] = CommandType.unknown;
				break;
			}
			result[1] = real(_strTrans);
			break;
			
		case CommandType.getup:
		// 无 result[1]
			break;
			
		case CommandType.chat:
		// result[1] = 聊天内容 (string)
			result[1] = strTemp;
			break;
			
		case CommandType.move:
		case CommandType.pos:
		// result[1][0] = x坐标 (int)
		// result[1][1] = y坐标 (int)
			result[1] = [0, 0];
			if(string_length(string_digits(strTemp)) < 1) {
				result[0] = CommandType.unknown;
				break;
			}
			var _strTrans = "";
			for(var j = 0; j < string_length(strTemp); j++) {
				if(string_char_at(strTemp, j) == ",") {
					_strTrans = string_digits(string_copy(strTemp, 0, j - 1));
					if(string_length(string_digits(_strTrans)) < 1) {
						result[0] = CommandType.unknown;
						break;
					}
					result[1][0] = real(_strTrans);
					break;
				}
			}
			_strTrans = string_digits(string_copy(strTemp, j + 1, string_length(strTemp) - j));
			if(string_length(string_digits(_strTrans)) < 1) {
				result[0] = CommandType.unknown;
				break;
			}
			result[1][1] = real(_strTrans);
			break;
	}
	
	return result;
}

/// 返回一个字符串
/// @arg _CommandType CommandType.xxxxx
/// @arg params（可能为字符串，数字，数组）
function CommandMakeMessage(_CommandType, params = undefined) {
	var res = "";
	
	switch(_CommandType) {
		case CommandType.name:
			res += "name$" + params;
			break;
			
		case CommandType.type:
			res += "name$" + string(params[0]);
			break;
			
		case CommandType.sleep:
			res += "sleep$" + params[0];
			break;
			
		case CommandType.getup:
			res += "getup$";
			break;
			
		case CommandType.chat:
			res += "chat$" + params;
			break;
			
		case CommandType.move:
			res += "move$" + string(params[0]) + "," + string(params[1]);
			break;
		case CommandType.pos:
			res += "pos$" + string(params[0]) + "," + string(params[1]);
			break;
	}
	
	return res;
}

