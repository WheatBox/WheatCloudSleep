#pragma once
#ifndef CONTENT_FILTER_H_
#define CONTENT_FILTER_H_

#include <string>

#include "trie_tree.h"

namespace wheat
{
namespace util
{
    using char_type = char16_t;

    class ContentFilter
    {
    public:
        ContentFilter() = default;
        ~ContentFilter() = default;

        ContentFilter(const std::vector<std::basic_string<char_type>>& word_list);

        ContentFilter(const ContentFilter& l) = default;
        ContentFilter& operator=(const ContentFilter& l) = default;

        ContentFilter(ContentFilter&& r) = default;
        ContentFilter& operator=(ContentFilter&& r) = default;

        bool CheckContent(const std::basic_string<char_type>& content) const noexcept;

        void FilterContent(std::basic_string<char_type>& content, char_type replacement) const noexcept;

    private:
        trie_tree::u16trie_tree trie_tree_;

    };

} // namespace util
} // namespace wheat

#endif // CONTENT_FILTER_H_
