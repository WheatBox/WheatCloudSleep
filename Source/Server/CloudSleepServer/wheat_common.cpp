#include "wheat_common.h"

namespace wheat::common
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


std::filesystem::path 
GetFileParentPath(std::filesystem::path file_path)
{
    try
    {
        return std::filesystem::weakly_canonical(std::filesystem::path(file_path)).parent_path();
    }
    catch (...)
    {
        return std::filesystem::path();
    }
}

std::filesystem::path
GetFileCanonicalPath(std::filesystem::path file_path)
{
    if (file_path.empty()) return "";

    try
    {
        return std::filesystem::weakly_canonical(file_path);
    }
    catch (...)
    {
        return std::filesystem::path();
    }
}

}