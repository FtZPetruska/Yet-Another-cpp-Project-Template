include_guard()

if(CMAKE_TOOLCHAIN_FILE MATCHES "vcpkg.cmake")
  message(STATUS "vcpkg toolchain was provided -- ${CMAKE_TOOLCHAIN_FILE}")
  return()
endif()

if(DEFINED ENV{VCPKG_ROOT})
  message(STATUS "VCPKG_ROOT is set -- $ENV{VCPKG_ROOT}")
  list(APPEND CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake")
  return()
endif()

message(STATUS "fetching the latest vcpkg from GitHub")

include(FetchContent)

FetchContent_Declare(
  vcpkg
  GIT_REPOSITORY "https://github.com/microsoft/vcpkg.git"
  GIT_TAG "origin/master")

FetchContent_MakeAvailable(vcpkg)

list(APPEND CMAKE_TOOLCHAIN_FILE "${vcpkg_SOURCE_DIR}/scripts/buildsystems/vcpkg.cmake")
