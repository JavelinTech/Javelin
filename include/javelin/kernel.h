//
// Created by gjm on 13.07.18.
//

#ifndef JAVELIN_KERNEL_H
#define JAVELIN_KERNEL_H

#include <types.h>

/*
 * Offset from start of struct the member of type type
 */
#define OFFSET_OF(type, member)  ((size_t) &((type *) 0)->member)

/**
 * Sets up exceptions' handlers and default ISR for hardware interrupts.
 */
void setIDTHandlers();

#endif //JAVELIN_KERNEL_H
