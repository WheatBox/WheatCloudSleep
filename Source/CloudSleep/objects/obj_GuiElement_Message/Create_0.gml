depth = GUIMessageDepth;

mySMessage = function(_text) constructor {
	text = _text;
	life = 5 * 60;
};

vecMessages = new vector();

MyAdd = function(_text) {
	vecMessages.push_back(new mySMessage(_text));
}

MyDelete = function(i) {
	if(CheckStructCanBeUse(vecMessages.Container[i])) {
		delete vecMessages.Container[i];
	}
	array_delete(vecMessages.Container, 0, 1);
}

