draw_set_color(c_white);
draw_set_alpha(GUIDefaultAlpha / 2);
GUI_DrawRectangle(textboxNameX, textboxNameY, textboxNameX + textboxNameWidth, textboxNameY + textboxNameHeight, false);
GUI_DrawRectangle(textboxIpPortX, textboxIpPortY, textboxIpPortX + textboxIpPortWidth, textboxIpPortY + textboxIpPortHeight, false);

draw_set_color(GUIDefaultColor);
draw_set_alpha(1.0);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
GUI_DrawText(pageWidth + 16, 16, "当前选中的场景包：" + string(PackName), false);

if(CheckStructCanBeUse(gSleepersSpritesStruct))
if(variable_struct_exists(gSleepersSpritesStruct, "sprites"))
if(is_array(gSleepersSpritesStruct.sprites)) {
	
	var _attenX = pageWidth + 16;
	var _attenY = 16 + string_height("乐");
	draw_set_color(attentionTextColor);
	draw_set_alpha(GUIDefaultAlpha);
	GUI_DrawRectangle(_attenX, _attenY - scrollY, _attenX + string_width(attentionText), _attenY - scrollY + string_height(attentionText), false);
	draw_set_color(c_black);
	draw_set_alpha(1.0);
	GUI_DrawText(_attenX, _attenY - scrollY, attentionText, false);
	
	var xoffAdd = 352;
	var yoffAdd = 64 - scrollY + string_height(attentionText);
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
		
		var sprTempX = (i - iy * iWidth) * (myImageMinimumWidthHeight + 1) + xoffAdd;
		var sprTempY = iy * (myImageMinimumWidthHeight + 1) + myImageMinimumWidthHeight / 2 + yoffAdd;
		
		GUI_DrawSprite_ext(gSleepersSpritesStruct.sprites[i], 0
			, sprTempX, sprTempY
			, _scalesTemp[0], _scalesTemp[1]
			, 0, c_white, 1.0
		);
		
		if(myType == i) {
			draw_set_color(c_white);
			draw_set_alpha(GUIHighLightAlpha);
			GUI_DrawRectangle_Radius(sprTempX, sprTempY, myImageMinimumWidthHeight / 2, false);
		} else
		if(
			GUI_MouseGuiOnMe_Radius(sprTempX, sprTempY, myImageMinimumWidthHeight / 2)
			&& !GUI_MouseGuiOnMe(textboxNameX, textboxNameY, textboxNameX + textboxNameWidth, textboxNameY + textboxNameHeight)
			&& !GUI_MouseGuiOnMe(textboxIpPortX, textboxIpPortY, textboxIpPortX + textboxIpPortWidth, textboxIpPortY + textboxIpPortHeight)
		) {
			draw_set_color(c_white);
			draw_set_alpha(GUIHighLightAlpha / 2);
			GUI_DrawRectangle_Radius(sprTempX, sprTempY, myImageMinimumWidthHeight / 2, false);
			
			if(MouseLeftPressed()) {
				myType = i;
			}
		}
	}
	
	
	
	if(mouse_wheel_up()) {
		if(scrollY > 0) {
			scrollY -= scrollYSpeed;
		}
	} else if(mouse_wheel_down()) {
		if(scrollY < iy * (myImageMinimumWidthHeight + 1)) {
			scrollY += scrollYSpeed;
		}
	}
	
	if(scrollY < 0) {
		scrollY = 0;
	}
	if(scrollY > iy * (myImageMinimumWidthHeight + 1)) {
		scrollY = iy * (myImageMinimumWidthHeight + 1);
	}
}