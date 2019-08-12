#!/bin/bash

# The initial build
# Set wee_alloc as a smaller allocator.
# We do it here instead of Cargo.toml, to keep
# the default allocator in the native Rust library build.
wasm-pack build --release

echo "Initial size"

wc -c pkg/intersection_wasm_bg.wasm

# Optimize wasm
# NOTE: Again, setting -Os did not decrease the size,
# so might as well optimise for speed.
# You might need to install wasm-opt from binaryen:
# https://github.com/WebAssembly/binaryen/releases
wasm-opt pkg/intersection_wasm_bg.wasm -O3 -o pkg/intersection_wasm_bg.wasm

echo "Size after wasm-opt"
wc -c pkg/intersection_wasm_bg.wasm

echo "Size after gzip"
gzip -9 < pkg/intersection_wasm_bg.wasm | wc -c
