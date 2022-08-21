var map = async_load;

if(map[? "type"] == network_type_data) {
	var _size = map[? "size"];
	var buf = map[? "buffer"];
	
	var mesSleeperIdMax = MyGetSleeperIdMax();
	var mesSleeperId = real(buffer_read(buf, buffer_string));
	var mes = buffer_read(buf, buffer_string);
	
	show_debug_message(mes);
	
	var arrParse = CommandParse(mes);
	
	var commandType = arrParse[0];
	var params = arrParse[1];
	
	switch(commandType) {
		case CommandType.unknown:
			break;
			
		case CommandType.yourid:
			mySleeperId = real(params[0]);
			if(mySleeperId > mesSleeperIdMax || !instance_exists(sleepers[mySleeperId])) {
				sleepers[mySleeperId] = CreateSleeper(NewSleeperPosX, NewSleeperPosY);
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
	}
}

