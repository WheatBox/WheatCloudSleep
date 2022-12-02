depth = SceneDepthBackgrounds + 100;

camxPrevious = undefined;
camyPrevious = undefined;

myDefaultBackground = -1;

mysurf = -1;
MySurfCheckAndRemake = function() {
	var _willFreeSurf = false;
	
	if(gSceneStruct.defaultBackground < 0 || gSceneStruct.defaultBackground >= array_length(gBackgroundsStruct.materials)) {
		_willFreeSurf = true;
	} else if(sprite_exists(gBackgroundsSpritesStruct.sprites[gSceneStruct.defaultBackground]) == false) {
		_willFreeSurf = true;
	}
	
	if(_willFreeSurf) {
		MyFreeSurf();
		return;
	}
	
	if(mysurf != -1) {
		if(surface_exists(mysurf)) {
			return;
		}
	}
	
	mysurf = surface_create(GuiWidth(), GuiHeight());
	
	surface_set_target(mysurf);
	
	var _spr = gBackgroundsSpritesStruct.sprites[gSceneStruct.defaultBackground];
	
	var _camScale = CameraScale();
	
	var _sprW = sprite_get_width(_spr);
	var _sprH = sprite_get_height(_spr);
	
	var _xoff = GetPositionXGridStandardization(CameraX(), _sprW);
	var _yoff = GetPositionYGridStandardization(CameraY(), _sprH);
	
	var _ixlen = ceil(CameraWidth() / _sprW) + 1;
	var _iylen = ceil(CameraHeight() / _sprH) + 1;
	
	for(var iy = 0; iy < _iylen; iy++) {
		for(var ix = 0; ix < _ixlen; ix++) {
			draw_sprite_ext(_spr, 0
				, GetPositionXOnGUI(_xoff + ix * _sprW)
				, GetPositionYOnGUI(_yoff + iy * _sprH)
				, 1 / _camScale, 1 / _camScale, 0, c_white, 1.0
			);
		}
	}
	
	surface_reset_target();
}

MyFreeSurf = function() {
	if(mysurf != -1) {
		if(surface_exists(mysurf)) {
			surface_free(mysurf);
			mysurf = -1;
		}
	}
}
