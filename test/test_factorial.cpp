#include <catch2/catch_test_macros.hpp>
#include <cstdint>
#include <limits>

#include "factorial.hpp"

using namespace MyProject;

TEST_CASE("Base case", "[factorial]") {
  REQUIRE(factorial(0) == 1);
}

TEST_CASE("Regular cases", "[factorial]") {
  REQUIRE(factorial(1) == 1);
  REQUIRE(factorial(2) == 2);
  REQUIRE(factorial(3) == 6);
  REQUIRE(factorial(10) == 3'628'800);
}

TEST_CASE("Maximum factorial before overflow", "[factorial]") {
  REQUIRE(factorial(22) == 17'196'083'355'034'583'040ULL);
}

TEST_CASE("Overflow", "[factorial]") {
  REQUIRE(factorial(23) == 0);
  REQUIRE(factorial(100) == 0);
  REQUIRE(factorial(200) == 0);
  REQUIRE(factorial(std::numeric_limits<std::uint8_t>::max()) == 0);
}
