#pragma once
#ifndef CONTENT_FILTER_H_
#define CONTENT_FILTER_H_

#include <string>

#include "trie_tree.h"

namespace wheat
{
    using char_type = char; // UTF-8 string

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

        bool FilterContent(std::basic_string<char_type>& content, char_type replacement) const noexcept;

    private:
        trie_tree::basic_trie_tree<char_type> trie_tree_;

    };

} // namespace wheat

#endif // CONTENT_FILTER_H_
