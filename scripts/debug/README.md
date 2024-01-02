# Debug Scripts

These scripts are used to debug the compiler output.

## Debug All Passes

### Purpose

To run MLIR through the compiler with `--mlir-print-ir-after-all`,
split the output into multiple files (`NNN.mlir`) and run a `diff` program
between any of those files that change the IR.

### Usage

Options:
* `-b bin_dir`: The binary directory (usually `build/bin`)
* `-i file.mlir`: Input MLIR file (optional)
* `-d tool`: Specifies a diff tool (default `diff`)
* `-m "opt1 opt2 ..."`: `mlir-gen` options
* `-o "opt1 opt2 ..."`: `tpp-opt` options

Examples:
```
// Run compiler over an MLIR file, uses `vimdiff`
./scripts/debug/debug_all_passes.sh \
  -b ./build/bin \
  -i file.mlir \
  -d vimdiff

// Generates an MLP with `mlir-gen`, uses `meld`
./scripts/debug/debug_all_passes.sh \
  -b ./build/bin \
  -m "--kernel=inference --bias --relu --float-width=16 --batch=256 --layers=1024,1024,1024,1024" \
  -d meld

// Default behaviour, runs `mlir-gen` & `tpp-opt` without args, uses `diff`
./scripts/debug/debug_all_passes.sh \
  -b ./build/bin
```

### Helpers

`split.py`: Splits the output of `--mlir-print-ir-after-all` into multiple files.

`diff.py`: Looks through a list of `NNN.mlir` files and shows the diff of each
pair of files when the IR changes (ex. `003.mlir -> 007.mlir`, `007.mlir -> 013.mlir`
etc.).

## Benchmark Verifier

### Purpose

To verify which benchmarks (through `mlir-gen` and `tpp-run` configs) generate
specific IR patterns (ex. fusion). With `tpp-run` printing IR and/or output, you
can `grep` for any particular pattern and the script will show which benchmarks
exhibit the pattern and which don't.

### Usage

Options:
* `-b bin_dir`: The binary directory (usually `build/bin`)
* `-c config_dir`: The benchmark config directory (usually `benchmarks/config`)
* `-i file.json`: A specific file, if specified. Otherwise, scan all JSON files.
* `-p early|mid|late`: Which stage to print the IR (default `none`)
* `-print`: Print output (optional, default silent). Careful, this can be large.
* `-grep "regexp"`: Search for the regexp in the IR and output.

Examples:
```
// Run compiler over all benchmarls, checks fusion in XSMM dialect
./scripts/debug/benchmark_verifier.sh \
  -b ./build/bin \
  -c ./benchmarks/config \
  -p mid \
  -grep "call @xsmm_fused_brgemm"
```
