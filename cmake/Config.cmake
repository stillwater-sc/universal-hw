########################################################################
# Config.cmake
#
# Authors: Matthias Moller, Theodore Omtzigt
########################################################################

########################################################################
if(NOT COMPUTE_BACKEND_TYPE)
	set(COMPUTE_BACKEND_TYPE "cpu" CACHE STRING
   "Backend type" FORCE)
endif()
set_property(CACHE COMPUTE_BACKEND_TYPE PROPERTY STRINGS
  "cpu"
  "fpga"
  "xsmm"
  )

# Include universal library
include_directories("${PROJECT_SOURCE_DIR}/external/universal/include")
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

########################################################################
# MPI
########################################################################
option(COMPUTE_WITH_MPI "Enable MPI support" OFF)

if(COMPUTE_WITH_MPI)
  find_package(MPI QUIET REQUIRED)
  if(MPI_CXX_FOUND)
    set(HAVE_MPI ON)
  endif()
endif()

########################################################################
# OpenMP
########################################################################
option(COMPUTE_WITH_OPENMP "Enable OpenMP support" ON)

if(COMPUTE_WITH_OPENMP)
  # Apple explicitly disabled OpenMP support in their compilers that
  # are shipped with XCode but there is an easy workaround as
  # described at https://mac.r-project.org/openmp/
  if (CMAKE_C_COMPILER_ID STREQUAL "AppleClang" OR CMAKE_C_COMPILER_ID STREQUAL "Clang" AND ${CMAKE_SYSTEM_NAME} MATCHES "Darwin" OR
      CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND ${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    find_path(OpenMP_C_INCLUDE_DIR
      NAMES "omp.h" PATHS /usr/local /opt /opt/local /opt/homebrew PATH_SUFFICES include)
    find_path(OpenMP_CXX_INCLUDE_DIR
      NAMES "omp.h" PATHS /usr/local /opt /opt/local /opt/homebrew PATH_SUFFICES include)
    find_library(OpenMP_libomp_LIBRARY
      NAMES "omp" PATHS /usr/local /opt /opt/local /opt/homebrew PATH_SUFFICES lib)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Xclang -fopenmp -I${OpenMP_C_INCLUDE_DIR}")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Xclang -fopenmp -I${OpenMP_CXX_INCLUDE_DIR}")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_libomp_LIBRARY}")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${OpenMP_libomp_LIBRARY}")
  else() 
    find_package(OpenMP REQUIRED)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${OpenMP_libomp_LIBRARY}")
  endif()
  set(HAVE_OPENMP ON)
endif()

########################################################################
# LibXSMM
########################################################################
option(COMPUTE_WITH_XSMM "Enable LibXSMM support" OFF)

if(COMPUTE_WITH_XSMM)
  include_directories("${PROJECT_SOURCE_DIR}/external/libxsmm/include")
  set(HAVE_XSMM ON)
endif()

########################################################################
# Summary
########################################################################
message("")
message("---------- Configuration ----------")
message("Build type.........................: ${CMAKE_BUILD_TYPE}")
message("Build shared libraries.............: ${BUILD_SHARED_LIBS}")
message("Build directory....................: ${PROJECT_BINARY_DIR}")
message("Source directory...................: ${PROJECT_SOURCE_DIR}")
message("Install directory..................: ${CMAKE_INSTALL_PREFIX}")

message("")
message("AR command.........................: ${CMAKE_AR}")
message("RANLIB command.....................: ${CMAKE_RANLIB}")

if(CMAKE_C_COMPILER)
  message("")
  message("C compiler.........................: ${CMAKE_C_COMPILER}")
  message("C compiler flags ..................: ${CMAKE_C_FLAGS}")
  message("C compiler flags (debug)...........: ${CMAKE_C_FLAGS_DEBUG}")
  message("C compiler flags (release).........: ${CMAKE_C_FLAGS_RELEASE}")
  message("C compiler flags (release+debug)...: ${CMAKE_C_FLAGS_RELWITHDEBINFO}")
endif()

if(CMAKE_CXX_COMPILER)
  message("")
  message("CXX compiler.......................: ${CMAKE_CXX_COMPILER}")
  message("CXX standard.......................: ${CMAKE_CXX_STANDARD}")
  message("CXX compiler flags ................: ${CMAKE_CXX_FLAGS}")
  message("CXX compiler flags (debug).........: ${CMAKE_CXX_FLAGS_DEBUG}")
  message("CXX compiler flags (release).......: ${CMAKE_CXX_FLAGS_RELEASE}")
  message("CXX compiler flags (release+debug).: ${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
endif()

message("")
message("EXE linker flags...................: ${CMAKE_EXE_LINKER_FLAGS}")
message("EXE linker flags (debug)...........: ${CMAKE_EXE_LINKER_FLAGS_DEBUG}")
message("EXE linker flags (release).........: ${CMAKE_EXE_LINKER_FLAGS_RELEASE}")
message("EXE linker flags (release+debug)...: ${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO}")

message("")
message("------------- Options -------------")
message("COMPUTE_BACKEND_TYPE...............: ${COMPUTE_BACKEND_TYPE}")

message("")
message("COMPUTE_WITH_MPI...................: ${COMPUTE_WITH_MPI}")
message("COMPUTE_WITH_OPENMP................: ${COMPUTE_WITH_OPENMP}")
message("COMPUTE_WITH_XSMM..................: ${COMPUTE_WITH_XSMM}")

message("")
message("HAVE_XSMM..........................: " ${HAVE_XSMM})
message("HAVE_FPGA..........................: " ${HAVE_FPGA})
message("HAVE_POSIT.........................: " ${HAVE_POSIT})
message("HAVE_FIXPNT........................: " ${HAVE_FIXPNT})
message("HAVE_MPI...........................: " ${HAVE_MPI})
message("HAVE_OPENMP........................: " ${HAVE_OPENMP})
