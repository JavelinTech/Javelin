include ../Makefile.header

LDFLAGS += -r
CFLAGS += -I../include
CPP += -I../include

OBJECTS = superblock.o

.c.S:
	@$(CC) $(CFLAGS) -S -o $*.s $<

.c.o:
	@$(CC) $(CFLAGS) -c -o $*.o $<

.S.o:
	$(AS) -o $*.o $<

fs.o : $(OBJECTS)
	$(LD) $(LDFLAGS) -o fs.o $(OBJECTS)

clean :
	rm -f *.o *.a

superblock.o : superblock.c