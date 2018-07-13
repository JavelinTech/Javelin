include ../Makefile.header

CFLAGS += -I../include
CPP += -I../include

OBJECTS = ctype.o errno.o

.c.s:
	$(CC) $(CFLAGS) -S -o $*.s $<

.s.o:
	$(AS) -o $*.o $<

.c.o:
	$(CC) $(CFLAGS) -c -o $*.o $<

lib.a : $(OBJECTS)
	$(AR) rcs lib.a $(OBJS)

clean :
	rm -f *.o *.a

# depedencies
ctype.s ctype.o : ctype.c
errno.s errno.o : errno.c