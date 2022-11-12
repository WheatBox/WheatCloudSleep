var map = async_load;

if(map[? "type"] == network_type_data) {
	var _size = map[? "size"];
	var _buffer = map[? "buffer"];
	
	while(buffer_tell(_buffer) < buffer_get_size(_buffer)) {
		var buf = buffer_read(_buffer, buffer_string);
		if(buf == "") {
			continue;
		}
		// DebugMes("buf:" + string(buf));
		
		if(DEBUGMODE && string_height(debugStrBufs) <= 720 / 0.7) {
			debugStrBufs += string(buf) + "\n";
		}
		
		buf = string_replace_all(buf, "\n", "\\n");
		buf = string_replace_all(buf, "\\", "\\\\");
		
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
					
					MyChatHistoryAddSystemMes("欢迎你，亲爱的睡客 " + _Args[0] + " ，来睡觉吧");
					
					break;
				case CommandType.sleeper:
					var arg = real(_Args[0]);
					//if(MyCanUseSleeperId(arg)) {
					//	instance_destroy(sleepers[arg]);
					//}
					sleepers[arg] = CreateSleeper(NewSleeperPosX, NewSleeperPosY);
					sleepers[arg].sleeperId = arg;
					
					MyChatHistoryAddSystemMes("新睡客 " + _Args[0] + " 来睡觉了~");
					
					break;
				case CommandType.name:
					if(!MyCanUseSleeperId(mesSleeperId)) break;
					
					// sleepers[mesSleeperId].name = StringConverter_MultiByteToUTF8(_Args[0]);
					sleepers[mesSleeperId].name = (_Args[0]);
					
					MyChatHistoryAddSystemMes("睡客 " + string(mesSleeperId) + " 设定名称为：" + _Args[0]);
					
					break;
				case CommandType.type:
					if(!MyCanUseSleeperId(mesSleeperId)) break;
					
					sleepers[mesSleeperId].type = real(_Args[0]);
					break;
					
				case CommandType.leave:
					if(!MyCanUseSleeperId(mesSleeperId)) break;
					
					if(InstanceExists(sleepers[mesSleeperId])) {
						MyChatHistoryAddSystemMes("有睡客离开了 " + string(mesSleeperId) + " @" + sleepers[mesSleeperId].name);
						
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
					sleepers[mesSleeperId].MyRecordChatHistroy(_chatMes);
					
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
					var _sleeperIdTemp = real(_Args[0]);
					if(!MyCanUseSleeperId(mesSleeperId) || !MyCanUseSleeperId(_sleeperIdTemp)) break;
					OnVote = true;
					CreateKickShowVotes(mesSleeperId, _sleeperIdTemp);
					MyChatHistoryAddSystemMes("睡客 " + string(mesSleeperId) + " @" + sleepers[mesSleeperId].name + " 发起投票踢出 " + _Args[0] + " @" + sleepers[_sleeperIdTemp].name);
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
						MyChatHistoryAddSystemMes("投票结束，投票结果：同意 " + string(obj_kickShowVotes.agreesNum) + "，反对 " + string(obj_kickShowVotes.refusesNum));
						
						instance_destroy(obj_kickShowVotes);
					}
					break;
					
				case CommandType.error:
					CommandError(_Args[0]);
					break;
					
				case CommandType.emote:
					if(!MyCanUseSleeperId(mesSleeperId)) break;
					sleepers[mesSleeperId].MyEmote(real(_Args[0]));
					break;
					
				case CommandType.report:
					GuiElement_CreateMessage("举报信息发送成功！");
					break;
				case CommandType.prichat:
					if(!InstanceExists(obj_ourApp_Chat)) break;
					obj_ourApp_Chat.MyReceiveMessage(real(_Args[0]), real(_Args[1]), string(_Args[2]));
					break;
			}
		} catch(error) {
			DebugMes([error.script, error.message]);
		}
	}
}

