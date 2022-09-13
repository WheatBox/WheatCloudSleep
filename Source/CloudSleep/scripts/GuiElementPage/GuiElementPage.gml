function GuiElement_PageAddElement_Multi(pageIns, arrElementIns, arrElementHeight = undefined) {
	var len = array_length(arrElementIns);
	for(var i = 0; i < len; i++) {
		if(arrElementHeight == undefined) {
			GuiElement_PageAddElement(pageIns, arrElementIns[i], undefined);
		} else {
			GuiElement_PageAddElement(pageIns, arrElementIns[i], arrElementHeight[i]);
		}
	}
}

/// 注意！！！elementIns.y 在此处变为增量y，如果想要紧挨着最后一个元素添加，请直接设0！！！
function GuiElement_PageAddElement(pageIns, elementIns, elementHeight = undefined) {
	with(pageIns) {
		var ins = elementIns;
		if(InstanceExists(ins)) {
			
			vecChildElementsInitY.push_back(ins.y);
			
			// 我不知道发什么了什么，反正调试后发现刚好多了这个值，所以在结尾ins.y减去它就好了
			// 怎么运行起来的，我不知道
			var insYTemp = ins.y;
			
			ins.x += x;
			ins.y += y + 32;
			
			vecChildElements.push_back(ins);
			
			if(elementHeight == undefined) {
				if(ins[$ "height"] != undefined) {
					// DebugMes(object_get_name(elementIns.object_index) + "-" + string(elementIns) + " 's auto got \"height\" = " + string(ins.height));
					vecChildElementsHeight.push_back(ins.height);
				} else {
					// DebugMes(object_get_name(elementIns.object_index) + "-" + string(elementIns) + " 's \"height\" undefined");
					vecChildElementsHeight.push_back(ins.sprite_height * ins.image_yscale);
				}
			} else {
				vecChildElementsHeight.push_back(elementHeight);
			}
			
			for(var i = 0; i < vecChildElementsHeight.size(); i++) {
				ins.y += vecChildElementsHeight.Container[i];
				ins.y += vecChildElementsInitY.Container[i];
				ins.y += 1;
				// DebugMes(string(ins.y) + "  " + string(vecChildElementsHeight.Container[i]) + "  " + string(vecChildElementsInitY.Container[i]));
			}
			
			ins.y -= vecChildElementsHeight.back() / 2;
			
			ins.y -= insYTemp;
			
			instance_deactivate_object(ins);
		}
	}
}


function GuiElement_PageGetIsWorking(ins) {
	if(InstanceExists(ins)) {
		return ins.working;
	}
	return false;
}

function GuiElement_PageStartWork(ins) {
	if(InstanceExists(ins)) {
		ins.MyStartWork();
	}
}

function GuiElement_PageStopWork(ins) {
	if(InstanceExists(ins)) {
		ins.MyStopWork();
	}
}

function GuiElement_PageStartWorkAll(_vector) {
	for(var i = 0; i < _vector.size(); i++) {
		GuiElement_PageStartWork(_vector.Container[i]);
	}
}

function GuiElement_PageStopWorkAll(_vector) {
	for(var i = 0; i < _vector.size(); i++) {
		GuiElement_PageStopWork(_vector.Container[i]);
	}
}

/// @desc 
///			将 endI 设为 0，为仅仅只删除 beginI 对应的 ins（默认
///			将 endI 设为 -1，删除直至结尾
function GuiElement_PageClearIns(_pageIns, beginI, endI = 0) {
	if(endI == -1) {
		endI = _pageIns.vecChildElements.size() - beginI;
	} else if(endI == 0) {
		endI = beginI;
	}
	
	if(beginI > endI) {
		return;
	}
	
	for(var i = beginI; i <= endI; i++) {
		instance_destroy(_pageIns.vecChildElements.Container[i]);
	}
	
	array_delete(_pageIns.vecChildElements.Container, beginI, endI - beginI + 1);
	array_delete(_pageIns.vecChildElementsInitY.Container, beginI, endI - beginI + 1);
	array_delete(_pageIns.vecChildElementsHeight.Container, beginI, endI - beginI + 1);
	
	
	// 整理目前已放置的 SceneElements
	// SceneElement_BackgroundsAlignAfterDelete(beginI, endI - beginI + 1);
}

/// @desc 对齐 Page 里的各个 Element
function GuiElement_PageAlign(_pageIns) {
	if(!InstanceExists(_pageIns)) {
		return;
	}
	var _len = _pageIns.vecChildElements.size();
	for(var i = 0; i < _len; i++) {
		var ins = _pageIns.vecChildElements.Container[i];
		ins.y = _pageIns.y + 32 - _pageIns.scrollY;
		
		for(var j = 0; j <= i; j++) {
			ins.y += _pageIns.vecChildElementsHeight.Container[j];
			ins.y += _pageIns.vecChildElementsInitY.Container[j];
			ins.y += 1;
		}
		
		ins.y -= _pageIns.vecChildElementsHeight.Container[i] / 2;
	}
}

