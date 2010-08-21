#!/bin/bash

./build.sh
qemu -fda floppy.img -m 32 -no-kvm
