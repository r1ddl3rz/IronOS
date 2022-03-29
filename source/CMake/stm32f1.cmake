# core flags
include(arm-gcc)
set(CORE_FLAGS "-mthumb -mcpu=cortex-m3 -mlittle-endian -mfloat-abi=soft --specs=nano.specs --specs=nosys.specs " CACHE INTERNAL "CPU flags")
add_definitions(${CORE_FLAGS})
# link with linker file
target_link_libraries(${elf_file} PUBLIC -T ../Core/BSP/Miniware/stm32f103.ld)

target_link_libraries(${elf_file} PUBLIC "-Wl,--defsym=__FLASH_SIZE__=${flash_size} -Wl,--defsym=__BOOTLDR_SIZE__=$(bootldr_size) -Wl,--print-memory-usage -flto --specs=nosys.specs --specs=nano.specs")
