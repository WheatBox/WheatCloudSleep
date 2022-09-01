# Thanks to tusik(https://github.com/tusik)
#
# How to build?
# - on windows
#   1. go into the directory where CMakeLists.txt placed
#   3. cmake -S . -B server-build
#   4. cmake --build server-build --config Debug --target install
#      or cmake --build server-build --config Release --target install
#   5. binary output will be built in "server-build/install" directory
# - on linux
#   1. go into the directory where CMakeLists.txt placed
#   2. cmake -S . -B server-build/ -D CMAKE_BUILD_TYPE=Debug
#      or cmake -S . -B server-build/ -D CMAKE_BUILD_TYPE=Release
#   3. cmake --build server-build/
#   4. binary output will be built in "server-build/install" directory
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

# Add all header files
file (GLOB HEADER_FILES *.h)

# Add all source files
file (GLOB CPP_FILES *.cpp)

add_executable (${EXE_NAME}
    ${CPP_FILES}
    ${HEADER_FILES}
)

target_include_directories (${EXE_NAME}
    PUBLIC ${ASIO_DIR}
)

target_compile_features (${EXE_NAME}
    PUBLIC cxx_std_20
)

if (MSVC) # static link MultiThreaded lib
    set_property(TARGET ${EXE_NAME} PROPERTY
        MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
endif()

if (UNIX) # Building on unix-like system, link pthread for asio.
    target_link_libraries(${EXE_NAME}
        pthread
    )
    target_compile_options(${EXE_NAME}
        PUBLIC "-Wall"
    )
endif()

install (TARGETS ${EXE_NAME}
    RUNTIME DESTINATION "."
)
