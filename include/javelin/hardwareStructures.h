//
// Created by gjm on 14.07.18.
//

#ifndef JAVELIN_HARDWARESTRUCTURES_H
#define JAVELIN_HARDWARESTRUCTURES_H

/**
 * Typical format of descriptor table.
 */
typedef struct {
    unsigned long firstDoubleWord;
    unsigned long secondDoubleWord;
} DescriptorTable[256];

extern unsigned long pageDirectory[1024];   // from x86/startKernel.S
extern DescriptorTable IDT, GDT;            // from x86/startKernel.S

#endif //JAVELIN_HARDWARESTRUCTURES_H
