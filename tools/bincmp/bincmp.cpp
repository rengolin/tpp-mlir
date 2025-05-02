/*===-- bincmp.cpp - Binary comparison tool ---------------------===*/
// %5 = vector.transfer_read %arg0[%iv, %c0], %cst : tensor<8x8xbf16>, vector<8xbf16>
// %3 = vector.bitcast %5 : vector<8xbf16> to vector<8xi16>
// vector.print %3 : vector<8xi16>

#include <vector>
#include <string>
#include <iostream>
#include <fstream>

#include "libxsmm_math.h"

#define SUCCESS 0
#define ERROR_USAGE 1
#define ERROR_FILE_SIZE 2
#define ERROR_BAD_SHAPE 3
#define ERROR_BAD_NORM 4

using namespace std;

// Data, M and N for norm calculation
struct Matrix {
  vector<size_t> data;
  size_t M;
  size_t N;
  Matrix() : M(0), N(0) {}
};

// Format:
// ( 0, 15877, 15899, 15406, 14789, 16025, 15817, 15416 )
// ( 0, 0, 0, 15693, 15876, 15475, 0, 0 )
// ( 0, 0, 0, 0, 0, 0, 0, 0 )
// ( 15904, 0, 0, 15879, 15956, 0, 15749, 15902 )
// ( 15935, 15845, 16071, 15809, 15937, 0, 15892, 0 )
// ( 0, 0, 0, 15978, 0, 15999, 0, 0 )
// ( 0, 15265, 16002, 0, 0, 15819, 0, 15570 )
// ( 0, 15830, 0, 0, 0, 15819, 15992, 15920 )

void print_matrix(Matrix &m) {
  assert(m.data.size() == m.M*m.N);
  for (size_t i=0; i<m.M; i++) {
    std::cout << "( ";
    for (size_t j=0; j<m.N; j++) {
      std::cout << m.data[i*m.M+j] << " ";
    }
    std::cout << ")\n";
  }
}

Matrix read_file(fstream& file) {
  Matrix m;
  size_t M=0, N=0;
  string token;
  while (file >> token) {
    if (token == "(")
      continue;

    if (token == ")") {
      if (m.N && m.N != N) {
        cerr << "ERROR: Rows have different lengths (" << m.N << ", " << N << ")\n";
        exit(ERROR_BAD_SHAPE);
      }
      m.N = N;
      N = 0;
      M++;
      continue;
    }
    size_t value = atol(token.c_str());
    m.data.push_back(value);
    N++;
  }
  m.M = M;

  return m;
}

int diff_file(libxsmm_datatype datatype, fstream& fileA, fstream& fileB) {
  auto matrixA = read_file(fileA);
  std::cout << "LHS: ["<< matrixA.M << "," << matrixA.N << "]\n";
  print_matrix(matrixA);

  auto matrixB = read_file(fileB);
  std::cout << "RHS: ["<< matrixB.M << "," << matrixB.N << "]\n";
  print_matrix(matrixB);
  if (matrixA.M != matrixB.M || matrixA.N != matrixB.N) {
    std::cerr << "ERROR: Matrix shapes different\n";
    return ERROR_BAD_SHAPE;
  }
  auto error = check_matrix(datatype, &matrixA.data[0], &matrixB.data[0], 8, matrixA.M, matrixA.N);
  if (error) {
    std::cerr << "ERROR: Matrices different\n";
    return ERROR_BAD_NORM;
  }

  std::cerr << "SUCCESS\n";
  return SUCCESS;
}

libxsmm_datatype parse_libxsmm_datatype(const char* str) {
  if (strncmp("I8", str, 2) == 0)
    return LIBXSMM_DATATYPE_I8;
  else if (strncmp("I32", str, 3) == 0)
    return LIBXSMM_DATATYPE_I32;
  else if (strncmp("HF8", str, 3) == 0)
    return LIBXSMM_DATATYPE_HF8;
  else if (strncmp("BF8", str, 3) == 0)
    return LIBXSMM_DATATYPE_BF8;
  else if (strncmp("F16", str, 3) == 0)
    return LIBXSMM_DATATYPE_F16;
  else if (strncmp("BF16", str, 4) == 0)
    return LIBXSMM_DATATYPE_BF16;
  else if (strncmp("F32", str, 3) == 0)
    return LIBXSMM_DATATYPE_F32;
  else if (strncmp("F64", str, 3) == 0)
    return LIBXSMM_DATATYPE_F64;
  else
    return LIBXSMM_DATATYPE_UNSUPPORTED;
}

void usage() {
  std::cerr << "Calculates the norm of the difference between two binary files.\n\n";
  std::cerr << "usage: bincmp <datatype> <path-A> <path-B>\n";
  std::cerr << "Datatype: I8, I32, HF8, BF8, F16, BF16, F32, F64.\n\n";
  exit(ERROR_USAGE);
}

int main(int argc, char *const argv[]) {
  if (argc != 4)
    usage();
  
  auto datatype = parse_libxsmm_datatype(argv[1]);
  if (datatype == LIBXSMM_DATATYPE_UNSUPPORTED)
    usage();

  fstream fileA{argv[2]};
  fstream fileB{argv[3]};
  if (!fileA.is_open() || !fileB.is_open())
    usage();

  std::cerr << "TY: " << datatype << ", LHS: " << argv[2] << ", RHS: " << argv[3] << "\n";
  return diff_file(datatype, fileA, fileB);
}
