include_guard()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}")

macro(setup_vcpkg)
  include("SetupVcpkg")
endmacro(setup_vcpkg)

function(setup_project)
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
endfunction(setup_project)

function(apply_options_to_target target)
  set_target_warnings(${target})
  set_target_options(${target})
endfunction(apply_options_to_target)
