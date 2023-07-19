PROJECT(playboy)

CMAKE_MINIMUM_REQUIRED(VERSION 3.16)

SET(CMAKE_C_FLAGS_DEBUG "-O0 -Wall -g -ggdb")
SET(CMAKE_C_FLAGS_RELEASE "-O3 -Wall")
SET(CMAKE_CXX_STANDARD 14)
SET(CMAKE_CXX_FLAGS_DEBUG "-O0 -Wall -g -ggdb")
SET(CMAKE_CXX_FLAGS_RELEASE "-O3 -Wall")

SET(CMAKE_BUILD_TYPE Release)
SET(EXECUTABLE_OUTPUT_PATH bin)
SET(LIBRARY_OUTPUT_PATH lib)

ADD_DEFINITIONS(-DSIMPLE_MESSAGE)
ADD_DEFINITIONS(-w)

INCLUDE_DIRECTORIES(nes/)
INCLUDE_DIRECTORIES(pkg/include)

LINK_DIRECTORIES(${CMAKE_SOURCE_DIR}/pkg/lib)

###############################################################################
##############################  module  #######################################
###############################################################################

AUX_SOURCE_DIRECTORY(nes/ NES)
ADD_LIBRARY(nes ${NES})

###############################################################################
###########################   application  ####################################
###############################################################################

SET(MOKA app/main.cpp)
ADD_EXECUTABLE(moka ${MOKA})
TARGET_LINK_LIBRARIES(moka nes sfml-system sfml-audio sfml-network sfml-graphics sfml-window)









