set(CMAKE_COMPILE_WARNING_AS_ERROR ON)

add_llvm_executable(bincmp
  bincmp.cpp)

llvm_update_compile_flags(bincmp)

install(TARGETS bincmp RUNTIME DESTINATION bin)
