//
// Created by gjm on 14.07.18.
//

#ifndef JAVELIN_HARDWARESERVICES_H
#define JAVELIN_HARDWARESERVICES_H

#define sti()   __asm__("sti" : :)
#define cli()   __asm__("cli" : :)

#define setIDTEntry(entryAddress, type, dpl, isrAddress) \
    __asm__("movw %%dx,%%ax\n\t" \
        "movw %0,%%dx\n\t" \
        "movl %%eax,%1\n\t" \
        "movl %%edx,%2" \
        : \
        : "i" ((short) (0x8000+(dpl<<13)+(type<<8))), \
        "o" (*((char *) (entryAddress))), \
        "o" (*(4 + (char *) (entryAddress))), \
        "d" ((char *) (isrAddress)),"a" (0x00080000))

/**
 * Sets IDT entry accessible only for kernel mode.
 */
#define setKernelIDTEntry(n, isrAddress)    setIDTEntry(&IDT[n], 15, 0, isrAddress)

/**
 * Sets IDT entry accessible for kernel and user mode.
 */
#define setUserIDTEntry(n, isrAddress)      setIDTEntry(&IDT[n], 15, 3, isrAddress)

/**
 * Send byte to port without delay.
 */
#define outb(value, port)   __asm__("outb %%al,%%dx"::"a" (value),"d" (port))

/**
 * Fetch byte from port without delay.
 * value; is used to have the result in correct form
 */
#define inb(port) ({ \
    unsigned char value; \
    __asm__ volatile("inb %%dx,%%al":"=a" (value):"d" (port)); \
    value; \
    })

/**
 * Send byte to port with delay.
 */
#define outbDelayed(value,port) \
    __asm__("outb %%al,%%dx\n" \
    "\tjmp 1f\n" \
    "1:\tjmp 1f\n" \
    "1:"::"a" (value),"d" (port))

/**
 * Fetch byte from port with delay.
 * value; is used to have the result in correct form
 */
#define inbDelayed(port) ({ \
    unsigned char value; \
    __asm__ volatile("inb %%dx,%%al\n" \
	"\tjmp 1f\n" \
	"1:\tjmp 1f\n" \
	"1:":"=a" (value):"d" (port)); \
    value; \
    })

#endif //JAVELIN_HARDWARESERVICES_H
