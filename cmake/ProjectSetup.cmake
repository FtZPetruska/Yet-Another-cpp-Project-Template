include_guard()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}")

macro(setup_dependencies)
  if(WIN32)
    set(VCPKG_ENABLED ON)
  else()
    string(
      REGEX MATCH
            "vcpkg.cmake"
            VCPKG_ENABLED
            "${CMAKE_TOOLCHAIN_FILE}")
  endif()

  option(MYPROJECT_USE_VCPKG "Manage dependencies with VCPKG. Can only be set on first Configuration" ${VCPKG_ENABLED})
  unset(VCPKG_ENABLED)

  if(NOT DEFINED IS_FIRST_RUN_WITH_VCPKG)
    set(IS_FIRST_RUN_WITH_VCPKG
        ${MYPROJECT_USE_VCPKG}
        CACHE INTERNAL "Stores whether VCPKG was used for the first configuration")
  endif()

  if((NOT MYPROJECT_USE_VCPKG AND IS_FIRST_RUN_WITH_VCPKG) OR (MYPROJECT_USE_VCPKG AND NOT IS_FIRST_RUN_WITH_VCPKG))
    message(
      FATAL_ERROR "You need to delete your cache and set the value of MYPROJECT_USE_VCPKG on the first configuration.")
  endif()

  if(MYPROJECT_USE_VCPKG)
    include("SetupVcpkg")
  endif()
endmacro(setup_dependencies)

function(setup_project)
  include("Sanitizer")

  # Check which flags are supported
  include("CheckAvailableFlags")

  # Check which tools are available
  include("CheckAvailableTools")

  # Make options based on available tools and flags
  include("DeclareProjectOptions")

  # Load a function for setting target options
  include("AddTargetOptions")

  # Load a function for setting target options
  include("AddTargetWarnings")
  set_available_warnings()

  # Printout the options
  include("PrintOptions")
  print_options_summary()
endfunction(setup_project)

function(apply_options_to_target target)
  set_target_warnings(${target})
  set_target_options(${target})
endfunction(apply_options_to_target)
