for(var i = 0; i < vecMessages.size(); i++) {
	vecMessages.Container[i].life--;
	if(vecMessages.Container[i].life < 0) {
		MyDelete(i);
		continue;
	}
	
	var _mesText = vecMessages.Container[i].text;
	GUI_DrawLabel_ext(
		_mesText
		, GuiWidth() - 160 - string_length(_mesText) / 2
		, (string_height(_mesText) + 1) * (i + 0.5)
		, , 
		, false
		, c_black
		, GUIDefaultAlpha
	);
}

