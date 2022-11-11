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

  if(MYPROJECT_ENABLE_ADDRESS_SANITIZER AND HAVE_ADDRESS_SANITIZER)
    list(APPEND ENABLED_SANITIZERS "address")
    message(WARNING "All dependencies must be compiled with address sanitizer enabled.")
  endif()

  if(MYPROJECT_ENABLE_THREAD_SANITIZER AND HAVE_THREAD_SANITIZER)
    list(APPEND ENABLED_SANITIZERS "thread")
  endif()

  if(MYPROJECT_ENABLE_MEMORY_SANITIZER AND HAVE_MEMORY_SANITIZER)
    list(APPEND ENABLED_SANITIZERS "memory")
  endif()

  if(MYPROJECT_ENABLE_UB_SANITIZER AND HAVE_UB_SANITIZER)
    list(APPEND ENABLED_SANITIZERS "undefined")
    message(WARNING "UBSAN will fail to link if you have statically linked dependencies.")
  endif()

  if(MYPROJECT_ENABLE_LEAK_SANITIZER AND HAVE_LEAK_SANITIZER)
    list(APPEND ENABLED_SANITIZERS "leak")
  endif()

  if("thread" IN_LIST ENABLED_SANITIZERS AND ("address" IN_LIST ENABLED_SANITIZERS OR "leak" IN_LIST ENABLED_SANITIZERS
                                             ))
    message(FATAL_ERROR "Thread sanitizer is not compatible with Address and Leak sanitizers")
  endif()

  if("memory" IN_LIST ENABLED_SANITIZERS
     AND ("address" IN_LIST SANITIZERS
          OR "thread" IN_LIST SANITIZERS
          OR "leak" IN_LIST SANITIZERS))
    message(FATAL_ERROR "Memory sanitizer is not compatible with Address, Leak, and Thread sanitizers")
  endif()

  if(ENABLED_SANITIZERS)
    list(
      JOIN
      ENABLED_SANITIZERS
      ","
      LIST_OF_SANITIZERS)

    if(MSVC)
      target_compile_options(${_TARGET} PUBLIC "-fsanitize=${LIST_OF_SANITIZERS}" "/Zi")
      target_link_options(${_TARGET} PUBLIC "-incremental:no")
    else()
      target_compile_options(${_TARGET} PUBLIC "-fsanitize=${LIST_OF_SANITIZERS}")
      target_link_options(${_TARGET} PUBLIC "-fsanitize=${LIST_OF_SANITIZERS}")
    endif()
  endif(ENABLED_SANITIZERS)

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

  if(MYPROJECT_ENABLE_CCACHE AND CCACHE)
    set_target_properties(${_TARGET} PROPERTIES C_COMPILER_LAUNCHER ${CCACHE} CXX_COMPILER_LAUNCHER ${CCACHE})
  endif()

  if(MYPROJECT_ENABLE_CLANG_TIDY AND CLANG_TIDY)
    set_target_properties(${_TARGET} PROPERTIES C_CLANG_TIDY ${CLANG_TIDY} CXX_CLANG_TIDY ${CLANG_TIDY})
  endif()

  if(MYPROJECT_ENABLE_CLANG_FORMAT AND CLANG_FORMAT)
    get_target_property(SOURCES ${_TARGET} SOURCES)
    list(TRANSFORM SOURCES PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/")
    add_custom_command(
      TARGET ${_TARGET}
      PRE_BUILD
      COMMAND ${CLANG_FORMAT} ARGS "--Werror" "--dry-run" "--verbose" ${SOURCES})
  endif()

  if(MYPROJECT_ENABLE_IWYU AND IWYU)
    set_target_properties(${_TARGET} PROPERTIES C_INCLUDE_WHAT_YOU_USE ${IWYU} CXX_INCLUDE_WHAT_YOU_USE ${IWYU})
  endif()
endfunction(set_target_options)
