var map = async_load;

if(map[? "type"] == network_type_data) {
	var _size = map[? "size"];
	var _buffer = map[? "buffer"];
	
	while(buffer_tell(_buffer) < buffer_get_size(_buffer)) {
		var buf = buffer_read(_buffer, buffer_string);
		DebugMes("buf:" + string(buf));
		
		try {
			var bufjson = json_parse(buf);
			
			var _Cmd = GetCommandTypeFromString(bufjson.Cmd);
			var _Args = bufjson.Args;
			var mesSleeperId = real(bufjson.Id);
			
			switch(_Cmd) {
				case CommandType.unknown:
					break;
					
				case CommandType.yourid:
					mySleeperId = real(_Args[0]);
					if(!MyCanUseSleeperId(mySleeperId)) {
						sleepers[mySleeperId] = CreateSleeper(NewSleeperPosX, NewSleeperPosY);
						sleepers[mySleeperId].isMe = true;
						sleepers[mySleeperId].sleeperId = mySleeperId;
					}
					break;
				case CommandType.sleeper:
					var arg = real(_Args[0]);
					if(MyCanUseSleeperId(arg)) {
						instance_destroy(sleepers[arg]);
					}
					sleepers[arg] = CreateSleeper(NewSleeperPosX, NewSleeperPosY);
					sleepers[arg].x = 1000;
					sleepers[arg].y = 1000;
					sleepers[arg].sleeperId = arg;
					break;
				case CommandType.name:
					if(!MyCanUseSleeperId(mesSleeperId)) break;
					
					// sleepers[mesSleeperId].name = StringConverter_MultiByteToUTF8(_Args[0]);
					sleepers[mesSleeperId].name = (_Args[0]);
					break;
				case CommandType.type:
					if(!MyCanUseSleeperId(mesSleeperId)) break;
					
					sleepers[mesSleeperId].type = real(_Args[0]);
					break;
					
				case CommandType.leave:
					if(!MyCanUseSleeperId(mesSleeperId)) break;
					
					if(InstanceExists(sleepers[mesSleeperId])) {
						instance_destroy(sleepers[mesSleeperId]);
					}
					break;
					
				case CommandType.sleep:
					if(!MyCanUseSleeperId(mesSleeperId)) break;
					
					sleepers[mesSleeperId].MySleep(real(_Args[0]));
					break;
				case CommandType.getup:
					if(!MyCanUseSleeperId(mesSleeperId)) break;
					
					sleepers[mesSleeperId].MyGetup();
					break;
					
				case CommandType.chat:
					if(!MyCanUseSleeperId(mesSleeperId)) break;
					
					// var _chatMes = StringConverter_MultiByteToUTF8(_Args[0]);
					var _chatMes = (_Args[0]);
					
					sleepers[mesSleeperId].MyChat(_chatMes);
					
					MyChatHistoryAdd(mesSleeperId, _chatMes);
					break;
					
				case CommandType.move: // 进行到此
					if(!MyCanUseSleeperId(mesSleeperId)) break;
					
					sleepers[mesSleeperId].MyPathGo(real(_Args[0]), real(_Args[1]));
					break;
				case CommandType.pos:
					if(!MyCanUseSleeperId(mesSleeperId)) break;
					if(mesSleeperId == mySleeperId) break;
					
					sleepers[mesSleeperId].MySetPos(real(_Args[0]), real(_Args[1]));
					break;
					
				case CommandType.kick:
					if(!MyCanUseSleeperId(mesSleeperId) || !MyCanUseSleeperId(real(_Args[0]))) break;
					OnVote = true;
					CreateKickShowVotes(mesSleeperId, real(_Args[0]));
					break;
				case CommandType.agree:
				case CommandType.refuse:
					if(instance_exists(obj_kickShowVotes)) {
						obj_kickShowVotes.agreesNum = real(_Args[0]);
						obj_kickShowVotes.refusesNum = real(_Args[1]);
					}
					break;
				case CommandType.kickover:
					OnVote = false;
					if(instance_exists(obj_kickShowVotes)) {
						instance_destroy(obj_kickShowVotes);
					}
					break;
			}
		} catch(error) {
			DebugMes([error.script, error.message]);
		}
	}
}

