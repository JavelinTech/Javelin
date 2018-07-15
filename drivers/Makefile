include ../Makefile.header

LDFLAGS += -r
CFLAGS += -I../include
CPP += -I../include

OBJECTS = blockDeviceInit.o charDeviceInit.o

.c.S:
	@$(CC) $(CFLAGS) -S -o $*.s $<

.c.o:
	@$(CC) $(CFLAGS) -c -o $*.o $<

.S.o:
	$(AS) -o $*.o $<

drivers.o : $(OBJECTS)
	$(LD) $(LDFLAGS) -o drivers.o $(OBJECTS)

clean :
	rm -f *.o *.a

charDeviceInit.o : charDeviceInit.c
blockDeviceInit.o : blockDeviceInit.c