#RUN THIS COMMAND EVERY TIME YOU MAKE CHANGES TO THIS FILE:
#cmake -B build-dir 

#To build: cmake --build build-dir --target helloworld
#To build AND run: cmake --build build-dir --target run_helloworld
cmake_minimum_required(VERSION 3.14...3.30)
project(
    anchorEngine
    LANGUAGES CXX C
)

##GLFW OR WHATEVER PACKAGE
## Enable decentralized package loading
include(FetchContent)
set(FETCHCONTENT_QUIET FALSE)

## GRAPHICS 
##GLFW import!
FetchContent_Declare(
    glfw3
    GIT_REPOSITORY https://github.com/glfw/glfw.git
    GIT_TAG 3.4
    GIT_SHALLOW TRUE
    GIT_PROGRESS TRUE
    )
set(GLFW_BUILD_DOCS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(GLFW_INSTALL OFF CACHE BOOL "" FORCE)
FetchContent_MakeAvailable( glfw3 )

##WEBGPU import!
## Can change `wgpu` to `dawn`
set(WEBGPU_BACKEND "wgpu" CACHE STRING "WebGPU backend (wgpu or dawn)")
FetchContent_Declare(
  webgpu
  GIT_REPOSITORY https://github.com/yig/WebGPU-distribution
  GIT_TAG        main
  GIT_SHALLOW TRUE
  GIT_PROGRESS TRUE
)
FetchContent_MakeAvailable( webgpu )

FetchContent_Declare(
  glfw3webgpu
  GIT_REPOSITORY https://github.com/eliemichel/glfw3webgpu
  GIT_TAG        main
  GIT_SHALLOW TRUE
  GIT_PROGRESS TRUE
)
FetchContent_MakeAvailable( glfw3webgpu )

##END OF GRAPHICS STUFF

###SOUNDSTUFF
FetchContent_Declare(
  soloud
  GIT_REPOSITORY https://github.com/jarikomppa/soloud
  GIT_TAG        master # tested with: e82fd32c1f62183922f08c14c814a02b58db1873
  GIT_SHALLOW TRUE
  GIT_PROGRESS TRUE
)
FetchContent_MakeAvailable( soloud )
## SoLoud doesn't have its own `CMakeLists.txt`, so let's declare a library directly from its sources.
file(GLOB soloud_sources "${soloud_SOURCE_DIR}/src/audiosource/*/*.c*" "${soloud_SOURCE_DIR}/src/c_api/*.c*" "${soloud_SOURCE_DIR}/src/core/*.c*" "${soloud_SOURCE_DIR}/src/filter/*.c*" "${soloud_SOURCE_DIR}/src/backend/miniaudio/soloud_miniaudio.cpp")
add_library(soloud ${soloud_sources})
target_compile_definitions(soloud PRIVATE WITH_MINIAUDIO)
target_include_directories(soloud PUBLIC "${soloud_SOURCE_DIR}/include")
if(APPLE)
    find_library(AudioUnit_LIBRARY AudioUnit)
    find_library(CoreAudio_LIBRARY CoreAudio)
    target_link_libraries(soloud INTERFACE ${AudioUnit_LIBRARY} ${CoreAudio_LIBRARY})
    target_compile_definitions(soloud PRIVATE MA_NO_RUNTIME_LINKING)
endif()
if(WIN32)
    target_compile_definitions( soloud PRIVATE MA_NO_JACK )
endif()
###END SOUND STUFF

##GLM IMPORTS
FetchContent_Declare(
    glm
    GIT_REPOSITORY https://github.com/g-truc/glm.git
    GIT_TAG 1.0.1
    GIT_SHALLOW TRUE
    GIT_PROGRESS TRUE
    )
FetchContent_MakeAvailable( glm )
##End GLM imports

#IMAGE LOADING RELATED IMPORTS
FetchContent_Declare(
  stb
  GIT_REPOSITORY https://github.com/nothings/stb/
  GIT_TAG        master # tested with f75e8d1cad7d90d72ef7a4661f1b994ef78b4e31
  GIT_SHALLOW TRUE
  GIT_PROGRESS TRUE
)
FetchContent_MakeAvailable( stb )
add_library( stb INTERFACE )
target_include_directories( stb INTERFACE ${stb_SOURCE_DIR} )

#SCRIPTING IMPORTS!
FetchContent_Declare(
    lua
    GIT_REPOSITORY https://github.com/walterschell/Lua
    GIT_TAG v5.4.5
    GIT_SHALLOW TRUE
    GIT_PROGRESS TRUE
    )
set(LUA_ENABLE_TESTING OFF CACHE BOOL "" FORCE)
FetchContent_MakeAvailable( lua )

FetchContent_Declare(
    sol2
    GIT_REPOSITORY https://github.com/yig/sol2
    GIT_TAG develop
    GIT_SHALLOW TRUE
    GIT_PROGRESS TRUE
    )
FetchContent_MakeAvailable( sol2 )
#SCRIPTING IMPORTS DONE


## Declare the engine library
add_library( anchorEngine STATIC src/Engine.cpp src/GraphicsManager.cpp src/InputManager.cpp src/ResourceManager.cpp src/SoundManager.cpp src/ScriptManager.cpp src/UIManager.cpp)

set_target_properties( anchorEngine PROPERTIES CXX_STANDARD 20 )

## Declare our engine's header path.
## This allows targets that depend on the engine to #include them.
target_include_directories( anchorEngine PUBLIC src )
target_include_directories( anchorEngine PUBLIC demo )
target_link_libraries( anchorEngine PUBLIC glfw soloud webgpu glfw3webgpu glm stb sol2 lua_static)

add_executable( helloworld demo/helloworld.cpp)
add_custom_target( run_helloworld helloworld USES_TERMINAL WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
set_target_properties( helloworld PROPERTIES CXX_STANDARD 20 )
target_link_libraries( helloworld PRIVATE anchorEngine )
target_copy_webgpu_binaries( helloworld )