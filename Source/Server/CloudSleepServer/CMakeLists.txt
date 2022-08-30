# Thanks to tusik(https://github.com/tusik)
#
# How to build?
# 1. go into directory where CMakeLists.txt placed
# 2. mkdir build && cd build
# 3. cmake ..
# 4. cmake --build . --config Debug --target install
#    or cmake --build . --config Release --target install
# 5. binary output will be built in "install" directory
#

cmake_minimum_required (VERSION 3.15)

set (PROJECT_NAME "CloudSleepServer")
set (EXE_NAME "CloudSleepServer")

project (${PROJECT_NAME})

set (ASIO_DIR "third/asio/asio/include")
set (INSTALL_DIR "install")

# Override default install dir
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${INSTALL_DIR}" CACHE PATH "..." FORCE)
endif()

set (CMAKE_CXX_STANDARD 20)
set (CMAKE_CXX_STANDARD_REQUIRED ON)

set (HEADER_FILES
    "logger.h"
    "room.h"
    "sleeper.h"
    "wheat_command.h"
)

set (CPP_FILES
    "logger.cpp"
    "room.cpp"
    "sleeper.cpp"
    "wheat_command.cpp"
)

add_executable (${EXE_NAME}
    "main.cpp"
    ${CPP_FILES}
    ${HEADER_FILES}
)

target_include_directories (${EXE_NAME}
    PUBLIC ${ASIO_DIR}
)

if (MSVC)
    set_property(TARGET ${EXE_NAME} PROPERTY
        MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
endif()

install (TARGETS ${EXE_NAME}
    RUNTIME DESTINATION "."
)
