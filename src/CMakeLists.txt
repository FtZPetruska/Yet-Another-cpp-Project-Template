find_package(spdlog CONFIG REQUIRED)

add_library(factorial STATIC factorial.cpp)
target_link_libraries(factorial PRIVATE spdlog::spdlog)
target_include_directories(factorial PUBLIC ${MYPROJECT_PUBLIC_INCLUDE_DIR})
apply_options_to_target(factorial)
