# Top-level CMakeLists.txt for millipede

cmake_minimum_required(VERSION 2.6)

PROJECT(millipede)

ADD_SUBDIRECTORY(apps)
ADD_SUBDIRECTORY(common)

OPTION(BUILD_TESTS "Build the test applications?" OFF)
IF(BUILD_TESTS)
	ADD_SUBDIRECTORY(tests)
ENDIF(BUILD_TESTS)
