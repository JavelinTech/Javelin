AS = as --32
LD = ld
LDFLAGS = -m elf_i386
CC = gcc
CFLAGS = -g -m32 -fno-builtin -fno-stack-protector -fomit-frame-pointer -fstrength-reduce
CPP = cpp -nostdinc
AR = ar
STRIP = strip
OBJCOPY = objcopy

ROOTFS_IMAGE = javelinRootFS.img

CFLAGS += -Iinclude
CPP += -Iinclude
OBJCOPY_FLAGS = -R .pdr -R .comment -R .note -S -O binary

ASM_OBJECTS = 	boot.o \
				setup.o \
				startKernel.o

C_OBJECTS = 	initKernel.o \
				scheduler.o

%.o: init/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.o: kernel/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

.PHONY: all qemu clean

all : Javelin

JAVELIN_SIZE = 2883		# 2888 - 1 - 4

Javelin : clean $(ASM_SOURCES) $(C_OBJECTS)
	$(AS) -o boot.o x86/boot.S
	$(LD) $(LDFLAGS) -Ttext 0 -o boot boot.o
	$(OBJCOPY) $(OBJCOPY_FLAGS) boot
	$(AS) -o setup.o x86/setup.S
	$(LD) $(LDFLAGS) -Ttext 0 -o setup setup.o
	$(OBJCOPY) $(OBJCOPY_FLAGS) setup
	$(AS) -o startKernel.o x86/startKernel.S

	$(LD) $(LDFLAGS) -r -o initKernel initKernel.o
	$(LD) $(LDFLAGS) -r -o scheduler scheduler.o
	$(LD) $(LDFLAGS) -Ttext 0 -e kernelStart startKernel.o $(C_OBJECTS) -o system
	$(STRIP) system
	$(OBJCOPY) -O binary -R .note -R .comment system

	dd if=boot bs=512 count=1 of=Javelin
	dd if=setup seek=1 bs=512 count=4 of=Javelin
	dd if=system seek=5 bs=512 count=$(JAVELIN_SIZE) of=Javelin

qemu : Javelin
	qemu-system-x86_64 -m 16M -fda Javelin

clean :
	rm -f $(C_OBJECTS)
	rm -f $(ASM_OBJECTS)
	rm -f system*


ASM_SOURCES =	x86/boot.S \
				x86/setup.S \
				x86/startKernel.S

C_SOURCES = 	initKernel.c \
				scheduler.c