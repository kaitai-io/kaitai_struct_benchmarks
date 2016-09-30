cmake_minimum_required(VERSION 2.6)

project(KS_BENCHMARK_CPP_STL)
find_package(ZLIB REQUIRED)

set(CMAKE_CXX_STANDARD 14)

set(KS_PATH ../../compiled/cpp_stl)
set(RUNTIME_SRC_PATH ../../../runtime/cpp_stl)

set(SPEC_SOURCES
	main.cpp
	run_benchmark_process_xor.cpp
	run_ext2.cpp
	run_pcap.cpp
)

set(KS_SOURCES
	${KS_PATH}/benchmark_process_xor.cpp
	${KS_PATH}/ext2.cpp
	${KS_PATH}/pcap.cpp
)

set(RUNTIME_SOURCES
	${RUNTIME_SRC_PATH}/kaitai/kaitaistream.cpp
)

add_executable(ks_tests
	${SPEC_SOURCES}
	${KS_SOURCES}
	${RUNTIME_SOURCES}
)

include_directories(
	"${PROJECT_BINARY_DIR}"
	"${KS_PATH}"
	"${RUNTIME_SRC_PATH}"
        "${ZLIB_INCLUDE_DIRS}"
)

target_link_libraries(ks_tests
	"${ZLIB_LIBRARIES}"
)
