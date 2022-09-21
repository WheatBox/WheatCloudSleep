/// @desc 设置物体的大小
/// @param {real} destWidth 宽
/// @param {real} destHeight 高
/// @param {id} destID 物体id，默认为当前物体的id，也可设为其它物体的id
function SetSize(destWidth, destHeight, destID = id) {
	with(destID) {
		image_xscale = destWidth / sprite_get_width(sprite_index);
		image_yscale = destHeight / sprite_get_height(sprite_index);
	}
}

/// @desc 设置物体的大小，但是锁定宽高比
/// @param {real} destWidth 宽
/// @param {id} destID 物体id，默认为当前物体的id，也可设为其它物体的id
function SetSizeLockAspect_Width(destWidth, destID = id) {
	with(destID) {
		image_xscale = destWidth / sprite_get_width(sprite_index);
		image_yscale = image_xscale;
	}
}

/// @desc 设置物体的大小，但是锁定宽高比
/// @param {real} destHeight 高
/// @param {id} destID 物体id，默认为当前物体的id，也可设为其它物体的id
function SetSizeLockAspect_Height(destHeight, destID = id) {
	with(destID) {
		image_yscale = destHeight / sprite_get_height(sprite_index);
		image_xscale = image_yscale;
	}
}


/// @desc 设置物体的大小，通用版本，返回一个二维数组，[0] = xscale, [1] = yscale
/// @param {real} destWidth 宽
/// @param {real} destHeight 高
/// @param {real} srcWidth sprite_get_width()
/// @param {real} srcHeight sprite_get_height()
function SetSize_Generic(destWidth, destHeight, srcWidth, srcHeight) {
	var res = [1, 1];
	res[0] = destWidth / srcWidth;
	res[1] = destHeight / srcHeight;
	return res;
}

/// @desc 设置物体的大小，但是锁定宽高比，通用版本，返回一个二维数组，[0] = xscale, [1] = yscale
/// @param {real} destWidth 宽
/// @param {real} srcWidth sprite_get_width()
function SetSizeLockAspect_Width_Generic(destWidth, srcWidth) {
	var res = [1, 1];
	res[0] = destWidth / srcWidth;
	res[1] = res[0];
	return res;
}

/// @desc 设置物体的大小，但是锁定宽高比，通用版本，返回一个二维数组，[0] = xscale, [1] = yscale
/// @param {real} destHeight 高
/// @param {real} srcHeight sprite_get_height()
function SetSizeLockAspect_Height_Generic(destHeight, srcHeight) {
	var res = [1, 1];
	res[1] = destHeight / srcHeight;
	res[0] = res[1];
	return res;
}

