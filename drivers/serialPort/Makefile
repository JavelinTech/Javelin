include ../../Makefile.header

LDFLAGS += -r
CFLAGS += -I../../include
CPP += -I../../include

OBJECTS = serialPortInit.o

.c.S:
	@$(CC) $(CFLAGS) -S -o $*.s $<

.c.o:
	@$(CC) $(CFLAGS) -c -o $*.o $<

.S.o:
	$(AS) -o $*.o $<

serialPort.o : $(OBJECTS)
	$(LD) $(LDFLAGS) -o serialPort.o $(OBJECTS)

clean :
	rm -f *.o *.a