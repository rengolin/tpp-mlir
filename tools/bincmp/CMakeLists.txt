set(CMAKE_COMPILE_WARNING_AS_ERROR ON)

add_llvm_executable(bincmp
  bincmp.cpp)

llvm_update_compile_flags(bincmp)

target_include_directories(bincmp
  PUBLIC
    $<BUILD_INTERFACE:${XSMM_INCLUDE_DIRS}>)

target_link_options(bincmp PRIVATE
  -Wl,--no-as-needed
  -L${CMAKE_BINARY_DIR}/lib
  -ltpp_xsmm_runner_utils)

install(TARGETS bincmp RUNTIME DESTINATION bin)
