//
// Created by gjm on 13.07.18.
//

#ifndef JAVELIN_CTYPE_H
#define JAVELIN_CTYPE_H

#define _U	0x01	// upper
#define _L	0x02	// lower
#define _D	0x04	// digit
#define _C	0x08	// control
#define _P	0x10	// punct
#define _S	0x20	// white space
#define _X	0x40	// hex digit
#define _SP	0x80	// hard space (0x20)

extern unsigned char _ctype[];
extern char _cTemp;

#define isalnum(c) ((_ctype+1)[c]&(_U|_L|_D))
#define isalpha(c) ((_ctype+1)[c]&(_U|_L))
#define iscntrl(c) ((_ctype+1)[c]&(_C))
#define isdigit(c) ((_ctype+1)[c]&(_D))
#define isgraph(c) ((_ctype+1)[c]&(_P|_U|_L|_D))
#define islower(c) ((_ctype+1)[c]&(_L))
#define isprint(c) ((_ctype+1)[c]&(_P|_U|_L|_D|_SP))
#define ispunct(c) ((_ctype+1)[c]&(_P))
#define isspace(c) ((_ctype+1)[c]&(_S))
#define isupper(c) ((_ctype+1)[c]&(_U))
#define isxdigit(c) ((_ctype+1)[c]&(_D|_X))

#define isascii(c) (((unsigned) c)<=0x7f)
#define toascii(c) (((unsigned) c)&0x7f)

#define tolower(c) (_cTemp=c,isupper(_cTemp)?_cTemp-('A'-'a'):_cTemp)
#define toupper(c) (_cTemp=c,islower(_cTemp)?_cTemp-('a'-'A'):_cTemp)

#endif //JAVELIN_CTYPE_H
