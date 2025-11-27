# ******************************************************************************
# @file    CMakeLists.txt
# @author  garou (xgaroux@gmail.com)
# @brief   ZTGD32 CMake file for arm-none-eabi-gcc
# ******************************************************************************

cmake_minimum_required(VERSION 3.30)

project(ztgd32)

set(MSG_PREFIX "ztgd32 |")

# Common includes --------------------------------------------------------------

list(APPEND ${PROJECT_NAME}_INCLUDES
    ${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/Core/Include
)

# CPU series depending sources and includes ------------------------------------

if (NOT ZT_CPU_SERIES)
    set(ZT_CPU_SERIES None CACHE STRING "Default CPU series is none")
endif()
if (NOT ZT_CPU_MODEL)
    set(ZT_CPU_MODEL None CACHE STRING "Default CPU model is none")
endif()
if (NOT ZT_TARGET_MEMORY)
    set(ZT_TARGET_MEMORY FLASH CACHE STRING "Default target memory is flash")
endif()

if(${ZT_CPU_SERIES} STREQUAL GD32F4xx)
    # Path constants
    set(CORE_SRC ${CMAKE_CURRENT_SOURCE_DIR}/Device/GD/GD32F4xx/Core)
    set(SPL_SRC ${CMAKE_CURRENT_SOURCE_DIR}/Device/GD/GD32F4xx/GD32F4xx_standard_peripheral)

    # Add core sources
    list(APPEND ${PROJECT_NAME}_SOURCES
        ${CORE_SRC}/Source/startup_gd32f407_427.s
        ${CORE_SRC}/Source/system_gd32f4xx.c
    )

    # Choose CPU
    if(${ZT_CPU_MODEL} STREQUAL GD32F407VG)
        list(APPEND ${PROJECT_NAME}_DEFINES -DGD32F407)

        if(${ZT_TARGET_MEMORY} STREQUAL RAM)
            set(LINKER_SCRIPT gd32f407vg_ram.ld)
        elseif(${ZT_TARGET_MEMORY} STREQUAL FLASH_W_BOOT)
            set(LINKER_SCRIPT gd32f407vg_flash_w_boot.ld)
        else()
            set(LINKER_SCRIPT gd32f407vg_flash.ld)
        endif()
    else()
        message(FATAL_ERROR "Unsupported CPU model selected... (${ZT_CPU_MODEL})")
    endif()

elseif(${ZT_CPU_SERIES} STREQUAL GD32F30X_HD)
    list(APPEND ${PROJECT_NAME}_DEFINES -DGD32F30X_HD)

    # Path constants
    set(CORE_SRC ${CMAKE_CURRENT_SOURCE_DIR}/Device/GD/GD32F30x/Core)
    set(SPL_SRC ${CMAKE_CURRENT_SOURCE_DIR}/Device/GD/GD32F30x/GD32F30x_standard_peripheral)

    # Add SPL sources
    list(APPEND ${PROJECT_NAME}_SOURCES
        ${CORE_SRC}/Source/startup_gd32f30x_hd.s
        ${CORE_SRC}/Source/system_gd32f30x.c
    )

    # Choose CPU
    if(${ZT_CPU_MODEL} STREQUAL GD32F303CC)
        set(LINKER_SCRIPT gd32f303cc_flash.ld)
    elseif(${ZT_CPU_MODEL} STREQUAL GD32F303RE)
        set(LINKER_SCRIPT gd32f303re_flash.ld)
    else()
        message(FATAL_ERROR "Unsupported CPU model selected... (${ZT_CPU_MODEL})")
    endif()

elseif(${ZT_CPU_SERIES} STREQUAL GD32F30X_XD)
    list(APPEND ${PROJECT_NAME}_DEFINES -DGD32F30X_XD)

    # Path constants
    set(CORE_SRC ${CMAKE_CURRENT_SOURCE_DIR}/Device/GD/GD32F30x/Core)
    set(SPL_SRC ${CMAKE_CURRENT_SOURCE_DIR}/Device/GD/GD32F30x/GD32F30x_standard_peripheral)

    # Add SPL sources
    list(APPEND ${PROJECT_NAME}_SOURCES
        ${CORE_SRC}/Source/startup_gd32f30x_xd.s
        ${CORE_SRC}/Source/system_gd32f30x.c
    )

    # Choose CPU
    if(${ZT_CPU_MODEL} STREQUAL GD32F303CG)
        set(LINKER_SCRIPT gd32f303cg_flash.ld)
    else()
        message(FATAL_ERROR "Unsupported CPU model selected... (${ZT_CPU_MODEL})")
    endif()

elseif(${ZT_CPU_SERIES} STREQUAL GD32F10X_MD)
    list(APPEND ${PROJECT_NAME}_DEFINES -DGD32F10X_MD)

    # Path constants
    set(CORE_SRC ${CMAKE_CURRENT_SOURCE_DIR}/Device/GD/GD32F10x/Core)
    set(SPL_SRC ${CMAKE_CURRENT_SOURCE_DIR}/Device/GD/GD32F10x/GD32F10x_standard_peripheral)

    # Add SPL sources
    list(APPEND ${PROJECT_NAME}_SOURCES
        ${CORE_SRC}/Source/startup_gd32f10x_md.s
        ${CORE_SRC}/Source/system_gd32f10x.c
    )

    # Choose CPU
    if(${ZT_CPU_MODEL} STREQUAL GD32F103C8)
        set(LINKER_SCRIPT gd32f103c8_flash.ld)
    else()
        message(FATAL_ERROR "Unsupported CPU model selected... (${ZT_CPU_MODEL})")
    endif()

else()
    message(FATAL_ERROR "Unsupported CPU series selected... (${ZT_CPU_SERIES})")
endif()

message(STATUS "${MSG_PREFIX} CPU series ${ZT_CPU_SERIES} and model ${ZT_CPU_MODEL}")

# Add SPL includes -------------------------------------------------------------
list(APPEND ${PROJECT_NAME}_INCLUDES
    ${CORE_SRC}/Include
    ${SPL_SRC}/Include
)

# Add SPL sources --------------------------------------------------------------

FILE(GLOB_RECURSE SPL_SOURCES ${SPL_SRC}/Source/*.c)
list(APPEND ${PROJECT_NAME}_SOURCES ${SPL_SOURCES})

# Setup library ----------------------------------------------------------------

add_library(${PROJECT_NAME} INTERFACE)
target_compile_definitions(${PROJECT_NAME} INTERFACE ${${PROJECT_NAME}_DEFINES})
target_include_directories(${PROJECT_NAME} INTERFACE ${${PROJECT_NAME}_INCLUDES})
target_sources(${PROJECT_NAME} INTERFACE ${${PROJECT_NAME}_SOURCES})
target_link_options(${PROJECT_NAME} INTERFACE -L${CORE_SRC}/Source -T ${CORE_SRC}/Source/${LINKER_SCRIPT})
target_link_libraries(${PROJECT_NAME} INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/libarm_cortexM4lf_math.a)
target_link_libraries(${PROJECT_NAME} INTERFACE)
