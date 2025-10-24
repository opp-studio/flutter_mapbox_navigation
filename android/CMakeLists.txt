cmake_minimum_required(VERSION 3.22.1)

project(flutter_mapbox_navigation CXX)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 16 KB page size alignment - aggressive settings
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-z,max-page-size=16384 -Wl,-z,common-page-size=16384")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-z,max-page-size=16384 -Wl,-z,common-page-size=16384")

# Force 16KB alignment for all targets
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wl,-z,max-page-size=16384 -Wl,-z,common-page-size=16384")

# Find required packages
find_package(PkgConfig REQUIRED)
find_package(Threads REQUIRED)

# 16 KB page size support
add_compile_definitions(ANDROID_SUPPORT_FLEXIBLE_PAGE_SIZES=1)