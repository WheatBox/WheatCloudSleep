#include "black_list.h"

#include "config.h"
#include "logger.h"

namespace wheat
{
namespace blacklist
{

BlackList& BlackList::Instance()
{
	static BlackList g_black_list;
	return g_black_list;
}

void BlackList::SetExecutor(asio::any_io_executor executor)
{
	m_executor = std::move(executor);
}

void BlackList::AddIpToBlockList(
	const std::string& ip,
	const Minutes& time
)
{
	asio::co_spawn(
		m_executor,
		[this, ip, time]() mutable {
			return AddIpToBlockListAsync(std::move(ip), std::move(time));
		},
		asio::detached);
}

void BlackList::AddIpToBlockList(const std::string& ip)
{
	AddIpToBlockList(ip, Minutes(Config::Instance().block_period_m));
}

asio::awaitable<void> BlackList::AddIpToBlockListAsync(std::string ip, Minutes time)
{
	auto block_time = std::min(time, Minutes(Config::Instance().max_block_period_m));
	if (m_black_list.contains(ip))
	{
		LOG_INFO("%s, ip:%s is in black list", __func__, ip.c_str());
		co_return;
	}

	//观察期惩罚时长翻倍 
	if (auto iter = m_watch_list.find(ip); iter != m_watch_list.end())
	{
		const auto& watch_context = iter->second;
		block_time = std::max(block_time, watch_context.privios_block_time * 2);
		block_time = std::min(block_time, Minutes(Config::Instance().max_block_period_m));
		LOG_INFO("%s, ip:%s is in watch list, block minutes:%d", __func__, ip.c_str(), block_time.count());
	}
	else
	{
		LOG_INFO("%s, ip:%s, block minutes:%d", __func__, ip.c_str(), block_time.count());
	}

	//等待黑名单到期之后从黑名单列表里移除 
	asio::steady_timer block_timer(m_executor, block_time);
	m_black_list.emplace(ip, &block_timer);
	co_await block_timer.async_wait(asio::use_awaitable);
	m_black_list.erase(ip);

	auto watch_time = std::min(block_time * 2, Minutes(Config::Instance().max_watch_period_m));
	LOG_INFO("%s, ip:%s block time over, start watch, watch minutes:%d", __func__, ip.c_str(), watch_time.count());

	try
	{
		//如果当前已经在观察列表里了，就先把上一次观察的定时器取消(否则上一次到期之后会从观察列表里移除，影响本次观察时间)  
		auto iter = m_watch_list.find(ip);
		if (iter != m_watch_list.end())
		{
			LOG_INFO("%s, already in watch, cancel previous timer", __func__);
			iter->second.previous_timer->cancel();
			m_watch_list.erase(iter);
		}

		//等待观察到期之后从观察列表里移除 
		asio::steady_timer watch_timer(m_executor, watch_time);
		m_watch_list.emplace(ip, WatchIpContext{ &watch_timer, block_time });
		co_await watch_timer.async_wait(asio::use_awaitable);

		m_watch_list.erase(ip);
		LOG_INFO("%s, ip:%s watch time over", __func__, ip.c_str());
	}
	catch (const std::exception&)
	{
		LOG_INFO("%s, ip:%s, watch timer be cancled, maybe a new watch start", __func__, ip.c_str());
	}
}


}
}