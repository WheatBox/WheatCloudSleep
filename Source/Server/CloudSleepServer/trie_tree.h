#pragma once
#ifndef TRIE_TREE_HPP_
#define TRIE_TREE_HPP_

#include <concepts>
#include <map>
#include <memory>
//#include <set>
#include <unordered_set>
#include <stack>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

#include "utf8tools.h"

namespace trie_tree
{
    namespace internal
    {
        template <typename _CType>
        concept char_type = std::same_as< _CType, char>
            || std::same_as<_CType, wchar_t>
            || std::same_as<_CType, char8_t>
            || std::same_as<_CType, char16_t>
            || std::same_as<_CType, char32_t>;
    } // namespace internal

    template <typename _CType>
    requires internal::char_type<_CType>
    class basic_trie_tree
    {
    private:
        struct trie_tree_node
        {
            std::map<_CType, trie_tree_node*> child_nodes_;
            bool word_end;

            trie_tree_node()
                : child_nodes_()
                , word_end(false)
            {}

            void add_child(_CType ch, trie_tree_node* child_node)
            {
                child_nodes_.emplace(ch, child_node);
            }

            trie_tree_node* get_child(_CType ch) const noexcept
            {
                auto iter = child_nodes_.find(ch);
                return child_nodes_.end() == iter ? nullptr : iter->second;
            }
        };

    public:
        basic_trie_tree();

        ~basic_trie_tree();

        basic_trie_tree(const basic_trie_tree& lvalue);

        basic_trie_tree& operator=(const basic_trie_tree& lvalue);

        basic_trie_tree(basic_trie_tree&& rvalue) noexcept;

        basic_trie_tree& operator=(basic_trie_tree&& rvalue) noexcept;

        void add_word(const _CType* word, std::size_t len);

        void add_word(const std::basic_string<_CType>& word);

        void erase_word(const _CType* word, std::size_t len);

        void erase_word(const std::basic_string<_CType>& word);

        void add_stop_char(const _CType * stop_char);

        void erase_stop_char(const _CType * stop_char);

        /*void add_stop_chars(const std::basic_string<_CType>& stop_chars)
        {
            for (_CType stop_char : stop_chars)
            {
                add_stop_char(stop_char);
            }
        }

        void erase_stop_chars(const std::basic_string<_CType>& stop_chars)
        {
            for (_CType stop_char : stop_chars)
            {
                erase_stop_char(stop_char);
            }
        }*/

        std::pair<std::size_t, std::size_t> find_in(const _CType* str, std::size_t len) const noexcept;

        std::pair<std::size_t, std::size_t> find_in(const std::basic_string<_CType>& str) const noexcept;

        std::pair<std::size_t, std::size_t> find_in_string_view(const std::basic_string_view<_CType>& str_view) const noexcept;

    private:
        void copy_from_recursively(const trie_tree_node* src);

        void copy_node_recursively(trie_tree_node* dst, const trie_tree_node* src);

        trie_tree_node* get_or_add_child_node(trie_tree_node* node, _CType ch);

        std::size_t find_word_at_start(const _CType* sz, std::size_t len) const noexcept;

        void delete_node_recursively(trie_tree_node* node);

        trie_tree_node* root_;

        std::unordered_set<std::basic_string<_CType>> stop_charset_; // = { ",", ".", "[]", "*", "，", "。" };
        std::size_t stop_charMaxLen = 0; // 3; // 单个 stop_char 的最长长度，该变量会在 add_stop_char() 里随着停顿词添加而自动更新

    public:
        // 超级模式，将一切字符都视为停止词，例如："傻先帝创业未半而中道崩殂……（插入一篇出师表）逼"也会被屏蔽掉，这种模式错杀率比较高，但是屏蔽成功率也更高
        // 默认为 true
        bool bSuperMode = true;
    };

    using trie_tree		= basic_trie_tree<char>;
    using wtrie_tree	= basic_trie_tree<wchar_t>;
    using u8trie_tree	= basic_trie_tree<char8_t>;
    using u16trie_tree	= basic_trie_tree<char16_t>;
    using u32trie_tree	= basic_trie_tree<char32_t>;

