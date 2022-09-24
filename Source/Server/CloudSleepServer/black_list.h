#pragma once

#include <chrono>
#include <map>
#include <string>

#include <asio.hpp>

namespace wheat
{
namespace blacklist
{

using Minutes = std::chrono::minutes;

class BlackList
{
public:
	//黑名单应该是整个服务器共享的，所以这里设计成单例 
	static BlackList& Instance();

	void SetExecutor(asio::any_io_executor executor);

	/* 把ip加入黑名单，黑名单初始时长为time，规则如下：
	 * 在黑名单时期内，IsIpBlocked(ip)返回true，具体怎么处理看上层操作(现在是不允许加入房间)
	 * 如果ip不在观察期，则黑名单等待时长为time，到期之后从黑名单移除，并加入观察列表(时长是黑名单等待时长的两倍)，到期之后从观察列表里移除
	 * 如果ip已经处于观察期，则本次黑名单等待时长为max(本次黑名单时长,上一次黑名单等待时长的两倍)
	 */
	void AddIpToBlockList(
		const std::string& ip,
		const Minutes& time
	);

	void AddIpToBlockList(const std::string& ip);

	bool IsIpBlocked(const std::string& ip) const
	{
		return m_black_list.contains(ip);
	}

	bool IsIpWatched(const std::string& ip) const
	{
		return m_watch_list.contains(ip);
	}

private:
	asio::awaitable<void> AddIpToBlockListAsync(std::string ip, Minutes time);

	struct WatchIpContext
	{
		asio::steady_timer* previous_timer;
		Minutes privios_block_time;
	};

	explicit BlackList() = default;

private:
	asio::any_io_executor m_executor;
	std::map<std::string, asio::steady_timer*> m_black_list;
	std::map<std::string, WatchIpContext> m_watch_list;
};

}
} // namespace wheat
