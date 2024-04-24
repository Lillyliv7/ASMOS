#!/bin/bash
sh build_scripts/build.sh
qemu-system-i386 -hda build/os.bin
