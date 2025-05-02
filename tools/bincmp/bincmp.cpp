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

Matrix read_file(fstream& file) {
  Matrix m;
  size_t M=0, N=0;
  string token;
  while (file >> token) {
    if (token == ")") {
      if (m.M && m.M != M) {
        cerr << "ERROR: Rows have different lengths (" << m.M << ", " << M << ")\n";
        exit(ERROR_BAD_SHAPE);
      }
      m.M = M;
      M = 0;
      N++;
      continue;
    }
    size_t value = atol(token.c_str());
    m.data.push_back(value);
    M++;
  }
  m.N = N;

  return m;
}

int diff_file(fstream& fileA, fstream& fileB) {
  auto matrixA = read_file(fileA);
  cerr << "LHS: ["<< matrixA.M << "," << matrixA.N << "]\n";
  auto matrixB = read_file(fileB);
  cerr << "RHS: ["<< matrixB.M << "," << matrixB.N << "]\n";
  if (matrixA.M != matrixB.M || matrixA.N != matrixB.N) {
    cerr << "ERROR: Matrix shapes different\n";
    return ERROR_BAD_SHAPE;
  }
  if (matrixA.data != matrixB.data) {
    cerr << "ERROR: Matrices different\n";
    return ERROR_BAD_NORM;
  }

cerr << "SUCCESS\n";
  return SUCCESS;
}

void usage() {
  fprintf(stderr, "usage: bincmp <path-A> <path-B>\n\n");
  fprintf(stderr, "Calculates the norm of the difference between two binary files.\n");
  exit(ERROR_USAGE);
}

int main(int argc, char *const argv[]) {
  if (argc != 3)
    usage();

  fstream fileA{argv[1]};
  fstream fileB{argv[2]};
  if (!fileA.is_open() || !fileB.is_open())
    usage();

  return diff_file(fileA, fileB);
}