    template <typename _CType>
    std::unique_ptr<basic_trie_tree<_CType>> make_trie_tree(const std::vector<std::basic_string<_CType>>& word_list)
    {
        std::unique_ptr<basic_trie_tree<_CType>> trie_tree = std::make_unique<basic_trie_tree<_CType>>();

        for (const std::string& word : word_list)
        {
            trie_tree->add_word(word);
        }

        return trie_tree;
    }


#define _BASIC_TRIE_TREE_FUNC_ \
	template<typename _CType>\
		requires internal::char_type<_CType>

	_BASIC_TRIE_TREE_FUNC_
		basic_trie_tree<_CType>::basic_trie_tree()
		: root_(new trie_tree_node())
	{}

	_BASIC_TRIE_TREE_FUNC_
		basic_trie_tree<_CType>::~basic_trie_tree()
	{
		delete_node_recursively(root_);
	}

	_BASIC_TRIE_TREE_FUNC_
		basic_trie_tree<_CType>::basic_trie_tree(const basic_trie_tree & lvalue)
		: root_(new trie_tree_node())
	{
		copy_from_recursively(lvalue.root_);
	}

	_BASIC_TRIE_TREE_FUNC_
		basic_trie_tree<_CType>& basic_trie_tree<_CType>::operator=(const basic_trie_tree& lvalue)
	{
		if (this != &lvalue)
		{
			copy_from_recursively(lvalue.root_);
		}
		return *this;
	}

	_BASIC_TRIE_TREE_FUNC_
		basic_trie_tree<_CType>::basic_trie_tree(basic_trie_tree&& rvalue) noexcept
		: root_(nullptr)
	{
		std::swap(root_, rvalue.root_);
	}

	_BASIC_TRIE_TREE_FUNC_
		basic_trie_tree<_CType>& basic_trie_tree<_CType>::operator=(basic_trie_tree&& rvalue) noexcept
	{
		std::swap(root_, rvalue.root_);
	}

	_BASIC_TRIE_TREE_FUNC_
		void basic_trie_tree<_CType>::add_word(const _CType* word, std::size_t len)
	{
		trie_tree_node* cur_node = root_;
		for (std::size_t i = 0; i < len; ++i)
		{
			cur_node = get_or_add_child_node(cur_node, word[i]);
	}
		cur_node->word_end = true;
}

	_BASIC_TRIE_TREE_FUNC_
		void basic_trie_tree<_CType>::add_word(const std::basic_string<_CType>& word)
	{
		add_word(word.c_str(), word.length());
	}

	_BASIC_TRIE_TREE_FUNC_
		void basic_trie_tree<_CType>::erase_word(const _CType* word, std::size_t len)
	{
		std::stack<trie_tree_node*> walked_empty_nodes;
		walked_empty_nodes.push(root_); // push root node
		trie_tree_node* cur_node = root_;
		for (std::size_t i = 0; i < len; ++i)
		{
			auto iter = cur_node->child_nodes_.find(word[i]);
			if (iter == cur_node->child_nodes_.end())
			{
				// word not exist
				return;
			}
			cur_node = iter->second;
			walked_empty_nodes.push(cur_node);
		}

		trie_tree_node* end_node = walked_empty_nodes.top();
		// not a word
		if (!end_node->word_end)
		{
			return;
		}

		// check if there is an empty node at least
		if (!end_node->child_nodes_.empty())
		{
			end_node->word_end = false;
			return;
		}

		walked_empty_nodes.pop();
		// earse empty nodes
		for (std::size_t i = 1; i <= len; ++i)
		{
			trie_tree_node* tree_node = walked_empty_nodes.top();
			// extract node from child nodes
			auto node = tree_node->child_nodes_.extract(word[len - i]);
			// delete child node
			delete node.mapped();
			if (!tree_node->child_nodes_.empty())
			{
				break;
			}
			walked_empty_nodes.pop();
		}
	}

	_BASIC_TRIE_TREE_FUNC_
		void basic_trie_tree<_CType>::erase_word(const std::basic_string<_CType>& word)
	{
		erase_word(word.c_str(), word.length());
	}

	_BASIC_TRIE_TREE_FUNC_
		void basic_trie_tree<_CType>::add_stop_char(const _CType * stop_char)
	{
		stop_charset_.emplace(std::basic_string<_CType>(stop_char));

		std::size_t len = strlen(stop_char);
		if(len > stop_charMaxLen) {
			stop_charMaxLen = len;
		}
	}

