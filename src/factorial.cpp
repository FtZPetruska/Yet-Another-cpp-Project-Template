#include "factorial.hpp"
#include <spdlog/spdlog.h>

namespace MyProject {

static bool wouldOverflow(std::uint8_t n) {
  static constexpr std::uint8_t UPPER_LIMIT{23};
  return n >= UPPER_LIMIT;
}

std::uint64_t factorial(std::uint8_t n) {
  if (wouldOverflow(n)) {
    spdlog::warn("Factorials above 22 will overflow.");
    return 0;
  }

  std::uint64_t result = 1;
  for (std::uint8_t num = 2; num <= n; ++num) {
    result *= num;
  }
  return result;
}

}; // namespace MyProject
