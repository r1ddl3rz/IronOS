cmake_minimum_required(VERSION 3.13)
set(application_name "${MODEL}_${LANG}")
set(elf_file ${application_name}.elf)
set(bin_file ${application_name}.bin)
set(hex_file ${application_name}.hex)
set(map_file ${application_name}.map)


if (MODEL STREQUAL TS100 OR MODEL STREQUAL TS80 OR MODEL STREQUAL TS80P)
    set(CMAKE_TOOLCHAIN_FILE "CMake/stm32f1.cmake" CACHE PATH "toolchain file")
    include(${CMAKE_TOOLCHAIN_FILE})
elseif(MODEL STREQUAL Pinecil)

elseif(MODEL STREQUAL MHP30)

else()
 message(FATAL_ERROR "You must specify a model")
endif()


# Export compile commands for IDE's
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_C_STANDARD 11)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
#add_compile_options( -Wall -Werror)


project(IronOS
  #VERSION 0.0.0.0
  LANGUAGES C CXX ASM
)
#Setup outputs

project (${application_name} C CXX ASM)


# add sources to elf file

file(WRITE null.cpp "")

add_executable(${elf_file}
    null.cpp
)



set (CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_CURRENT_SOURCE_DIR}/CMake")



include_directories(
  Core
  Middlewares
)
add_subdirectory(Core)
add_subdirectory(Middlewares)



target_link_libraries(${elf_file} PUBLIC BSP mainSource threads FreeRTOS)
include(shared-compiler-settings)



# set additional for compiler and linker: optimization and generate map file
set(additional_compiler_flags ${opt_level})
set(additional_linker_flags -Wl,-Map=${map_file},--cref,--no-warn-mismatch)
target_compile_options(${elf_file} PRIVATE ${additional_compiler_flags})
target_link_libraries(${elf_file} PRIVATE ${additional_linker_flags})

# remove unused sections
target_link_libraries(${elf_file} PUBLIC "-g -Wl,--gc-sections")


# show size of resulting firmware image
add_custom_target(${elf_file}-size DEPENDS ${elf_file} COMMAND ${SIZE_EXECUTABLE} -B ${elf_file})

# generate extended listing
add_custom_target(${lss_file} DEPENDS ${elf_file} COMMAND ${OBJDUMP_EXECUTABLE} -S ${elf_file} > ${lss_file})

# create binary and hex files
add_custom_target(${hex_file} DEPENDS ${elf_file} COMMAND ${OBJCOPY_EXECUTABLE} -Oihex ${elf_file} ${hex_file})
add_custom_target(${bin_file} DEPENDS ${elf_file} COMMAND ${OBJCOPY_EXECUTABLE} -Obinary ${elf_file} ${bin_file})

add_custom_target(${application_name} ALL DEPENDS ${elf_file}-size ${bin_file} ${hex_file} ${lss_file})


# Set path to our raw modules
