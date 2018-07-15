include ../../Makefile.header

LDFLAGS += -r
CFLAGS += -I../../include
CPP += -I../../include

OBJECTS = terminalInit.o

.c.S:
	@$(CC) $(CFLAGS) -S -o $*.s $<

.c.o:
	@$(CC) $(CFLAGS) -c -o $*.o $<

.S.o:
	$(AS) -o $*.o $<

terminal.o : $(OBJECTS)
	$(LD) $(LDFLAGS) -o terminal.o $(OBJECTS)

clean :
	rm -f *.o *.a