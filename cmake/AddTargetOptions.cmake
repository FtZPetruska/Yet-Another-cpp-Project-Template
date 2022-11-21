include_guard()

function(set_target_options _TARGET)
  set_target_properties(
    ${_TARGET}
    PROPERTIES C_STANDARD 11
               C_STANDARD_REQUIRED OFF
               C_EXTENSIONS OFF
               CXX_STANDARD 20
               CXX_STANDARD_REQUIRED ON
               CXX_EXTENSIONS OFF)

  add_sanitizer_to_target(${_TARGET})

  if(MYPROJECT_ENABLE_NATIVE_OPTIMISATION AND HAVE_NATIVE_OPTIMISATION)
    target_compile_options(${_TARGET} PRIVATE "-march=native")
  endif()

  if(MYPROJECT_ENABLE_PROFILER AND HAVE_PROFILER)
    if(MSVC)
      target_link_options(${_TARGET} PRIVATE "/PROFILE")
    else()
      target_compile_options(${_TARGET} PRIVATE "-pg")
      target_link_options(${_TARGET} PRIVATE "-pg")
    endif()
  endif()

  if(MYPROJECT_ENABLE_GCOV AND HAVE_GCOV)
    target_compile_options(${_TARGET} PUBLIC "--coverage")
    target_link_options(${_TARGET} PUBLIC "--coverage")
  endif()

  if(MYPROJECT_ENABLE_LTO AND HAVE_IPO)
    set_target_properties(${_TARGET} PROPERTIES INTERPROCEDURAL_OPTIMIZATION ${MYPROJECT_ENABLE_LTO})
  endif()

  if(MYPROJECT_ENABLE_PIE AND CMAKE_CXX_LINK_PIE_SUPPORTED)
    set_target_properties(${_TARGET} PROPERTIES POSITION_INDEPENDENT_CODE ${MYPROJECT_ENABLE_PIE})
  endif()

  if(MYPROJECT_ENABLE_CCACHE AND CCACHE_EXECUTABLE)
    set_target_properties(${_TARGET} PROPERTIES C_COMPILER_LAUNCHER ${CCACHE_EXECUTABLE} CXX_COMPILER_LAUNCHER
                                                                                         ${CCACHE_EXECUTABLE})
  endif()

  if(MYPROJECT_ENABLE_CLANG_TIDY AND CLANG_TIDY_EXECUTABLE)
    set_target_properties(
      ${_TARGET} PROPERTIES C_CLANG_TIDY "${CLANG_TIDY_EXECUTABLE};-extra-arg=-Wno-unknown-warning-option"
                            CXX_CLANG_TIDY "${CLANG_TIDY_EXECUTABLE};-extra-arg=-Wno-unknown-warning-option")
  endif()

  if(MYPROJECT_ENABLE_CLANG_FORMAT AND CLANG_FORMAT_EXECUTABLE)
    get_target_property(SOURCES ${_TARGET} SOURCES)
    list(TRANSFORM SOURCES PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/")
    add_custom_command(
      TARGET ${_TARGET}
      PRE_BUILD
      COMMAND ${CLANG_FORMAT_EXECUTABLE} ARGS "--Werror" "--dry-run" "--verbose" ${SOURCES})
  endif()

  if(MYPROJECT_ENABLE_IWYU AND IWYU_EXECUTABLE)
    set_target_properties(${_TARGET} PROPERTIES C_INCLUDE_WHAT_YOU_USE ${IWYU_EXECUTABLE} CXX_INCLUDE_WHAT_YOU_USE
                                                                                          ${IWYU_EXECUTABLE})
  endif()
endfunction(set_target_options)
