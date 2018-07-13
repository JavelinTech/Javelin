include ../Makefile.header

LDFLAGS += -r

CFLAGS += -I../include
CPP += -I../include

OBJECTS = scheduler.o

.c.s:
	$(CC) $(CFLAGS) -S -o $*.s $<
.s.o:
	$(AS) -o $*.o $<
.c.o:
	$(CC) $(CFLAGS) -c -o $*.o $<

kernel.o : $(OBJECTS)
	$(LD) $(LDFLAGS) -o kernel.o $(OBJECTS)

clean :
	rm -f *.o *.a

scheduler.s scheduler.o: scheduler.c