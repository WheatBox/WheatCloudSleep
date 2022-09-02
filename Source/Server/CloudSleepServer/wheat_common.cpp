#include "wheat_common.h"

namespace wheat
{

	std::vector<std::string_view>
		Split(std::string_view str, std::string_view delimiter, bool allow_empty)
	{
		std::vector<std::string_view> vec;
		if (delimiter.empty())
		{
			return vec;
		}

		std::size_t current = 0;
		std::size_t index = 0;
		while ((index = str.find(delimiter, current)) != str.npos)
		{
			if (index - current != 0 || allow_empty)
			{
				vec.emplace_back(str.data() + current, index - current);
			}
			current = index + delimiter.length();
		}
		if (current < str.length() || allow_empty)
		{
			vec.emplace_back(str.data() + current, str.length() - current);
		}
		return vec;
	}


}