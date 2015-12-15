find_program(CPPCHECK_EXECUTABLE cppcheck DOC "Path to cppcheck executable")
mark_as_advanced(CPPCHECK_EXECUTABLE)

if(CPPCHECK_EXECUTABLE)
    # get version string
    execute_process(COMMAND ${CPPCHECK_EXECUTABLE} --version
        OUTPUT_VARIABLE _cc_version_output
        ERROR_VARIABLE  _cc_version_error
        RESULT_VARIABLE _cc_version_result
        OUTPUT_STRIP_TRAILING_WHITESPACE)

    if(NOT ${_cc_version_result} EQUAL 0)
        message(SEND_ERROR "command \"${CPPCHECK_EXECUTABLE} --version\" failed - ${_cc_version_error}")
    else()
        string(REGEX MATCH "[.0-9]+"
            CPPCHECK_VERSION "${_cc_version_output}")
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(CPPCHECK
    REQUIRED_VARS CPPCHECK_EXECUTABLE
    VERSION_VAR CPPCHECK_VERSION)
mark_as_advanced(CPPCHECK_VERSION)

