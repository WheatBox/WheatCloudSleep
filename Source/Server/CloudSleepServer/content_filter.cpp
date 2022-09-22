#include "content_filter.h"

namespace wheat
{
namespace util
{
    ContentFilter::ContentFilter(const std::vector<std::u16string>& word_list)
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

    void ContentFilter::FilterContent(std::basic_string<char_type>& content, char_type replacement) const noexcept
    {
        auto [word_off, word_len] = trie_tree_.find_in(content);

        std::fill_n(content.begin() + word_off, word_len, replacement);
    }

} // namespace util
} // namespace wheat
