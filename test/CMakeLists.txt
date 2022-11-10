find_package(Catch2 3)

add_executable(test_factorial test_factorial.cpp)
target_link_libraries(test_factorial PRIVATE Catch2::Catch2WithMain factorial)
apply_options_to_target(test_factorial)

include(Catch)
catch_discover_tests(test_factorial)
