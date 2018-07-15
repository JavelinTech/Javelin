include ../Makefile.header

LDFLAGS += -r
CFLAGS += -I../include
CPP += -I../include

OBJECTS = blockDeviceInit.o charDeviceInit.o serialPort/serialPort.o screen/screen.o terminal/terminal.o

.c.S:
	@$(CC) $(CFLAGS) -S -o $*.s $<

.c.o:
	@$(CC) $(CFLAGS) -c -o $*.o $<

.S.o:
	$(AS) -o $*.o $<

drivers.o : $(OBJECTS)
	$(LD) $(LDFLAGS) -o drivers.o $(OBJECTS)

serialPort/serialPort.o:
	make -C serialPort

screen/screen.o:
	make -C screen

terminal/terminal.o:
	make -C terminal

clean :
	rm -f *.o *.a
	for i in screen serialPort terminal; do make clean -C $$i; done

# depedencies
charDeviceInit.o : charDeviceInit.c
blockDeviceInit.o : blockDeviceInit.c