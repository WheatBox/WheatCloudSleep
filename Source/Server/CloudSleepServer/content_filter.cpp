#include "content_filter.h"

namespace wheat
{
    ContentFilter::ContentFilter(const std::vector<std::basic_string<char_type>>& word_list)
        : trie_tree_()
    {
        for (const auto& word : word_list)
        {
            trie_tree_.add_word(word);
        }
    }

    bool ContentFilter::CheckContent(const std::basic_string<char_type>& content) const noexcept
    {
        auto [word_off, word_len] = trie_tree_.find_in(content);
        return word_len == 0; // check pass, do not need filter
    }

    bool ContentFilter::FilterContent(std::basic_string<char_type>& content, char_type replacement) const noexcept
    {
        auto [word_off, word_len] = trie_tree_.find_in(content);

        if (word_len != 0)
        {
            std::fill_n(content.begin() + word_off, word_len, replacement);
            return true;
        }
        else
        {
            return false;
        }
    }

} // namespace wheat
