# ******************************************************************************
# @file    CMakeLists.txt
# @author  garou (xgaroux@gmail.com)
# @brief   ZTGD32 CMake file for arm-none-eabi-gcc
# ******************************************************************************

cmake_minimum_required(VERSION 3.5)

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

        set(LINKER_PATH ${CORE_SRC}/Source)
        set(LINKER_SCRIPT ${CORE_SRC}/Source/gd32f407vg_flash.ld)
    else()
        message(FATAL_ERROR "Unsupported CPU model selected... (${ZT_CPU_MODEL})")
    endif()

    link_libraries(${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/Core/Source/libarm_cortexM4lf_math.a)

elseif(${ZT_CPU_SERIES} STREQUAL GD32F30X_HD)
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
        list(APPEND ${PROJECT_NAME}_DEFINES -DGD32F30X_HD)

        set(LINKER_PATH ${CORE_SRC}/Source)
        set(LINKER_SCRIPT ${CORE_SRC}/Source/gd32f303cc_flash.ld)
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
target_link_options(${PROJECT_NAME} INTERFACE -L${LINKER_PATH} -T ${LINKER_SCRIPT})
target_link_libraries(${PROJECT_NAME} INTERFACE)
