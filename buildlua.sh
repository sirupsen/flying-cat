#!/bin/bash

cd kernelsrc/lua/src
make clean
make generic

rm liblua.a

ar rcu liblua.a lapi.o lcode.o ldebug.o ldo.o ldump.o lfunc.o lgc.o llex.o lmem.o \
				lobject.o lopcodes.o lparser.o lstate.o lstring.o ltable.o ltm.o  \
				lundump.o lvm.o lzio.o
				
cp liblua.a ../../../kernelbin/liblua.a

cd ../../..