	_BASIC_TRIE_TREE_FUNC_
		void basic_trie_tree<_CType>::erase_stop_char(const _CType * stop_char)
	{
		stop_charset_.erase(stop_char);
	}

	_BASIC_TRIE_TREE_FUNC_
		std::pair<std::size_t, std::size_t> basic_trie_tree<_CType>::find_in(const _CType* str, std::size_t len) const noexcept
	{
		std::size_t word_offset = 0;
		std::size_t word_len = 0;

		for (std::size_t i = 0; i < len; ++i)
		{
			word_len = find_word_at_start(&str[i], len - i);
			if (word_len != 0)
			{
				word_offset = i;
				break;
			}
		}

		if (word_len != 0)
		{
			return { word_offset, word_len };
		}
		else
		{
			return { 0, 0 };
		}
	}

	_BASIC_TRIE_TREE_FUNC_
		std::pair<std::size_t, std::size_t> basic_trie_tree<_CType>::find_in(const std::basic_string<_CType>& str) const noexcept
	{
		return find_in(str.c_str(), str.length());
	}

	_BASIC_TRIE_TREE_FUNC_
		std::pair<std::size_t, std::size_t> basic_trie_tree<_CType>::find_in_string_view(const std::basic_string_view<_CType>& str_view) const noexcept
	{
		return find_in(str_view.data(), str_view.length());
	}

	_BASIC_TRIE_TREE_FUNC_
		void basic_trie_tree<_CType>::copy_from_recursively(const trie_tree_node* src)
	{
		copy_node_recursively(root_, src);
	}

	_BASIC_TRIE_TREE_FUNC_
		void basic_trie_tree<_CType>::copy_node_recursively(trie_tree_node* dst, const trie_tree_node* src)
	{
		*dst = *src;
		for (auto& [ch, child_node] : dst->child_nodes_)
		{
			child_node = new trie_tree_node();
			copy_node_recursively(child_node, src->get_child(ch));
		}
	}

	_BASIC_TRIE_TREE_FUNC_
		basic_trie_tree<_CType>::trie_tree_node* basic_trie_tree<_CType>::get_or_add_child_node(trie_tree_node* node, _CType ch)
	{
		if (trie_tree_node* child_node = node->get_child(ch))
		{
			return child_node;
		}
		else
		{
			trie_tree_node* new_node = new trie_tree_node();
			node->add_child(ch, new_node);
			return new_node;
		}
	}

