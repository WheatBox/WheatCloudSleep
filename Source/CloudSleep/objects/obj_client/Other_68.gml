var map = async_load;

if(map[? "type"] == network_type_data) {
	var _size = map[? "size"];
	var buf = map[? "buffer"];
	
	while(buffer_tell(buf) < buffer_get_size(buf)) {
		var mesSleeperIdMax = MyGetSleeperIdMax();
		var mesSleeperId = real(buffer_read(buf, buffer_string));
		show_debug_message("bufA = " + string(mesSleeperId));
		
		var mes = buffer_read(buf, buffer_string);
		show_debug_message("bufB = " + mes);
	
		var arrParse = CommandParse(mes);
	
		var commandType = arrParse[0];
		var params = arrParse[1];
	
		switch(commandType) {
			case CommandType.unknown:
				break;
			
			case CommandType.yourid:
				mySleeperId = real(params[0]);
				if(!MyCanUseSleeperId(mySleeperId)) {
					sleepers[mySleeperId] = CreateSleeper(NewSleeperPosX, NewSleeperPosY);
					sleepers[mySleeperId].isMe = true;
					
					SendPos(sleepers[mySleeperId].x, sleepers[mySleeperId].y);
				}
				break;
			case CommandType.sleeper:
				if(real(params[0]) <= mesSleeperIdMax) {
					if(instance_exists(sleepers[real(params[0])])) {
						instance_destroy(sleepers[real(params[0])]);
					}
				}
				sleepers[real(params[0])] = CreateSleeper(NewSleeperPosX, NewSleeperPosY);
				break;
			case CommandType.name:
				if(!MyCanUseSleeperId(mesSleeperId)) break;
			
				sleepers[mesSleeperId].name = params;
				break;
			case CommandType.type:
				if(!MyCanUseSleeperId(mesSleeperId)) break;
			
				sleepers[mesSleeperId].type = real(params[0]);
				break;
			
			case CommandType.leave:
				if(!MyCanUseSleeperId(mesSleeperId)) break;
			
				instance_destroy(sleepers[mesSleeperId]);
				break;
				
			case CommandType.sleep:
				if(!MyCanUseSleeperId(mesSleeperId)) break;
				
				sleepers[mesSleeperId].MySleep(real(params[0]));
				break;
			case CommandType.getup:
				if(!MyCanUseSleeperId(mesSleeperId)) break;
				
				sleepers[mesSleeperId].MyGetup();
				break;
				
			case CommandType.chat:
				if(!MyCanUseSleeperId(mesSleeperId)) break;
				
				sleepers[mesSleeperId].MyChat(params);
				break;
			
			case CommandType.move:
				if(!MyCanUseSleeperId(mesSleeperId)) break;
			
				sleepers[mesSleeperId].MyPathGo(real(params[0]), real(params[1]));
				break;
			case CommandType.pos:
				if(!MyCanUseSleeperId(mesSleeperId)) break;
				if(mesSleeperId == mySleeperId) break;
				
				sleepers[mesSleeperId].MySetPos(real(params[0]), real(params[1]));
				break;
		}
	}
}

