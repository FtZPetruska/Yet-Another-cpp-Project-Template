include_guard()

include(CMakeDependentOption)

if(NOT CMAKE_BUILD_TYPE)
  message(STATUS "No build type specified, defaulting to 'Debug'")
  set(CMAKE_BUILD_TYPE
      "Debug"
      CACHE STRING "Build configuration to use" FORCE)
  set_property(
    CACHE CMAKE_BUILD_TYPE
    PROPERTY STRINGS
             "Debug"
             "Release"
             "MinSizeRel"
             "RelWithDebInfo")
endif()

string(
  COMPARE EQUAL
          "${CMAKE_BUILD_TYPE}"
          "Debug"
          IS_DEBUG)

cmake_dependent_option(
  MYPROJECT_ENABLE_ADDRESS_SANITIZER
  "Enable Address Sanitizer"
  OFF
  "HAVE_ADDRESS_SANITIZER"
  OFF)

cmake_dependent_option(
  MYPROJECT_ENABLE_THREAD_SANITIZER
  "Enable Thread Sanitizer"
  OFF
  "HAVE_THREAD_SANITIZER"
  OFF)

cmake_dependent_option(
  MYPROJECT_ENABLE_MEMORY_SANITIZER
  "Enable Memory Sanitizer"
  OFF
  "HAVE_MEMORY_SANITIZER"
  OFF)

cmake_dependent_option(
  MYPROJECT_ENABLE_UB_SANITIZER
  "Enable Undefined Behaviour Sanitizer"
  OFF
  "HAVE_UB_SANITIZER"
  OFF)

cmake_dependent_option(
  MYPROJECT_ENABLE_LEAK_SANITIZER
  "Enable Leak Sanitizer"
  OFF
  "HAVE_LEAK_SANITIZER"
  OFF)

cmake_dependent_option(
  MYPROJECT_ENABLE_NATIVE_OPTIMISATION
  "Enable non-portable optimisations"
  OFF
  "HAVE_NATIVE_OPTIMISATION"
  OFF)

cmake_dependent_option(
  MYPROJECT_ENABLE_PROFILER
  "Enable profiling"
  OFF
  "HAVE_PROFILER"
  OFF)

cmake_dependent_option(
  MYPROJECT_ENABLE_GCOV
  "Enable GNU Coverage tool"
  OFF
  "HAVE_GCOV"
  OFF)

cmake_dependent_option(
  MYPROJECT_ENABLE_LTO
  "Enable link-time optimisations"
  OFF
  "HAVE_IPO"
  OFF)

cmake_dependent_option(
  MYPROJECT_ENABLE_PIE
  "Enable position-independent code"
  ON
  "CMAKE_CXX_LINK_PIE_SUPPORTED"
  OFF)

cmake_dependent_option(
  MYPROJECT_ENABLE_CCACHE
  "Speedup builds with ccache"
  ON
  "CCACHE_EXECUTABLE"
  OFF)

cmake_dependent_option(
  MYPROJECT_ENABLE_CLANG_TIDY
  "Enable clang-tidy analysis during build"
  ${IS_DEBUG}
  "CLANG_TIDY_EXECUTABLE"
  OFF)

cmake_dependent_option(
  MYPROJECT_ENABLE_CLANG_FORMAT
  "Emable code format check during build"
  ${IS_DEBUG}
  "CLANG_FORMAT_EXECUTABLE"
  OFF)

cmake_dependent_option(
  MYPROJECT_ENABLE_IWYU
  "Emable include-what-you-use during build"
  ${IS_DEBUG}
  "IWYU_EXECUTABLE"
  OFF)

cmake_dependent_option(
  MYPROJECT_ENABLE_DOXYGEN
  "Enable doxygen documentation generation"
  ON
  "DOXYGEN_FOUND"
  OFF)

option(MYPROJECT_ENABLE_TESTS "Enable tests" ${MYPROJECT_IS_TOPLEVEL_PROJECT})

unset(IS_DEBUG)
