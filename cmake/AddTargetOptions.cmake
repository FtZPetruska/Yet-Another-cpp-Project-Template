include_guard()

function(set_target_options target)
  set_target_properties(
    ${target}
    PROPERTIES C_STANDARD 11
               C_STANDARD_REQUIRED OFF
               C_EXTENSIONS OFF
               CXX_STANDARD 20
               CXX_STANDARD_REQUIRED ON
               CXX_EXTENSIONS OFF)

  if(MYPROJECT_ENABLE_ADDRESS_SANITIZER)
    list(APPEND ENABLED_SANITIZERS "address")
  endif()

  if(MYPROJECT_ENABLE_THREAD_SANITIZER)
    list(APPEND ENABLED_SANITIZERS "thread")
  endif()

  if(MYPROJECT_ENABLE_MEMORY_SANITIZER)
    list(APPEND ENABLED_SANITIZERS "memory")
  endif()

  if(MYPROJECT_ENABLE_UB_SANITIZER)
    list(APPEND ENABLED_SANITIZERS "undefined")
    message(WARNING "UBSAN will fail to link if you have statically linked dependencies.")
  endif()

  if(MYPROJECT_ENABLE_LEAK_SANITIZER)
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
      target_compile_options(${target} PUBLIC "/fsanitize=${LIST_OF_SANITIZERS} /Zi /INCREMENTAL=NO")
      target_link_options(${target} PUBLIC "/INCREMENTAL=NO")
    else()
      target_compile_options(${target} PUBLIC "-fsanitize=${LIST_OF_SANITIZERS}")
      target_link_options(${target} PUBLIC "-fsanitize=${LIST_OF_SANITIZERS}")
    endif()
  endif(ENABLED_SANITIZERS)

  if(MYPROJECT_ENABLE_NATIVE_OPTIMISATION)
    target_compile_options(${target} PRIVATE "-march=native")
  endif()

  if(MYPROJECT_ENABLE_PROFILER)
    if(MSVC)
      target_link_options(${target} PRIVATE "/PROFILE")
    else()
      target_compile_options(${target} PRIVATE "-pg")
      target_link_options(${target} PRIVATE "-pg")
    endif()
  endif()

  if(MYPROJECT_ENABLE_GCOV)
    target_compile_options(${target} PUBLIC "--coverage")
    target_link_options(${target} PUBLIC "--coverage")
  endif()

  if(MYPROJECT_ENABLE_LTO)
    set_target_properties(${target} PROPERTIES INTERPROCEDURAL_OPTIMIZATION ${MYPROJECT_ENABLE_LTO})
  endif()

  if(MYPROJECT_ENABLE_PIE)
    set_target_properties(${target} PROPERTIES POSITION_INDEPENDENT_CODE ${MYPROJECT_ENABLE_PIE})
  endif()

  if(MYPROJECT_ENABLE_CCACHE)
    set_target_properties(${target} PROPERTIES C_COMPILER_LAUNCHER ${CCACHE} CXX_COMPILER_LAUNCHER ${CCACHE})
  endif()

  if(MYPROJECT_ENABLE_CLANG_TIDY)
    set_target_properties(${target} PROPERTIES C_CLANG_TIDY ${CLANG_TIDY} CXX_CLANG_TIDY ${CLANG_TIDY})
  endif()

  if(MYPROJECT_ENABLE_CLANG_FORMAT)
    get_target_property(SOURCES ${target} SOURCES)
    list(TRANSFORM SOURCES PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/")
    add_custom_command(
      TARGET ${target}
      PRE_BUILD
      COMMAND ${CLANG_FORMAT} ARGS --Werror --dry-run --verbose ${SOURCES})
  endif()

  if(MYPROJECT_ENABLE_IWYU)
    set_target_properties(${target} PROPERTIES C_INCLUDE_WHAT_YOU_USE ${IWYU} CXX_INCLUDE_WHAT_YOU_USE ${IWYU})
  endif()
endfunction(set_target_options)
