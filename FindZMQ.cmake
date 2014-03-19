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
        ${ZMQ_ROOT}/include
        ${LIBZMQ_ROOT}/include
    )

find_library(LIBZMQ_LIBRARIES NAMES zmq libzmq
    HINTS
        ${PC_LIBZMQ_LIBDIR}
        ${PC_LIBZMQ_LIBRARY_DIRS}
        ${ZMQ_ROOT}/lib
        ${LIBZMQ_ROOT}/lib
    )

if(PC_LIBZMQ_VERSION)
    set(LIBZMQ_VERSION_STRING ${PC_LIBZMQ_VERSION})
elseif(LIBZMQ_INCLUDE_DIR AND EXISTS "${LIBZMQ_INCLUDE_DIR}/zmq.h")
    file(STRINGS "${LIBZMQ_INCLUDE_DIR}/zmq.h" libzmq_ver
         REGEX "^#define[\t ]+ZMQ_VERSION_")
    message("libzmq_ver = ${libzmq_ver})
endif()

# handle the QUIETLY and REQUIRED arguments and set OPENAL_FOUND to TRUE if
# all listed variables are TRUE
include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(LIBZMQ DEFAULT_MSG LIBZMQ_LIBRARIES LIBZMQ_INCLUDE_DIR)
mark_as_advanced(LIBZMQ_LIBRARIES LIBZMQ_INCLUDE_DIR)


