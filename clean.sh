#!/bin/bash

cd kernelsrc

cd pdclib
make clean
cd ..

cd lua/src
make clean
cd ../..

cd ..
