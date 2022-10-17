#pragma once
#ifndef WHEAT_ERROR_CODE_H_
#define WHEAT_ERROR_CODE_H_

#include <cstdint>

namespace wheat
{
enum class WheatErrorCode : std::uint64_t
{
    Start = 1001,

    InvalidName = 1001,
    InvalidScene = 1002
};

//TODO(B1aN) Add enum to string

} // namespace wheat

#endif // WHEAT_ERROR_CODE_H_
