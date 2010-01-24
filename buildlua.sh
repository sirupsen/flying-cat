#!/bin/bash

cd kernelsrc/lua/src/
make clean
cd ../../..

gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/lapi.o		kernelsrc/lua/src/lapi.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/lcode.o		kernelsrc/lua/src/lcode.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/ldebug.o		kernelsrc/lua/src/ldebug.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/ldo.o		kernelsrc/lua/src/ldo.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/ldump.o		kernelsrc/lua/src/ldump.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/lfunc.o		kernelsrc/lua/src/lfunc.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/lgc.o		kernelsrc/lua/src/lgc.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/llex.o		kernelsrc/lua/src/llex.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/lmem.o		kernelsrc/lua/src/lmem.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/lobject.o	kernelsrc/lua/src/lobject.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/lopcodes.o	kernelsrc/lua/src/lopcodes.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/lparser.o	kernelsrc/lua/src/lparser.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/lstate.o		kernelsrc/lua/src/lstate.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/lstring.o	kernelsrc/lua/src/lstring.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/ltable.o		kernelsrc/lua/src/ltable.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/ltm.o		kernelsrc/lua/src/ltm.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/lundump.o	kernelsrc/lua/src/lundump.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/lvm.o		kernelsrc/lua/src/lvm.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/lzio.o		kernelsrc/lua/src/lzio.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/lauxlib.o	kernelsrc/lua/src/lauxlib.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/lbaselib.o	kernelsrc/lua/src/lbaselib.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/lmathlib.o	kernelsrc/lua/src/lmathlib.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/ltablib.o	kernelsrc/lua/src/ltablib.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/lstrlib.o	kernelsrc/lua/src/lstrlib.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/loadlib.o	kernelsrc/lua/src/loadlib.c
gcc -Ikernelsrc/pdclib/includes -Ikernelsrc/pdclib/internals -nostdlib -c -o kernelsrc/lua/src/linit.o		kernelsrc/lua/src/linit.c

rm kernelbin/luao/* > /dev/null

cp kernelsrc/lua/src/*.o kernelbin/luao/
