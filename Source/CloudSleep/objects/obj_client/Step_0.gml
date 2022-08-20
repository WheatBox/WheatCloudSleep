if(sendMessageQueue.size() > 0) {
	SendMessage(sendMessageQueue.Container[0]);
	for(var i = 0; i < sendMessageQueue.size() - 1; i++) {
		sendMessageQueue.Container[i] = sendMessageQueue.Container[i + 1];
	}
	sendMessageQueue.pop_back();
}

