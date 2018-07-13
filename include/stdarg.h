//
// Created by gjm on 13.07.18.
//

#ifndef JAVELIN_STDARG_H
#define JAVELIN_STDARG_H

typedef char *va_list;

#define __va_roundSizeOfType(type)  \
  (((sizeof (type) + sizeof (int) - 1) / sizeof (int)) * sizeof (int))



#define va_start(ap, lastArgument) 						\
    (ap = ((char *) &(lastArgument) + __va_roundSizeOfType (lastArgument)))

void va_end(va_list);		// Defined in gnulibc
#define va_end(ap)

#define va_arg(ap, type)						\
 (ap += __va_roundSizeOfType (type),					\
    *((type *) (ap - __va_roundSizeOfType (type))))

#endif //JAVELIN_STDARG_H
