include_directories(${CMAKE_CURRENT_SOURCE_DIR})

set(sources 
BMA223.cpp
)


add_library(drivers ${sources})
target_link_libraries(drivers PUBLIC  BSP )
target_include_directories(drivers PUBLIC .)

add_subdirectory(usb-pd)