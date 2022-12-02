#include "content_filter.h"

#include <fstream>
#include <stdexcept>

namespace wheat
{
    ContentFilter::ContentFilter(const std::vector<std::basic_string<char_type>>& word_list, const std::vector<std::basic_string<char_type>> & stop_char_list)
        : trie_tree_() {
        for (const auto& word : word_list)
        {
            trie_tree_.add_word(word);
        }

        trie_tree_.add_stop_char(" ");

        for (const auto& stop_char : stop_char_list)
        {
            trie_tree_.add_stop_char(stop_char.c_str());
        }
    }

    ContentFilter::ContentFilter(const std::filesystem::path& word_list_filename, const std::filesystem::path & stop_char_list_filename)
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
            word_list_file_stream >> word;
            trie_tree_.add_word(word);
        }

        trie_tree_.add_stop_char(" ");

        std::ifstream stop_char_list_file_stream(stop_char_list_filename);
        if (!stop_char_list_file_stream.is_open())
        {
            throw std::runtime_error("stop_char_list file open failed");
        }

        while (!stop_char_list_file_stream.eof())
        {
            std::string stop_char;
            stop_char_list_file_stream >> stop_char;
            trie_tree_.add_stop_char(stop_char.c_str());
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

    void ContentFilter::SetSuperMode(bool enable) {
        trie_tree_.bSuperMode = enable;
    }

} // namespace wheat
