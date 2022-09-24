#pragma once

#include <filesystem>
#include <string_view>
#include <vector>

namespace wheat::common
{

std::vector<std::string_view>
Split(std::string_view str, std::string_view delimiter, bool allow_empty = false);

std::filesystem::path 
GetFileParentPath(std::filesystem::path file_path);

std::filesystem::path 
GetFileCanonicalPath(std::filesystem::path file_path);

}