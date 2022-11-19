event_inherited();

myButton = new OurPhoneGuiElement_Button(
	OurPhoneScreenWidth / 2 - 80, OurPhoneScreenHeight / 2 - 48
	, 160, 96
	, "打开照片文件夹"
	, , function() {
		try {
			if(!directory_exists(FILEPATH_ourPhonePhotos)) {
				MakeFolder(FILEPATH_ourPhonePhotos);
			}
			if(directory_exists(FILEPATH_ourPhonePhotos)) {
			
			} else {
				show_message_async("无法正确访问或创建照片文件夹：" + FILEPATH_ourPhonePhotos);
			
				return;
			}
		} catch(error) {
			DebugMes([error.script, error.message]);
		
			return;
		}
		
		OpenInExplorer(FILEPATH_ourPhonePhotos);
	}
	, , 0.9, , , true
);
