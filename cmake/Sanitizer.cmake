include_guard()

function(check_available_sanitizer)
  include(CheckLinkerFlag)
  check_linker_flag(CXX "-fsanitize=address" HAVE_ADDRESS_SANITIZER)
  check_linker_flag(CXX "-fsanitize=thread" HAVE_THREAD_SANITIZER)
  check_linker_flag(CXX "-fsanitize=memory" HAVE_MEMORY_SANITIZER)
  check_linker_flag(CXX "-fsanitize=undefined" HAVE_UB_SANITIZER)
  check_linker_flag(CXX "-fsanitize=leak" HAVE_LEAK_SANITIZER)
endfunction(check_available_sanitizer)

function(add_sanitizer_to_target _TARGET)
  if(MYPROJECT_ENABLE_ADDRESS_SANITIZER AND HAVE_ADDRESS_SANITIZER)
    list(APPEND ENABLED_SANITIZERS "address")
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
endfunction(add_sanitizer_to_target _TARGET)
