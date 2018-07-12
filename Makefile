AS = as --32
LD = ld
LDFLAGS = -m elf_i386
CC = gcc
CFLAGS = -g -m32 -fno-builtin -fno-stack-protector -fomit-frame-pointer -fstrength-reduce
CPP = coo -nostdinc
AR = ar
STRIP = strip
OBJCOPY = objcopy

ROOTFS_IMAGE = javelinRootFS.img

# size of ramdisk device in blocks
RAMDISK = #-DRAMDISK=512

LDFLAGS += -Ttext 0 -e kernelStart
CFLAGS += $(RAMDISK) -Iinclude
CPP += -Iinclude

.PHONY: all start clean
