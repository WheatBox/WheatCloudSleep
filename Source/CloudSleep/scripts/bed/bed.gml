/// @desc 创建床
/// @param {real} _x x
/// @param {real} _y y
/// @param {real} _depth depth
/// @param {real} _bedSleepId 床位睡觉id
function CreateBed(_x, _y, _bedSleepId) {
	var newins = instance_create_depth(_x, _y, 0, obj_bed);
	InitBed(newins, _bedSleepId);
	return newins;
}

/// @desc 初始化床
/// @param {Id.Instance} _betInsid 床的实例id
/// @param {real} _bedSleepId 床位睡觉id
function InitBed(_betInsid, _bedSleepId) {
	_betInsid.sprite_index = spr_bedEmpty;
	_betInsid.bedSleepId = _bedSleepId;
	_betInsid.bedSleeperName = undefined;
	_betInsid.empty = true;
}

