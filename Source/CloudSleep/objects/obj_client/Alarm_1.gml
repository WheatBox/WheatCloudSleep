var _arrSiz = array_length(gDecoratesSpritesStruct.sprites);
for(var i = 0; i < _arrSiz; i++) {
	sprite_set_bbox_mode(gDecoratesSpritesStruct.sprites[i], bboxmode_automatic);
	sprite_collision_mask(gDecoratesSpritesStruct.sprites[i], false, bboxmode_automatic, 0, 0, 0, 0, bboxkind_precise, 128);
	/*DebugMes([
		sprite_get_bbox_left(gDecoratesSpritesStruct.sprites[i]),
		sprite_get_bbox_top(gDecoratesSpritesStruct.sprites[i]),
		sprite_get_bbox_right(gDecoratesSpritesStruct.sprites[i]),
		sprite_get_bbox_bottom(gDecoratesSpritesStruct.sprites[i]),
	]);*/
}
_arrSiz = array_length(gSleepersSpritesStruct.sprites);
for(var i = 0; i < _arrSiz; i++) {
	sprite_collision_mask(gSleepersSpritesStruct.sprites[i], false, bboxmode_automatic, 0, 0, 0, 0, bboxkind_precise, 0);
}

