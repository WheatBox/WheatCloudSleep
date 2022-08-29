#pragma once

#include <set>
#include <string>
#include <chrono>

namespace wheat
{
	namespace blacklist
	{

		class BlackList
		{
		public:
			BlackList() = default;
			~BlackList() = default;

			void AddIpToBlockList(
				const std::string& ip, 
				const std::chrono::minutes& time
			);
			bool IsIpBlocked(const std::string& ip);
			bool IsIpWatched(const std::string& ip);

		private:
			struct BlockIpContext
			{
				std::string ip;
				std::chrono::minutes blocking_period;
				std::chrono::time_point<std::chrono::steady_clock> block_start_time;

				bool operator<(const BlockIpContext& r)
				{
					return ip < r.ip;
				}
			};

			std::set<BlockIpContext> black_list_;
			std::set<BlockIpContext> watch_list_;

		};
	}
} // namespace wheat
