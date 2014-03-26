# - Find Thrift (a cross platform RPC lib/tool)
# This module defines
#  THRIFT_VERSION, version string of ant if found
#  THRIFT_INCLUDE_DIR, where to find THRIFT headers
#  THRIFT_CONTRIB_DIR, where contrib thrift files (e.g. fb303.thrift) are installed
#  THRIFT_LIBS, THRIFT libraries
#  THRIFT_FOUND, If false, do not try to use ant
#
# Initial work was done by Cloudera https://github.com/cloudera/Impala
# 2014 - modified by snikulov

# prefer the thrift version supplied in THRIFT_HOME (cmake -DTHRIFT_HOME then environment)
find_path(THRIFT_INCLUDE_DIR
    NAMES
        thrift/Thrift.h
    HINTS
        ${THRIFT_HOME}
        ENV THRIFT_HOME
        /usr/local
        /opt/local
    PATH_SUFFIXES
        include
)
# TODO: not needed for us
#find_path(THRIFT_CONTRIB_DIR share/fb303/if/fb303.thrift HINTS
#  $ENV{THRIFT_HOME}
#  /usr/local/
#)

# prefer the thrift version supplied in THRIFT_HOME
find_library(THRIFT_LIB
    NAMES
        thrift libthrift
    HINTS
        ${THRIFT_HOME}
        ENV THRIFT_HOME
        /usr/local
        /opt/local
    PATH_SUFFIXES
        lib lib64
)

find_program(THRIFT_COMPILER
    NAMES
        thrift
    HINTS
        ${THRIFT_HOME}
        ENV THRIFT_HOME
        /usr/local
        /opt/local
    PATH_SUFFIXES
        bin bin64
)

if (THRIFT_LIB AND THRIFT_INCLUDE_DIR AND THRIFT_COMPILER)
    set(THRIFT_FOUND TRUE)
    set(THRIFT_LIBS ${THRIFT_LIB})
    exec_program(${THRIFT_COMPILER}
        ARGS -version OUTPUT_VARIABLE THRIFT_VERSION_OUT RETURN_VALUE THRIFT_RETURN)
    string(REGEX MATCH "[0-9]+.[0-9]+.[0-9]+-[a-z]+$" THRIFT_VERSION ${THRIFT_VERSION_OUT})
else ()
    set(THRIFT_FOUND FALSE)
endif ()

if (THRIFT_FOUND)
    if (NOT THRIFT_FIND_QUIETLY)
        message(STATUS "Found Thrift version: ${THRIFT_VERSION}")
    endif ()
else ()
    message(STATUS "Thrift compiler/libraries NOT found. ")
endif ()


mark_as_advanced(
    THRIFT_LIB
    THRIFT_LIBS
    THRIFT_COMPILER
    THRIFT_INCLUDE_DIR
    THRIFT_VERSION
)
