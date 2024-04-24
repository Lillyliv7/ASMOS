#!/bin/bash
nasm src/bootloader/boot.asm -f bin -o build/boot.bin
nasm src/kernel/kernel.asm -f bin -o build/kernel.bin
cat build/boot.bin build/kernel.bin > build/os.bin

