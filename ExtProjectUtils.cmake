include(ExternalProject)
include(CMakeParseArguments)

#
# Function to inject dependency (download from git repo)
#
# Use as ExternalProjectGit( "<url to git repository>" "<tag>" "<destination>" )
#     where
#     - url to repository for ex. https://github.com/log4cplus/log4cplus.git
#       project name will be regexed from url as latest part in our case log4cplus.git
#     - tag - tag you want to use
#     - destination - where to install your binaries, for example ${CMAKE_BINARY_DIR}/3rdparty
#

function(ExtProjectGit repourl tag destination)

    message(STATUS "Get external project from: ${repourl} : ${tag}")

    string(REGEX MATCH "([^\/]+)\.git$" _name ${repourl})

    set(options)
    set(oneValueArgs)
    set(multiValueArgs CMAKE_ARGS)
    cmake_parse_arguments(ExtProjectGit "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    set(cmake_cli_args -DCMAKE_INSTALL_PREFIX=${destination}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE})
    foreach(cmake_key ${ExtProjectGit_CMAKE_ARGS})
        set(cmake_cli_args ${cmake_key} ${cmake_cli_args})
    endforeach()

    message(STATUS "ARGS for ExternalProject_Add(${name}): ${cmake_cli_args}")

    ExternalProject_Add(${_name}
        GIT_REPOSITORY ${repourl}
        GIT_TAG ${tag}
        CMAKE_ARGS ${cmake_cli_args}
        PREFIX "${destination}"
        INSTALL_DIR "${destination}")

endfunction()
