#pragma once
#include <vector>
#include <string_view>

namespace wheat
{

std::vector<std::string_view>
Split(std::string_view str, std::string_view delimiter, bool allow_empty = false);

}