// mask_index = spr_bedHitbox;

materialId = 0;
bedSleepId = -1;
// bedSleeperName = undefined;
// empty = false;

MySleep = function(_sleeperType) {
	if(array_length(gArrBedSleepSprites) > materialId)
	if(array_length(gArrBedSleepSprites[materialId]) > _sleeperType)
	if(sprite_exists(gArrBedSleepSprites[materialId][_sleeperType])) {
		sprite_index = gArrBedSleepSprites[materialId][_sleeperType];
	}
	DebugMes(["BedSleep", materialId, _sleeperType, sprite_index])
}

MyGetup = function() {
	sprite_index = mask_index;
}


inited = false;