#!/bin/bash

echo "Kernel Compilation:"
echo "    -   Assembling bootloader..."
nasm -i "kernel_src/" -f bin -o kernelbin/loader.o kernelsrc/loader.asm

echo "    -   Compiling kernel..."
gcc -o kernelbin/kernel.o -c kernelsrc/kernel.c -nostdlib -nostartfiles -nodefaultlibs #-masm=intel

echo "    -   Linking..."
#ld -T kernel_src/linker.ld -o kernel_bin/os.bin kernel_bin/loader.o kernel_bin/kernel.o
ld -o kernelbin/os.bin kernelbin/loader.o kernelbin/kernel.o

echo "    -   Copying to build/boot/fc_krnl"
cp kernelbin/kernel.o build/boot/fc_krnl

echo "Creating bootdisk image:"
echo "    -   Creating floppy image"
bin/pad floppy.img 0 1474560
echo "    -   Formatting to FAT"
mkfs -t vfat floppy.img
echo "    -   Mounting"
rmdir mnt > /dev/null
mkdir mnt
sudo chown $USERNAME mnt
sudo losetup /dev/loop0 floppy.img
sudo mount -t vfat /dev/loop0 mnt
echo "    -   Copying files"
sudo cp -r build/* mnt
echo "    -   Unmounting"
sudo umount /dev/loop0
sudo losetup -d /dev/loop0
echo "    -   Installing GRUB"
cat grubscript | grub --device-map=/dev/null --batch

echo "Done."
