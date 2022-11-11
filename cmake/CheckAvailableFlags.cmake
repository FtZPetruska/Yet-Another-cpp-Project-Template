include_guard()

include(CheckCXXCompilerFlag)
include(CheckLinkerFlag)

macro(check_cl_flags)
  # Sanitizer
  check_cxx_compiler_flag("-fsanitize=address" HAVE_ADDRESS_SANITIZER)

  # Profiling
  check_linker_flag(CXX "/PROFILE" HAVE_PROFILER)
endmacro(check_cl_flags)

macro(check_gnu_flags)
  # Sanitizers
  check_cxx_compiler_flag("-fsanitize=address" HAVE_ADDRESS_SANITIZER)
  check_cxx_compiler_flag("-fsanitize=thread" HAVE_THREAD_SANITIZER)
  check_cxx_compiler_flag("-fsanitize=memory" HAVE_MEMORY_SANITIZER)
  check_cxx_compiler_flag("-fsanitize=undefined" HAVE_UB_SANITIZER)
  check_cxx_compiler_flag("-fsanitize=leak" HAVE_LEAK_SANITIZER)

  # Native optimisations
  check_cxx_compiler_flag("-march=native" HAVE_NATIVE_OPTIMISATION)

  # Profiling
  check_cxx_compiler_flag("-pg" HAVE_PROFILER)

  # Colour diagnostic
  check_cxx_compiler_flag("-fdiagnostics-color" HAVE_COLOURED_DIAGNOSTIC)

  # Coverage
  check_cxx_compiler_flag("-ftest-coverage" HAVE_GCOV)
endmacro(check_gnu_flags)

if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC" OR CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC")
  check_cl_flags()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  check_gnu_flags()
else()
  message(WARNING "Your compiler frontend does not match GCC or MSVC, accepted flags will not be checked.")
endif()

include(CheckIPOSupported)
check_ipo_supported(RESULT HAVE_IPO LANGUAGES C CXX)
if(HAVE_IPO)
  message(STATUS "Compiler supports link-time optimisation")
endif()

include(CheckPIESupported)
check_pie_supported()
if(CMAKE_CXX_LINK_PIE_SUPPORTED)
  message(STATUS "Compiler supports position-independent code")
endif()
