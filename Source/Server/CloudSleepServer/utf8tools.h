#pragma once

namespace utf8tools {

	// 检测某一字符是否为 UTF-8 编码中一个字的开始字节
	// 返回该字符的字节数量
	// 非开始字节会返回0
	int GetUtf8BytesLen(unsigned char chr);

}
