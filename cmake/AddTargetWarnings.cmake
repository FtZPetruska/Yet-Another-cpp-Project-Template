include_guard()

# Warning sets taken from: https://github.com/aminya/project_options

function(set_available_warnings)
  set(CANDIDATE_MSVC_WARNINGS
      "/W4" # Baseline reasonable warnings
      "/w14242" # 'identifier': conversion from 'type1' to 'type1', possible loss of data
      "/w14254" # 'operator': conversion from 'type1:field_bits' to 'type2:field_bits', possible loss of data
      "/w14263" # 'function': member function does not override any base class virtual member function
      "/w14265" # 'classname': class has virtual functions, but destructor is not virtual instances of this class may
                # not be destructed correctly
      "/w14287" # 'operator': unsigned/negative constant mismatch
      "/we4289" # nonstandard extension used: 'variable': loop control variable declared in the for-loop is used outside
                # the for-loop scope
      "/w14296" # 'operator': expression is always 'boolean_value'
      "/w14311" # 'variable': pointer truncation from 'type1' to 'type2'
      "/w14545" # expression before comma evaluates to a function which is missing an argument list
      "/w14546" # function call before comma missing argument list
      "/w14547" # 'operator': operator before comma has no effect; expected operator with side-effect
      "/w14549" # 'operator': operator before comma has no effect; did you intend 'operator'?
      "/w14555" # expression has no effect; expected expression with side- effect
      "/w14619" # pragma warning: there is no warning number 'number'
      "/w14640" # Enable warning on thread un-safe static member initialization
      "/w14826" # Conversion from 'type1' to 'type_2' is sign-extended. This may cause unexpected runtime behavior.
      "/w14905" # wide string literal cast to 'LPSTR'
      "/w14906" # string literal cast to 'LPWSTR'
      "/w14928" # illegal copy-initialization; more than one user-defined conversion has been implicitly applied
      "/permissive-" # standards conformance mode for MSVC compiler.
  )

  set(CANDIDATE_GNU_WARNINGS
      "-Wall"
      "-Wextra" # reasonable and standard
      "-Wshadow" # warn the user if a variable declaration shadows one from a parent context
      "-Wnon-virtual-dtor" # warn the user if a class with virtual functions has a non-virtual destructor. This helps
                           # catch hard to track down memory errors
      "-Wold-style-cast" # warn for c-style casts
      "-Wcast-align" # warn for potential performance problem casts
      "-Wunused" # warn on anything being unused
      "-Woverloaded-virtual" # warn if you overload (not override) a virtual function
      "-Wpedantic" # warn if non-standard C++ is used
      "-Wconversion" # warn on type conversions that may lose data
      "-Wsign-conversion" # warn on sign conversions
      "-Wnull-dereference" # warn if a null dereference is detected
      "-Wdouble-promotion" # warn if float is implicit promoted to double
      "-Wformat=2" # warn on security issues around functions that format output (ie printf)
      "-Wimplicit-fallthrough" # warn on statements that fallthrough without an explicit annotation
      "-Wmisleading-indentation" # warn if indentation implies blocks where blocks do not exist
      "-Wduplicated-cond" # warn if if / else chain has duplicated conditions
      "-Wduplicated-branches" # warn if if / else branches have duplicated code
      "-Wlogical-op" # warn about logical operations being used where bitwise were probably wanted
      "-Wuseless-cast" # warn if you perform a cast to the same type
  )

  set(NON_C_WARNINGS
      -Wnon-virtual-dtor
      -Wold-style-cast
      -Woverloaded-virtual
      -Wuseless-cast)

  if(MSVC)
    set(CANDIDATE_WARNINGS ${CANDIDATE_MSVC_WARNINGS})
  else()
    set(CANDIDATE_WARNINGS ${CANDIDATE_GNU_WARNINGS})
  endif()

  include(CheckCXXCompilerFlag)
  foreach(WARNING ${CANDIDATE_WARNINGS})
    string(MAKE_C_IDENTIFIER "${WARNING}" WARNING_NAME)
    check_cxx_compiler_flag("${WARNING}" "HAVE${WARNING_NAME}")
    if(HAVE${WARNING_NAME})
      list(APPEND VALID_CXX_WARNINGS "${WARNING}")
    endif()
  endforeach()

  if(MSVC)
    check_cxx_compiler_flag("/WX" HAVE_WARNINGS_AS_ERROR)
  else()
    check_cxx_compiler_flag("-Werror" HAVE_WARNINGS_AS_ERROR)
  endif()
  if(HAVE_WARNINGS_AS_ERROR)
    option(MYPROJECT_ENABLE_WARNINGS_AS_ERROR "Treat compiler warnings as errors" ON)
  endif()

  if(MYPROJECT_ENABLE_WARNINGS_AS_ERROR)
    if(MSVC)
      list(APPEND VALID_CXX_WARNINGS "/WX")
    else()
      list(APPEND VALID_CXX_WARNINGS "-Werror")
    endif()

  endif()

  set(VALID_C_WARNINGS ${VALID_CXX_WARNINGS})
  list(REMOVE_ITEM VALID_C_WARNINGS ${NON_C_WARNINGS})

  set(MYPROJECT_C_WARNINGS
      ${VALID_C_WARNINGS}
      CACHE INTERNAL "Available C warnings")
  set(MYPROJECT_CXX_WARNINGS
      ${VALID_CXX_WARNINGS}
      CACHE INTERNAL "Available C++ warnings")
endfunction(set_available_warnings)

function(set_target_warnings _TARGET)
  target_compile_options(${_TARGET} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:${MYPROJECT_CXX_WARNINGS}>
                                           $<$<COMPILE_LANGUAGE:C>:${MYPROJECT_C_WARNINGS}>)
endfunction(set_target_warnings)
