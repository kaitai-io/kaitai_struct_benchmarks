# Kaitai Struct: benchmarks

This repository contains benchmarking suite for 
[Kaitai Struct](https://github.com/kaitai-io/kaitai_struct) project.

## Compile format specs (.ksy) into target languages

Run `./build-formats` to compile sample format specs (.ksy files)
located in `formats/` into source code for parsing these file formats
in various supported programming languages, to be located in
`compiled/$LANG`.

## Generate the data

We strive to use relatively large datasets for benchmarking purposes,
thus avoid general issues with micro- / nano-benchmarking, where the
unit under test is so small that lots of environment issues start to
play a big role.

It is unpractical to store big files in git repository, so instead of
providing binary data files, we provide small scripts that generate
these big binary files. All these scripts reside in `generate/`, and
there is a helper script that launches generation of all data files -
`./generate-all`.

After generation, you should get several large binary files in
`data/`, which will be used as input files for benchmarking purposes.

## Run the benchmarks

The source code for benchmarks itselves is located under `spec/$LANG`.

### C++/STL

* `./run-cpp_stl`

### Python

* `./run-python`

### Ruby

* `./run-ruby`
