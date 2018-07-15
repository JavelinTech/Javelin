# general configuration
include Makefile.header

# root device while making the image. this can be FLOPPY, /dev/sth or empty in which case the default of /dev/hd6 is used
ROOT_DEVICE =

JAVELIN_SIZE = 2883		# 2888 - 1 - 4

ROOTFS_IMAGE = javelinRootFS.img

LDFLAGS += -Ttext 0 -e kernelStart
CFLAGS += -Iinclude
CPP += -Iinclude

SUBSYSTEMS = kernel/kernel.o fs/fs.o mm/mmLinked.o

DRIVERS = drivers/drivers.o

MATH =

LIBS = lib/lib.a

.c.s:
	$(CC) $(CFLAGS) -S -o $*.s $<

.s.o:
	$(AS) -o $*.o $<

.c.o:
	$(CC) $(CFLAGS) -c -o $*.o $<

.PHONY: all qemu clean

all : Javelin

Javelin : x86/boot x86/setup system
	$(STRIP) system
	$(OBJCOPY) -O binary -R .note -R .comment system
	dd if=x86/boot bs=512 count=1 of=Javelin
	dd if=x86/setup seek=1 bs=512 count=4 of=Javelin
	dd if=system seek=5 bs=512 count=$(JAVELIN_SIZE) of=Javelin
	sync
	rm system
	sync

system : x86/startKernel.o init/initKernel.o \
			$(SUBSYSTEMS) $(DRIVERS) $(MATH) $(LIBS)
	$(LD) $(LDFLAGS) x86/startKernel.o init/initKernel.o $(SUBSYSTEMS) $(DRIVERS) $(MATH) $(LIBS) -o system

x86/startKernel.o : x86/startKernel.S
	make startKernel.o -C x86/

kernel/kernel.o :
	make -C kernel

fs/fs.o :
	make -C fs

mm/mmLinked.o :
	make -C mm

lib/lib.a:
	make -C lib

drivers/drivers.o:
	make -C drivers

x86/setup: x86/setup.S
	make setup -C x86

x86/boot: x86/boot.S
	make boot -C x86

qemu : Javelin
	qemu-system-x86_64 -m 16M -fda Javelin

clean :
	rm -f Javelin x86/boot x86/setup
	rm -f init/*.o system x86/*.o
	for i in x86 lib kernel drivers fs mm; do make clean -C $$i; done

# depedencies
init/initKernel.o : init/initKernel.c
