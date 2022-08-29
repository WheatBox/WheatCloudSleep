#pragma once
#include "asio.hpp"
#include <set>

namespace wheat
{

template <typename T>
class VoteCounter
{
public:
    template <typename U>
    bool Agree(U&& u)
    {
        auto it = m_who_refuse.find(std::forward<U>(u));
        if(it != m_who_refuse.end()) {
            m_who_refuse.erase(it);
        }
        return m_who_agree.emplace(std::forward<U>(u)).second;
    }

    template <typename U>
    bool Refuse(U && u)
    {
        auto it = m_who_agree.find(std::forward<U>(u));
        if(it != m_who_agree.end()) {
            m_who_agree.erase(it);
        }
        return m_who_refuse.emplace(std::forward<U>(u)).second;
    }

    std::pair<size_t, size_t> GetVotes() const
    {
        return std::make_pair(m_who_agree.size(), m_who_refuse.size());
    }

    void Clear() {
        m_who_agree.clear();
        m_who_refuse.clear();
    }

private:
    std::set<T> m_who_agree;
    std::set<T> m_who_refuse;
};


}