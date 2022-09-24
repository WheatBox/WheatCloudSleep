if(inited == false) {
	inited = true;
	
	sprite_index = gDecoratesSpritesStruct.sprites[materialId];
	mask_index = sprite_index;
	
	mp_grid_add_instances(grid, id, true);
}

if(overlappingSleeper) {
	overlappingSleeper = false;
	image_alpha = lerp(image_alpha, 0.2, 0.1);
} else {
	image_alpha = lerp(image_alpha, 1.0, 0.1);
}

SynchDepth();
