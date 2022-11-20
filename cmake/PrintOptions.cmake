include_guard()

function(print_option OPTION_NAME OPTION_AVAILABILITY)

  if(NOT OPTION_AVAILABILITY)
    set(VALUE "Unavailable")
  else()
    set(VALUE ${${OPTION_NAME}})
  endif()

  if(NOT DEFINED ${OPTION_NAME})
    set(WANTED "Unspecified")
  else()
    set(WANTED "${${OPTION_NAME}}")
  endif()

  message(STATUS "${OPTION_NAME}: ${VALUE} (Wanted: ${WANTED})")
endfunction()

function(print_dependency_management)
  if(MYPROJECT_USE_VCPKG)
    set(DEPENDENCY_MANAGER "VCPKG")
  else()
    set(DEPENDENCY_MANAGER "System packages")
  endif()
  message(STATUS "Dependency management: ${DEPENDENCY_MANAGER}")
endfunction()

function(print_options_summary)
  print_option("MYPROJECT_ENABLE_ADDRESS_SANITIZER" "${HAVE_ADDRESS_SANITIZER}")
  print_option("MYPROJECT_ENABLE_THREAD_SANITIZER" "${HAVE_THREAD_SANITIZER}")
  print_option("MYPROJECT_ENABLE_MEMORY_SANITIZER" "${HAVE_MEMORY_SANITIZER}")
  print_option("MYPROJECT_ENABLE_UB_SANITIZER" "${HAVE_UB_SANITIZER}")
  print_option("MYPROJECT_ENABLE_LEAK_SANITIZER" "${HAVE_LEAK_SANITIZER}")
  print_option("MYPROJECT_ENABLE_NATIVE_OPTIMISATION" "${HAVE_NATIVE_OPTIMISATION}")
  print_option("MYPROJECT_ENABLE_PROFILER" "${HAVE_PROFILER}")
  print_option("MYPROJECT_ENABLE_GCOV" "${HAVE_GCOV}")
  print_option("MYPROJECT_ENABLE_LTO" "${HAVE_IPO}")
  print_option("MYPROJECT_ENABLE_PIE" "${CMAKE_CXX_LINK_PIE_SUPPORTED}")
  print_option("MYPROJECT_ENABLE_CCACHE" "${CCACHE_EXECUTABLE}")
  print_option("MYPROJECT_ENABLE_CLANG_TIDY" "${CLANG_TIDY_EXECUTABLE}")
  print_option("MYPROJECT_ENABLE_CLANG_FORMAT" "${CLANG_FORMAT_EXECUTABLE}")
  print_option("MYPROJECT_ENABLE_IWYU" "${IWYU_EXECUTABLE}")
  print_option("MYPROJECT_ENABLE_WARNINGS_AS_ERROR" "${HAVE_WARNINGS_AS_ERROR}")
  message(STATUS "MYPROJECT_ENABLE_TESTS: ${MYPROJECT_ENABLE_TESTS}")
  message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
  print_dependency_management()
endfunction(print_options_summary)
