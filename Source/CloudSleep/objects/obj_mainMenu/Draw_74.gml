draw_set_color(c_white);
draw_set_alpha(GUIDefaultAlpha / 2);
GUI_DrawRectangle(textboxNameX, textboxNameY, textboxNameX + textboxNameWidth, textboxNameY + textboxNameHeight, false);
GUI_DrawRectangle(textboxIpPortX, textboxIpPortY, textboxIpPortX + textboxIpPortWidth, textboxIpPortY + textboxIpPortHeight, false);

draw_set_color(GUIDefaultColor);
draw_set_alpha(1.0);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
GUI_DrawText(pageWidth + 16, 16, "当前选中的场景包：" + string(PackName), 0);

if(CheckStructCanBeUse(gSleepersSpritesStruct))
if(variable_struct_exists(gSleepersSpritesStruct, "sprites"))
if(is_array(gSleepersSpritesStruct.sprites)) {
	var xoffAdd = 320;
	var iWidth = round((GuiWidth() - xoffAdd) / myImageMinimumWidthHeight);
	var iy = 0;
	for(var i = 0; i < array_length(gSleepersSpritesStruct.sprites); i++) {
		if(i - iy * iWidth >= iWidth) {
			iy++;
		}
		
		var _scalesTemp = [1, 1];
		var sprW = sprite_get_width(gSleepersSpritesStruct.sprites[i]), sprH = sprite_get_height(gSleepersSpritesStruct.sprites[i]);
		if(sprW > sprH) {
			_scalesTemp = SetSizeLockAspect_Width_Generic(myImageMinimumWidthHeight, sprW);
		} else {
			_scalesTemp = SetSizeLockAspect_Height_Generic(myImageMinimumWidthHeight, sprH);
		}
		
		GUI_DrawSprite_ext(gSleepersSpritesStruct.sprites[i], 0
			, (i - iy * iWidth) * myImageMinimumWidthHeight + xoffAdd, iy * myImageMinimumWidthHeight + myImageMinimumWidthHeight / 2 + 32
			, _scalesTemp[0], _scalesTemp[1]
			, 0, c_white, 1.0
		);
	}
}