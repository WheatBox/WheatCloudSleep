/*----------------------------------------------------*/
/*                      构造函数                      */
//
// A = new vector();
	// 声明一个名为A的空vector，无初始值
// A = new vector(5);
	// 声明一个名为A的vector，内含5个元素为0的初始值
// A = new vector(4, 7);
	// 声明一个名为A的vector，内含4个元素为7的初始值
/*----------------------------------------------------*/
/*                      成员变量                      */
//
// Container = [];
// 该数组为该数据结构的核心
// 你可以直接通过 A.Container[i] 来进行调用
/*----------------------------------------------------*/
/*                      基本信息                      */
//
// size(); 判断大小
// empty(); 判断容器是否为空(true)，不为空(false)
// begin_(); 返回头指针，指向第一个元素，但因为GML没有指针，故返回下标
	// 因为begin是GML保留关键字，故使用begin_代替
// end_(); 返回尾指针，指向最后一个元素，但因为GML没有指针，故返回下标
	// 因为end是GML保留关键字，故使用end_代替
/*----------------------------------------------------*/
/*                      访问元素                      */
//
// front(); 返回首元素的引用，若为空则返回undefined
// back(); 返回尾元素的引用，若为空则返回undefined
// at(_pos); 返回pos位置元素的引用，若为空则返回undefined
/*----------------------------------------------------*/
/*                      写入元素                      */
//
// push_back(_val); 从容器末尾写入元素
// insert(_index, _n_or_val, _val = undefined); 插入元素
		/* C++中有两种写法：
			a.insert(it, val) 或 a.insert(it, n, val) */
/*----------------------------------------------------*/
/*                      删除元素                      */
//
// pop_back(); 从容器末尾删除元素
// erase(_first, _last = _first + 1); 删除 [_first,_last) 的元素
	// _first 和 _last 直接写下标即可
// clear(); 清空容器
/*----------------------------------------------------*/
/*                      其它函数                      */
//
// resize(_size); 改变当前使用数据的大小，如果它比当前使用的大，填充默认值
// swap(_vector); 互换两个vector里的数据
/*----------------------------------------------------*/

function vector(_inilen = 0, _ininum = 0) constructor {
	Container = [];
	for(var i = 0; i < _inilen; i++) {
		Container[i] = _ininum;
	}
	
	function size() { // 判断大小
		return array_length(Container);
	}
	
	function empty() { // 判断容器是否为空(true)，不为空(false)
		return size() > 0 ? false : true;
	}
	
	function begin_() { // 返回头指针，指向第一个元素，但因为GML没有指针，故返回下标
		// 因为begin是GML保留关键字，故使用begin_代替
		return 0; // 额……，对，没错……，返回下标0……
	}
	
	function end_() { // 返回尾指针，指向最后一个元素，但因为GML没有指针，故返回下标
		// 因为end是GML保留关键字，故使用end_代替
		return size() - 1;
	}
	
	
	function front() { // 返回首元素的引用，若为空则返回undefined
		return empty() == false ? Container[0] : undefined;
	}
	
	function back() { // 返回尾元素的引用，若为空则返回undefined
		return empty() == false ? Container[end_()] : undefined;
	}
	
	function at(_pos) { // 返回pos位置元素的引用，若为空则返回undefined
		return _pos <= end_() ? Container[_pos] : undefined;
	}
	
	
	function push_back(_val) { // 从容器末尾写入元素
		array_push(Container, _val);
	}
	
	function insert(_index, _n_or_val, _val = undefined) { // 插入元素
		/* C++中有两种写法：
			a.insert(it, val) 或 a.insert(it, n, val)*/
		if(_val != undefined) {
			repeat(_n_or_val) {
				array_insert(Container, _index, _val);
			}
		} else {
			array_insert(Container, _index, _n_or_val);
		}
	}
	
	
	function pop_back() { // 从容器末尾删除元素
		array_pop(Container);
	}
	
	function erase(_first, _last = _first + 1) { // 删除 [_first,_last) 的元素
		// _first 和 _last 直接写下标即可
		array_delete(Container, _first, _last - _first);
	}
	
	function clear() { // 清空容器
		repeat(size()) {
			pop_back();
		}
	}
	
	
	function resize(_size) { // 改变当前使用数据的大小，如果它比当前使用的大，填充默认值
		if(size() > _size) {
			erase(_size, size());
		} else if(size() < _size) {
			for(var i = size(); i < _size; i++) {
				Container[i] = 0;
			}
		}
	}
	
	function swap(_vector) { // 互换两个vector里的数据
		// var _vecsize = _vector.size();
		var _vecCon = _vector.Container;
		_vector.Container = Container;
		Container = _vecCon;
	}
}


