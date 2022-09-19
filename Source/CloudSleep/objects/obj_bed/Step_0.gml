if(inited == false) {
	inited = true;
	
	sprite_index = gBedsSpritesStruct.sprites[materialId];
	mask_index = sprite_index;
	
	mp_grid_add_instances(grid, id, true);
}

SynchDepth();
