var asyncType = async_load[? "type"];

if(asyncType == network_type_non_blocking_connect) {
	var asyncSucceed = async_load[? "succeeded"];
	
	if(asyncSucceed == 1) {
		// show_message("~连接服务器 " + serverIP + ":" + string(serverPort) + " 成功~");
		// room_goto(rm_bedroom);
		instance_destroy(id);
	} else {
		show_message("连接服务器 " + serverIP + ":" + string(serverPort) + " 失败！！！");
		game_restart();
	}
}

