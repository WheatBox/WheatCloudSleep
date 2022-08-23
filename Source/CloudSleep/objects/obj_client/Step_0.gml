if(sendMessageQueue.size() > 0 && mySleeperId != -1) {
	SendMessage(sendMessageQueue.Container[0]);
	for(var i = 0; i < sendMessageQueue.size() - 1; i++) {
		sendMessageQueue.Container[i] = sendMessageQueue.Container[i + 1];
	}
	sendMessageQueue.pop_back();
}

if(mouse_check_button_pressed(mb_right)) {
	if(sleepers[mySleeperId].MyPathCanGo(mouse_x, mouse_y)) {
		SendPos(sleepers[mySleeperId].x, sleepers[mySleeperId].y);
		SendMove(mouse_x, mouse_y);
	}
}

