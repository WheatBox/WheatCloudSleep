if(async_load[? "id"] == asyncDialogId_setdir) {
	if(async_load[? "status"]) {
		var res = async_load[? "result"];
		if(OurPhone_WriteMusicDirectory(res)) {
			MyRefresh();
		}
	}
	asyncDialogId_setdir = -1;
}

