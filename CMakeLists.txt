cmake_minimum_required(VERSION 3.14.0)

include("${CMAKE_CURRENT_LIST_DIR}/cmake/ProjectSetup.cmake")

setup_vcpkg()

project(
  yet_naother_cpp_project_template
  VERSION 0.1.0
  LANGUAGES C CXX)

string(
  COMPARE EQUAL
          "${CMAKE_SOURCE_DIR}"
          "${PROJECT_SOURCE_DIR}"
          MYPROJECT_IS_TOPLEVEL_PROJECT)

setup_project()

set(MYPROJECT_PUBLIC_INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/include")

add_subdirectory(src)

if(MYPROJECT_ENABLE_TEST)
  enable_testing()
  add_subdirectory(test)
endif()
