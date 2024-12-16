#!/usr/bin/env bash

# Refs:
# https://reviews.llvm.org/D115893
# https://github.com/llvm/llvm-project/blob/586ecdf205aa8b3d162da6f955170a6736656615/llvm/lib/Target/WebAssembly/WebAssemblyLowerEmscriptenEHSjLj.cpp#L187

set -e

rm -rf ./out
rm -rf ./lib
mkdir -p ./out
mkdir -p ./lib

cflags="-v -O3"

# emcc -o ./out/emcc-emscripten.html $cflags --minify=0 ./test/main.c

# emcc -o ./out/emcc-wasm.html -sSUPPORT_LONGJMP=wasm $cflags --minify=0 ./test/main.c

# $WASI_SDK_PATH/bin/clang --target=wasm32-wasi \
#                          -I./include \
#                          $cflags \
#                          -fwasm-exceptions \
#                          -mllvm -wasm-enable-eh \
#                          -mllvm -wasm-enable-sjlj \
#                          ./test/main.c \
#                          ./src/emscripten_tempret.s \
#                          ./src/emscripten_setjmp.c \
#                          -o ./test/main.wasm \
#                          -mexception-handling

$WASI_SDK_PATH/bin/clang $cflags \
                         -c \
                         -o ./out/emscripten_tempret.o \
                         ./src/emscripten_tempret.s \

$WASI_SDK_PATH/bin/clang -I./include \
                         $cflags \
                         -fwasm-exceptions \
                         -c \
                         -o ./out/emscripten_setjmp.o \
                         ./src/emscripten_setjmp.c \

$WASI_SDK_PATH/bin/llvm-ar qc ./lib/libsetjmp.a ./out/emscripten_tempret.o ./out/emscripten_setjmp.o
$WASI_SDK_PATH/bin/llvm-ranlib ./lib/libsetjmp.a
rm -rf ./out/*.o

$WASI_SDK_PATH/bin/clang $cflags \
                         --target=wasm32-wasi-threads -pthread -matomics -mbulk-memory \
                         -c \
                         -o ./out/emscripten_tempret.o \
                         ./src/emscripten_tempret.s \

$WASI_SDK_PATH/bin/clang -I./include \
                         $cflags \
                         --target=wasm32-wasi-threads -pthread -matomics -mbulk-memory \
                         -fwasm-exceptions \
                         -c \
                         -o ./out/emscripten_setjmp.o \
                         ./src/emscripten_setjmp.c \

$WASI_SDK_PATH/bin/llvm-ar qc ./lib/libsetjmp-mt.a ./out/emscripten_tempret.o ./out/emscripten_setjmp.o
$WASI_SDK_PATH/bin/llvm-ranlib ./lib/libsetjmp-mt.a
rm -rf ./out/*.o

$WASI_SDK_PATH/bin/clang -I./include \
                         $cflags \
                         -mllvm -wasm-enable-sjlj \
                         ./test/main.c \
                         -c -o ./out/main.o

$WASI_SDK_PATH/bin/clang -v -O3 \
                         ./out/main.o \
                         -L./lib \
                         -lsetjmp \
                         -o ./test/main.wasm

# $WASI_SDK_PATH/bin/clang -I./include \
#                          $cflags \
#                          -mllvm -wasm-enable-sjlj \
#                          ./test/main.c \
#                          -L./lib \
#                          -lsetjmp \
#                          -o ./test/main.wasm
