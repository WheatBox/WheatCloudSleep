#include "utf8tools.h"

namespace utf8tools {

	int GetUtf8BytesLen(unsigned char chr) {
		if(chr >> 7 == 0) { // 1个字节长度
			return 1;
		}
		if(chr >> 5 == 0b110) { // 2个字节长度
			return 2;
		}
		if(chr >> 4 == 0b1110) { // 3个字节长度
			return 3;
		}
		if(chr >> 3 == 0b11110) { // 4个字节长度
			return 4;
		}

		return 0;
	}

}
