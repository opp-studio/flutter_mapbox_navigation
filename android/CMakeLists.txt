cmake_minimum_required(VERSION 3.22.1)

project("flutter_mapbox_navigation")

# 16 KB page size support
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DANDROID_SUPPORT_FLEXIBLE_PAGE_SIZES=ON")

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 16 KB page size alignment
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-z,max-page-size=16384")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-z,max-page-size=16384")

# Find required packages
find_package(PkgConfig REQUIRED)
find_package(Threads REQUIRED)

# Add the library
add_library(flutter_mapbox_navigation SHARED
    src/main/kotlin/com/eopeter/fluttermapboxnavigation/FlutterMapboxNavigationPlugin.kt
)

# Link libraries
target_link_libraries(flutter_mapbox_navigation
    android
    log
    Threads::Threads
)

# 16 KB page size support
target_compile_definitions(flutter_mapbox_navigation PRIVATE
    ANDROID_SUPPORT_FLEXIBLE_PAGE_SIZES=1
)
