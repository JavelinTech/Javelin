include ../Makefile.header

LDFLAGS += -Ttext 0

all : boot setup

boot : boot.S
	$(AS) -o boot.o boot.S
	$(LD) $(LDFLAGS) -o boot boot.o
	$(OBJCOPY) -R .pdr -R .comment -R .note -S -O binary boot

setup : setup.S
	$(AS) -o setup.o setup.S
	$(LD) $(LDFLAGS) -o setup setup.o
	$(OBJCOPY) -R .pdr -R .comment -R .note -S -O binary setup

startKernel.o : startKernel.S
	$(AS) -o startKernel.o startKernel.S

clean :
	rm -f boot boot.o setup setup.o startKernel.o