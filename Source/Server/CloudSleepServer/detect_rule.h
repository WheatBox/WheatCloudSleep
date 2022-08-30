#pragma once

#include <cstdint>
#include <cstddef>
#include <chrono>

namespace wheat
{
	namespace detect_rule
	{
		/// <summary>
		/// The data feed in rules.
		/// </summary>
		struct RuleDetectData
		{
			std::size_t data_size;
		};

		/// <summary>
		/// The interface of rule. All the rules should implement this interface.
		/// </summary>
		class RuleBase
		{
		public:
			virtual ~RuleBase() = default;

			// disable copy constructor and copy assign.

			/// <summary>
			/// Detect if the rule is triggered.
			/// </summary>
			/// <param name="data">The data rule need</param>
			/// <returns>Return true means rule is triggered, othersise is not triggered.</returns>
			virtual bool Detect(const RuleDetectData& data) = 0;

			/// <summary>
			/// Return the state of the rule. 
			/// This is an optional interface.
			/// Because Detect() can obtain the state of a rule.
			/// </summary>
			/// <returns>If rule has been triggered return true.</returns>
			virtual bool IsTriggered() const noexcept
			{
				return false;
			}

			/// <summary>
			/// Reset the state of the rule.
			/// </summary>
			virtual void Reset() = 0;
		};
	}
} // namespace wheat
