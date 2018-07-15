include ../../Makefile.header

LDFLAGS += -r
CFLAGS += -I../../include
CPP += -I../../include

OBJECTS = screenInit.o

.c.S:
	@$(CC) $(CFLAGS) -S -o $*.s $<

.c.o:
	@$(CC) $(CFLAGS) -c -o $*.o $<

.S.o:
	$(AS) -o $*.o $<

screen.o : $(OBJECTS)
	$(LD) $(LDFLAGS) -o screen.o $(OBJECTS)

clean :
	rm -f *.o *.a