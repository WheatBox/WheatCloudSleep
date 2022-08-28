cmake_minimum_required(VERSION 3.14)
set(CMAKE_EXPORT_PACKAGE_REGISTRY ON)
project(CloudSleepServer)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(MSVC)
    set_property ( DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT ${PROJECT_NAME} )
endif(MSVC)

set(H_FILE
    WheatCommand.h 
    WheatBedManager.h 
    WheatChatRecorder.h 
    ProjectCommon.h
    WheatTCPServer.h
    WheatVote.h
)
set(CPP_FILE 
    WheatCommand.cpp 
    WheatBedManager.cpp 
    WheatChatRecorder.cpp 
    ProjectCommon.cpp
    WheatTCPServer.cpp
    WheatVote.cpp
    main.cpp
)

add_executable(CloudSleepServer
    ${CPP_FILE}
    ${H_FILE}
)