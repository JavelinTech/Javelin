//
// Created by gjm on 13.07.18.
//

#ifndef JAVELIN_STDARG_H
#define JAVELIN_STDARG_H

typedef char *va_list;

#define __va_roundSizeOfType(TYPE)  \
  (((sizeof (TYPE) + sizeof (int) - 1) / sizeof (int)) * sizeof (int))



#define va_start(AP, LASTARG) 						\
    (AP = ((char *) &(LASTARG) + __va_roundSizeOfType (LASTARG)))

void va_end (va_list);		// Defined in gnulibc
#define va_end(AP)

#define va_arg(AP, TYPE)						\
 (AP += __va_roundSizeOfType (TYPE),					\
    *((TYPE *) (AP - __va_roundSizeOfType (TYPE))))

#endif //JAVELIN_STDARG_H
