#-----------------------------------
#
#-----------------------------------
find_package(PkgConfig QUIET)
PKG_CHECK_MODULES(PC_LIBZMQ QUIET libzmq)
set(LIBZMQ_DEFINITIONS ${PC_LIBZMQ_CFLAGS_OTHER})

find_path(LIBZMQ_INCLUDE_DIR NAMES zmq.h zmq_utils.h
    HINTS
        ${PC_LIBZMQ_INCLUDEDIR}
        ${PC_LIBZMQ_INCLUDE_DIRS}
        ${ZMQ_HOME}/include
        ${LIBZMQ_HOME}/include
    )

if(PC_LIBZMQ_VERSION)
    set(LIBZMQ_VERSION_STRING ${PC_LIBZMQ_VERSION})
elseif(LIBZMQ_INCLUDE_DIR AND EXISTS "${LIBZMQ_INCLUDE_DIR}/zmq.h")
    file(STRINGS "${LIBZMQ_INCLUDE_DIR}/zmq.h" libzmq_ver REGEX "^#define[\t ]+ZMQ_VERSION_")
    string(REGEX REPLACE ".*#define[\t ]+ZMQ_VERSION_MAJOR[\t ]+([0-9]+).*" "\\1" LIBZMQ_VERSION_MAJOR "${libzmq_ver}")
    string(REGEX REPLACE ".*#define[\t ]+ZMQ_VERSION_MINOR[\t ]+([0-9]+).*" "\\1" LIBZMQ_VERSION_MINOR "${libzmq_ver}")
    string(REGEX REPLACE ".*#define[\t ]+ZMQ_VERSION_PATCH[\t ]+([0-9]+).*" "\\1" LIBZMQ_VERSION_PATCH "${libzmq_ver}")
    set(LIBZMQ_VERSION_STRING "${LIBZMQ_VERSION_MAJOR}.${LIBZMQ_VERSION_MINOR}.${LIBZMQ_VERSION_PATCH}")

endif()

if(WIN32)
    if (MSVC12)
        set(_tgt_COMPILER "-v120")
    elseif (MSVC11)
        set(_tgt_COMPILER "-v110")
    elseif (MSVC10)
        set(_tgt_COMPILER "-v100")
    elseif (MSVC90)
        set(_tgt_COMPILER "-v90")
    elseif (MSVC80)
        set(_tgt_COMPILER "-v80")
    elseif (MSVC71)
        set(_tgt_COMPILER "-v71")
    elseif (MSVC70)
        set(_tgt_COMPILER "-v7")
    elseif (MSVC60)
        set(_tgt_COMPILER "-v6")
    endif()

    set(_lzmq_rel zmq${_tgt_COMPILER}-mt-${LIBZMQ_VERSION_MAJOR}_${LIBZMQ_VERSION_MINOR}_${LIBZMQ_VERSION_PATCH}
)
    set(_lzmq_deb zmq${_tgt_COMPILER}-mt-gd-${LIBZMQ_VERSION_MAJOR}_${LIBZMQ_VERSION_MINOR}_${LIBZMQ_VERSION_PATCH}
)
    find_library(LIBZMQ_LIBRARY_RELEASE NAMES ${_lzmq_rel} lib${_lzmq_rel}
        HINTS
            ${ZMQ_HOME}/lib
            ${LIBZMQ_HOME}/lib
        )

    find_library(LIBZMQ_LIBRARY_DEBUG NAMES ${_lzmq_deb} lib${_lzmq_deb}
        HINTS
            ${ZMQ_HOME}/lib
            ${LIBZMQ_HOME}/lib
        )
    if(LIBZMQ_CMAKE_DEBUG)
        message("LIBZMQ_LIBRARY_RELEASE = ${LIBZMQ_LIBRARY_RELEASE}")
        message("LIBZMQ_LIBRARY_DEBUG = ${LIBZMQ_LIBRARY_DEBUG}")
    endif()

    if(LIBZMQ_LIBRARY_DEBUG AND LIBZMQ_LIBRARY_RELEASE)
        set(LIBZMQ_LIBRARIES debug ${LIBZMQ_LIBRARY_DEBUG} optimized ${LIBZMQ_LIBRARY_RELEASE})
    endif()


else()

    find_library(LIBZMQ_LIBRARIES NAMES libzmq
        HINTS
            ${PC_LIBZMQ_LIBDIR}
            ${PC_LIBZMQ_LIBRARY_DIRS}
            ${ZMQ_HOME}/lib
            ${LIBZMQ_HOME}/lib
        )
endif()

if(LIBZMQ_CMAKE_DEBUG)
    message("LIBZMQ_INCLUDE_DIR = ${LIBZMQ_INCLUDE_DIR}")
    message("LIBZMQ_LIBRARIES = ${LIBZMQ_LIBRARIES}")
endif()


# handle the QUIETLY and REQUIRED arguments and set OPENAL_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(LIBZMQ DEFAULT_MSG LIBZMQ_LIBRARIES LIBZMQ_INCLUDE_DIR)
mark_as_advanced(LIBZMQ_LIBRARIES LIBZMQ_INCLUDE_DIR LIBZMQ_VERSION_STRING)


