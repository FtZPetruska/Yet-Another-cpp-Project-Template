include_guard()

function(run_doxygen_if_available)
  if(MYPROJECT_ENABLE_DOXYGEN AND DOXYGEN_FOUND)
    set(DOXYGEN_USE_MDFILE_AS_MAINPAGE "README.md")
    doxygen_add_docs(
      docs
      "include"
      "src"
      "README.md"
      ALL
      WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
      COMMENT "Generate Doxygen documentation")
  endif()
endfunction(run_doxygen_if_available)
