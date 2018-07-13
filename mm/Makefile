include ../Makefile.header

LDFLAGS += -r
CFLAGS += -I../include
CPP += -I../include

OBJECTS = mm.o

.c.s:
	@$(CC) $(CFLAGS) -S -o $*.s $<

.c.o:
	@$(CC) $(CFLAGS) -c -o $*.o $<

.s.o:
	$(AS) -o $*.o $<

mmLinked.o : $(OBJECTS)
	$(LD) $(LDFLAGS) -o mmLinked.o $(OBJECTS)

clean :
	rm -f *.o *.a

mm.o : mm.c