if(CheckStructCanBeUse(vecMessages)) {
	for(var i = 0; i < vecMessages.size(); i++) {
		if(CheckStructCanBeUse(vecMessages.Container[i])) {
			delete vecMessages.Container[i];
		}
	}
	delete vecMessages;
}

