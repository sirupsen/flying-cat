#!/bin/bash

cd kernelsrc/lua/src
make clean

#gcc -I "../../../kernelsrc/pdclib/*/" -I "../../../kernelsrc/pdclib/internals/" -I "kernelsrc/lua/src/" -o ../../../kernelbin/liblua.a \
#	-nostdlib -nostartfiles \
#		lapi.* lcode.* ldebug.* ldo.* ldump.* lfunc.* lgc.* llex.* lmem.* \
#		lobject.* lopcodes.* lparser.* lstate.* lstring.* ltable.* ltm.*  \
#		lundump.* lvm.* lzio.*

cd ../../..
