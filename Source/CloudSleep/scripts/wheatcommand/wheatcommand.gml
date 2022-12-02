enum CommandType {
	unknown,
	
	yourid,
	sleeper,
	name,
	type,
	
	leave,
	
	sleep,
	getup,
	
	chat,
	
	move,
	pos,
	
	kick,
	agree,
	refuse,
	kickover,
	
	error,
	
	packguid,
	
	emote,
	
	report,
	prichat,
};

function GetCommandTypeFromString(buf) {
	switch(buf) {
		case "yourid":
			return CommandType.yourid;
		case "sleeper":
			return CommandType.sleeper;
		case "name":
			return CommandType.name;
		case "type":
			return CommandType.type;
			
		case "leave":
			return CommandType.leave;
			
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
			
		case "kick":
			return CommandType.kick;
		case "agree":
			return CommandType.agree;
		case "refuse":
			return CommandType.refuse;
		case "kickover":
			return CommandType.kickover;
		
		case "error":
			return CommandType.error;
			
		case "packguid":
			return CommandType.packguid;
			
		case "emote":
			return CommandType.emote;
			
		case "report":
			return CommandType.report;
		case "prichat":
			return CommandType.prichat;
	}
	
	return CommandType.unknown;
}

/// 返回一个字符串
/// @arg _CommandType CommandType.xxxxx
/// @arg params（可能为字符串，数字，数组）
function CommandMakeMessage(_CommandType, params = undefined) {
	var sendJson = { Cmd:"", Args:[""] };
	
	switch(_CommandType) {
		case CommandType.yourid:
		case CommandType.sleeper:
			break;
		
		case CommandType.name:
			sendJson.Cmd = "name";
			sendJson.Args[0] = params[0];
			break;
			
		case CommandType.type:
			sendJson.Cmd = "type";
			sendJson.Args[0] = string(params[0]);
			break;
			
		case CommandType.leave:
			break;
			
		case CommandType.sleep:
			sendJson.Cmd = "sleep";
			sendJson.Args[0] = string(params[0]);
			break;
			
		case CommandType.getup:
			sendJson.Cmd = "getup";
			sendJson.Args[0] = "0";
			break;
			
		case CommandType.chat:
			sendJson.Cmd = "chat";
			sendJson.Args[0] = string(params[0]);
			break;
			
		case CommandType.move:
			sendJson.Cmd = "move";
			sendJson.Args[0] = string(params[0]);
			sendJson.Args[1] = string(params[1]);
			break;
		case CommandType.pos:
			sendJson.Cmd = "pos";
			sendJson.Args[0] = string(params[0]);
			sendJson.Args[1] = string(params[1]);
			break;
			
		case CommandType.kick:
			sendJson.Cmd = "kick";
			sendJson.Args[0] = string(params[0]);
			break;
			
		case CommandType.agree:
			sendJson.Cmd = "agree";
			sendJson.Args[0] = "0";
			break;
			
		case CommandType.refuse:
			sendJson.Cmd = "refuse";
			sendJson.Args[0] = "0";
			break;
			
		case CommandType.kickover:
			break;
			
		case CommandType.error:
			break;
			
		case CommandType.packguid:
			sendJson.Cmd = "packguid";
			sendJson.Args[0] = PackGuid;
			break;
			
		case CommandType.emote:
			sendJson.Cmd = "emote";
			sendJson.Args[0] = string(params[0]);
			break;
			
		case CommandType.report:
			sendJson.Cmd = "report";
			sendJson.Args[0] = string(params[0]);
			break;
		case CommandType.prichat:
			sendJson.Cmd = "prichat";
			sendJson.Args[0] = "0";
			sendJson.Args[1] = string(params[0]);
			sendJson.Args[2] = params[1];
	}
	
	return json_stringify(sendJson);
}


function CommandError(_errorCode) {
	switch(real(_errorCode)) {
		case 1001:
			show_message_async("错误！用户名中含有敏感词汇！");
			GameRestart();
			break;
		case 1002:
			show_message_async("错误！所选场景包与所连接的服务器指定的场景包不匹配！");
			GameRestart();
			break;
	}
}

