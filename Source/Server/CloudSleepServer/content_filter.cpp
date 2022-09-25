#include "content_filter.h"

#include <fstream>
#include <stdexcept>

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

    ContentFilter::ContentFilter(const std::filesystem::path& word_list_filename)
        : trie_tree_()
    {
        std::ifstream word_list_file_stream(word_list_filename);
        if (!word_list_file_stream.is_open())
        {
            throw std::runtime_error("word_list file open failed");
        }

        while (!word_list_file_stream.eof())
        {
            std::string word;
            std::getline(word_list_file_stream, word);
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
