event_inherited();

mouseOnMe = false;

scrollY = 0;
scrollYSpeed = 50;

arrMusicFilenameDefault = [
	":setdir",
	":opendir",
	":refresh",
];

arrMusicFilename = [];
musicFilenameLineHeight = 28;

MyRefresh = function() {
	OurPhone_ReadMusicDirectory();
	
	array_delete(arrMusicFilename, 0, array_length(arrMusicFilename));
	array_copy(arrMusicFilename, 0, arrMusicFilenameDefault, 0, array_length(arrMusicFilenameDefault));
	
	musicPlayingIndex = -1; // 重置 musicPlayingIndex
	
	var i_musicPlayingIndex = 0;
	
	var _arrFnameExtentionsTemp = ["*.wav", "*.mp3", "*.ogg"];
	for(var i = 0; i < array_length(_arrFnameExtentionsTemp); i++) {
		var _fnameFind = file_find_first(FILEPATH_ourPhoneMusics + _arrFnameExtentionsTemp[i], 0);
		while(_fnameFind != "") {
			array_push(arrMusicFilename, _fnameFind);
			
			if(_fnameFind == musicPlayingName) {
				musicPlayingIndex = i_musicPlayingIndex + array_length(arrMusicFilenameDefault); // 更新 musicPlayingIndex
			}
			i_musicPlayingIndex++;
			
			_fnameFind = file_find_next();
		}
		file_find_close();
	}
}
// MyRefresh(); // 现在放到下面去了

asyncDialogId_setdir = -1;


bottomHeight = 48;

musicPlayingName = "";
musicPlayingIndex = -1;
musicIsPlaying = false;
musicIsClose = true;
musicLength = 1;
musicPosition = 0;
musicPositionSetting = 0; // 拖拽中的 musicPosition
musicProgressBarHeight = 2; // 进度条高度
musicProgressBarHeightNature = 2; // 进度条高度 平常
musicProgressBarHeightFocus = 16; // 进度条高度 聚焦
musicLoopModeMax = 2;
musicLoopMode = 0; // 0 = 不循环且播完一首后暂停，1 = 列表循环，2 = 单曲循环

musicFinishedRefreshed = false;

MyRefresh();

MyMusicPlay = function(_musicIOnArrMusicFilename) {
	var i = _musicIOnArrMusicFilename;
	if(i >= array_length(arrMusicFilenameDefault)) {
		var fname = FILEPATH_ourPhoneMusics + arrMusicFilename[i];
		
		DebugMes("fname:" + fname);
		
		if(FileGetSize(fname) > 0) {
			MciCloseAudio(MciOpenAudio_Aliasname_OurPhoneMusic);
			
			MciOpenAudio(fname, MciOpenAudio_Aliasname_OurPhoneMusic);
			MciPlayAudio(MciOpenAudio_Aliasname_OurPhoneMusic);
			
			musicLength = MciGetAudioLength(MciOpenAudio_Aliasname_OurPhoneMusic);
			
			musicPlayingName = arrMusicFilename[i];
			musicPlayingIndex = i;
			musicIsPlaying = true;
			musicIsClose = false;
		} else {
			DebugMes("File can't be read.");
		}
	}
}

MyMusicSeek = function(pos) {
	musicPosition = pos;
	
	if(MciSeekAudioPosition(MciOpenAudio_Aliasname_OurPhoneMusic, pos) == 0) {
		// musicIsClose = true;
	}
}


musicLoopIconSprs = [
	spr_ourApp_MusicPlayer_LoopModeStop,
	spr_ourApp_MusicPlayer_LoopModeListLoop,
	spr_ourApp_MusicPlayer_LoopModeSingleLoop,
];
var _scalesTemp = SetSize_Generic(24, 24, sprite_get_width(spr_ourApp_MusicPlayer_LoopModeStop), sprite_get_height(spr_ourApp_MusicPlayer_LoopModeStop));
musicLoopIconSprsXscale = _scalesTemp[0];
musicLoopIconSprsYscale = _scalesTemp[1];

