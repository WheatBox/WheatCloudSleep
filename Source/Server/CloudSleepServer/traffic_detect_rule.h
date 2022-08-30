#include "detect_rule.h"

namespace wheat
{
	namespace detect_rule
	{
		class TrafficDetectRule : public RuleBase
		{
		public:
			TrafficDetectRule() = default;
			~TrafficDetectRule() = default;


			/// <summary>
			/// Detect if the rule is triggered.
			/// </summary>
			/// <param name="data">The data rule need</param>
			/// <returns>Return true means rule is triggered, othersise is not triggered.</returns>
			bool Detect(const RuleDetectData& data) override
			{
				return false;
			}

			/// <summary>
			/// Return the state of the rule. 
			/// This is an optional interface.
			/// Because Detect() can obtain the state of a rule.
			/// </summary>
			/// <returns>If rule has been triggered return true.</returns>
			virtual bool IsTriggered() const noexcept override
			{
				return false;
			}

			/// <summary>
			/// Reset the state of the rule.
			/// </summary>
			void Reset() override
			{
				return;
			}
		};
	} // namespace detec_rule
}// namespace wheat