	_BASIC_TRIE_TREE_FUNC_
		std::size_t basic_trie_tree<_CType>::find_word_at_start(const _CType* sz, std::size_t len) const noexcept
	{
		trie_tree_node* cur_node = root_;
		std::size_t last_word_len = 0;
		std::size_t word_len = 0;

		std::basic_string<_CType> str = sz;

		for(std::size_t i = 0; i < str.length(); i++) {
			if(str[i] >= 'A' && str[i] <= 'Z') {
				str[i] += 32;
			}
		}

		//if (stop_charset_.find(str[0]) != stop_charset_.end())
		//{
		//    // find stop char, skip search
		//    return 0;
		//}

		std::size_t iTemp = 0;
		std::size_t wordLenTemp = 0;
		trie_tree_node * currentNodeTemp = cur_node;

		bool _GodDamnEveryThingIsAllFineButIFixedBugsAllOfTodayBeginFromTwelveToTwentyThreeOClockAndIDontKnowHowToNameThisVariableButICanTellYouThisBoolMeansWhetherAllBytesOfAnySensitiveWordHasBeenFoundWaitASecondCanThisVariableBeCompliedWellIDontKnowLetsJustTakeATryOhOneMoreThingThisVariableIsNotWrotenByWheatBoxEhhhYepImVerySure = false; // 是否找到过任意一个敏感词的所有字节
		bool & booltemp = _GodDamnEveryThingIsAllFineButIFixedBugsAllOfTodayBeginFromTwelveToTwentyThreeOClockAndIDontKnowHowToNameThisVariableButICanTellYouThisBoolMeansWhetherAllBytesOfAnySensitiveWordHasBeenFoundWaitASecondCanThisVariableBeCompliedWellIDontKnowLetsJustTakeATryOhOneMoreThingThisVariableIsNotWrotenByWheatBoxEhhhYepImVerySure; // 多此亿举的引用，但是很酷
		bool bFoundBeginChar = false;

		for (std::size_t i = 0; i < len; ++i)
		{
			if(utf8tools::GetUtf8BytesLen(str[i]) > 0) {
				iTemp = i;
				wordLenTemp = word_len;
				currentNodeTemp = cur_node;

				if(bFoundBeginChar) {
					booltemp = true;
				}

				bFoundBeginChar = true;
			}

			if (trie_tree_node* child_node = cur_node->get_child(str[i]))
			{
				++word_len;
				cur_node = child_node;
				if (true == cur_node->word_end)
				{
					last_word_len = word_len;
				}
			} else {
				if(booltemp == false) {
					break;
				}

				bool stop_charFound = false;

				std::size_t j = stop_charMaxLen;

				int _byteLenTemp = utf8tools::GetUtf8BytesLen(str[iTemp]);
				if(_byteLenTemp > 0 && bSuperMode) { // 如果超级模式开启
					stop_charFound = true;

					j = static_cast<std::size_t>(_byteLenTemp);
				}
				else // 如果超级模式关闭
				{
					for(; j >= 1; j--) {
						if(str[i] == '*') {
							j = 1;
							stop_charFound = true;
							break;
						} else
							if (stop_charset_.find(str.substr(iTemp, j)) != stop_charset_.end()) {
								stop_charFound = true;
								break;
							}
					}
				}

				if(stop_charFound) {
					// find stop char
					i = iTemp;
					word_len = wordLenTemp;
					cur_node = currentNodeTemp;

					i += j - 1;
					word_len += j;

				} else {
					// if(!stop_charFound) { // 既没有敏感词，也没有停止词了，那么就结束循环
					break;
				}
			}
		}

		return last_word_len;
	}

	_BASIC_TRIE_TREE_FUNC_
		void basic_trie_tree<_CType>::delete_node_recursively(trie_tree_node* node)
	{
		for (auto& [_, node] : node->child_nodes_)
		{
			delete_node_recursively(node);
		}
		delete node;
	}

#undef _BASIC_TRIE_TREE_FUNC_


} // namespace trie_tree

#ifdef UNIT_TEST
void trie_tree_unit_test()
{
    std::vector<std::string> word_dict;
    word_dict.push_back("test");
    word_dict.push_back("test2");

    std::unique_ptr test_tree = trie_tree::make_trie_tree(word_dict);

    trie_tree::trie_tree tree;

    tree.add_word("fuck");
    tree.add_word("shit");
    tree.add_word("bitch");
    tree.add_word("motherfucker");
    tree.add_word("fucker");

    auto [off1, len1] = tree.find_in("fuck you");
    auto [off2, len2] = tree.find_in("you motherfucker");
    auto [off3, len3] = tree.find_in("mother fucker");
    auto [off4, len4] = tree.find_in("go fuck you mom");

    auto [off5, len5] = tree.find_in_string_view("go fuck you self");

    trie_tree::trie_tree copy_assigned_tree;
    copy_assigned_tree = tree;
    copy_assigned_tree.add_word("assigned");

    auto [off6, len6] = copy_assigned_tree.find_in("copy assigned");
    auto [off7, len7] = tree.find_in("copy assigned");

    trie_tree::trie_tree copy_constructed_tree(tree);
    copy_assigned_tree.add_word("constructed");

    auto [off8, len8] = copy_assigned_tree.find_in("copy constructed");
    auto [off9, len9] = tree.find_in("copy constructed");

    tree.erase_word("shit");

    auto [off10, len10] = tree.find_in("bull shit");
    auto [off11, len11] = tree.find_in("fuck you");

    tree.erase_word("fuck");

    auto [off12, len12] = tree.find_in("bull shit");
    auto [off13, len13] = tree.find_in("fuck you");

    tree.add_stop_char('*');

    auto [off14, len14] = tree.find_in("fucking b*i*t*c*h !!!!");
}
#endif // UNIT_TEST

#endif // TRIE_TREE_HPP_
