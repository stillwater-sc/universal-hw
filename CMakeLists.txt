########################################################################
# CMakeLists.txt
#
# Authors: Matthias Moller, Theodore Omtzigt
########################################################################
include (cmake/banners.cmake)
print_header ()

########################################################################
# Force CMake version 3.18 or above
########################################################################
cmake_minimum_required (VERSION 3.18)

########################################################################
# Set RPATH on MacOSX
########################################################################
if (APPLE)
  set(CMAKE_MACOSX_RPATH ON)
  SET(CMAKE_SKIP_BUILD_RPATH FALSE)
  SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
  SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
  SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
  LIST(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${CMAKE_INSTALL_PREFIX}/lib" isSystemDir)
  IF ("${isSystemDir}" STREQUAL "-1")
    SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
  ENDIF ()
endif()

########################################################################
# Use solution folders for Visual Studio
########################################################################
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  # Set default build type to RelWithDebInfo
  set(CMAKE_BUILD_TYPE Release CACHE STRING
    "Type of build (None Debug Release RelWithDebInfo MinSizeRel)" FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release"
    "RelWithDebInfo" "MinSizeRel")
endif()

########################################################################
# We do not support in-source build
########################################################################
if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
  message(FATAL_ERROR "In-source builds are not permitted.\nPlease make a separate folder for building, otherwise type \nmake\nthat will create a ./build folder and will compile in that folder. Cmake has created garbage files/dirs (you may manually remove them):\nCMakeCache.txt CMakeFiles")
endif()

########################################################################
# automatic test conversion
########################################################################
macro (compile_all testing prefix folder)
    # cycle through the sources
    # For the according directories, we assume that each cpp file is a separate test
    # so, create a executable target and an associated test target
    foreach (source ${ARGN})
        get_filename_component (test ${source} NAME_WE)
        string(REPLACE " " ";" new_source ${source})
        set(test_name ${prefix}_${test})
        #message(STATUS "Add test ${test_name} from source ${new_source}.")
        add_executable (${test_name} ${new_source})

        #add_custom_target(valid SOURCES ${SOURCES})
        set_target_properties(${test_name} PROPERTIES FOLDER ${folder})
        if (${testing} STREQUAL "true")
            if (UNIVERSAL_CMAKE_TRACE)
                message(STATUS "testing: ${test_name} ${RUNTIME_OUTPUT_DIRECTORY}/${test_name}")
            endif()
            add_test(${test_name} ${RUNTIME_OUTPUT_DIRECTORY}/${test_name})
        endif()
    endforeach (source)
endmacro (compile_all)

########################################################################
# Project name
########################################################################
project(universal_hwqa CXX)
enable_testing()

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake")

# Global configuration
include(Config)

########################################################################
# Construct all the test suites and application programs
########################################################################
add_subdirectory("qa/exhaustive/posit")
add_subdirectory("qa/smoke/posit")
add_subdirectory("qa/smoke/valid")
add_subdirectory("examples/playground")
add_subdirectory("tests/posit")
