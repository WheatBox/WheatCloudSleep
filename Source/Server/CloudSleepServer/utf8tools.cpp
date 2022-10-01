#include "utf8tools.h"

namespace utf8tools {

	bool IsUtf8BeginChar(unsigned char chr) {
		if(chr >> 7 == 0) { // 1个字节长度
			return true;
		}
		if(chr >> 5 == 0b110) { // 2个字节长度
			return true;
		}
		if(chr >> 4 == 0b1110) { // 3个字节长度
			return true;
		}
		if(chr >> 3 == 0b11110) { // 4个字节长度
			return true;
		}

		return false;
	}

}
