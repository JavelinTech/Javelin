include ../Makefile.header

LDFLAGS += -r

CFLAGS += -I../include
CPP += -I../include

OBJECTS = scheduler.o idt.o idtExceptions.o syscalls.o

.c.S:
	$(CC) $(CFLAGS) -S -o $*.s $<
.S.o:
	$(AS) -o $*.o $<
.c.o:
	$(CC) $(CFLAGS) -c -o $*.o $<

kernel.o : $(OBJECTS)
	$(LD) $(LDFLAGS) -o kernel.o $(OBJECTS)

clean :
	rm -f *.o *.a

scheduler.s scheduler.o: scheduler.c
idt.s idt.o: idt.c
idtExceptions.o: idtExceptions.S
syscalls.o: syscalls.S