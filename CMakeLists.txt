cmake_minimum_required(VERSION 3.20)
project(sentinel LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_library(server
  src/core/.gitkeep
  src/handlers/.gitkeep
  src/tls/.gitkeep
  src/util/.gitkeep
)
target_include_directories(server PUBLIC include)

add_executable(serverd src/app/main.cpp)
target_link_libraries(serverd PRIVATE server)
