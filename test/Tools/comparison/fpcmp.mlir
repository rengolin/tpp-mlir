// RUN: fpcmp -a 0.001 -r 0.001 -i %S/reference.out %S/reference.out 2>&1 | FileCheck %s --allow-empty --check-prefix=IDENTICAL
// RUN: fpcmp -a 0.001 -r 0.001 -i %S/reference.out %S/variance.out 2>&1 | FileCheck %s --allow-empty --check-prefix=SMALL-VARIANCE
// RUN: /bin/true || fpcmp -a 0.0001 -r 0.0001 -i %S/reference.out %S/variance.out 2>&1 | FileCheck %s --check-prefix=LARGE-VARIANCE
// RUN: /bin/true || fpcmp -a 0.001 -r 0.001 -i %S/reference.out %S/rows-flipped.out 2>&1 | FileCheck %s --check-prefix=FLIPPED
// RUN: /bin/true || fpcmp -a 0.1 -r 0.1 -i %S/reference.out %S/different.out 2>&1 | FileCheck %s --check-prefix=DIFFERENT

// IDENTICAL-NOT: abs. diff
// IDENTICAL-NOT: Out of tolerance

// SMALL-VARIANCE-NOT: abs. diff
// SMALL-VARIANCE-NOT: Out of tolerance

// LARGE-VARIANCE: Compared: 1.584500e+04 and 1.584800e+04
// LARGE-VARIANCE: abs. diff = 3.000000e+00 rel.diff = 1.892983e-04
// LARGE-VARIANCE: Out of tolerance: rel/abs: 1.000000e-04/1.000000e-04

// FLIPPED: Compared: 1.587700e+04 and 0.000000e+00
// FLIPPED: abs. diff = 1.587700e+04 rel.diff = 1.000000e+00
// FLIPPED: Out of tolerance: rel/abs: 1.000000e-04/1.000000e-04

// DIFFERENT: Compared: 0.000000e+00 and 3.123100e+04
// DIFFERENT: abs. diff = 3.123100e+04 rel.diff = 1.000000e+00
// DIFFERENT: Out of tolerance: rel/abs: 1.000000e-04/1.000000e-04
