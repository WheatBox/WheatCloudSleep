depth = -12345;

/*
var serverAddressData = ReadAddress("ServerAddress.txt");
if(serverAddressData == -1) {
	show_message("无法正常打开或读取文件 ServerAddress.txt\n请确认文件中的信息格式为xxx.xxx.xxx.xxx:yyyyy\n(x为服务器IP，y为服务器端口)");
	game_end();
}
serverIP = serverAddressData[0];
serverPort = real(serverAddressData[1]);
*/
socket = network_create_socket(network_socket_tcp);

network_set_config(network_config_connect_timeout, 3000);
network_connect_raw_async(socket, serverIP, serverPort);

getDrawDots = function() {
	static num = 0, rate = 20;
	num++;
	if(num >= 6 * rate) num = 0;
	return floor(num / rate);
}

