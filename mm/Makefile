include ../Makefile.header

LDFLAGS += -r
CFLAGS += -I../include
CPP += -I../include

OBJECTS = mm.o pageFault.o

.c.S:
	@$(CC) $(CFLAGS) -S -o $*.s $<

.c.o:
	@$(CC) $(CFLAGS) -c -o $*.o $<

.S.o:
	$(AS) -o $*.o $<

mmLinked.o : $(OBJECTS)
	$(LD) $(LDFLAGS) -o mmLinked.o $(OBJECTS)

clean :
	rm -f *.o *.a

mm.o : mm.c
pageFault.o : pageFault.S