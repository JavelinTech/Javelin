//
// Created by gjm on 14.07.18.
//

#include <asm/hardwareServices.h>
#include <javelin/hardwareStructures.h>

// externs from idtExceptions.S
extern void divideException();
extern void debugException();
extern void nmiException();
extern void int3Exception();
extern void overflowException();
extern void boundsException();
extern void invalidOPCodeException();
extern void doubleFaultException();
extern void coprocessorSegmentOverrunException();
extern void invalidTSSException();
extern void segmentNotPresentException();
extern void stackSegmentException();
extern void generalProtectionFaultException();
extern void coprocessorException();
extern void irq13();

extern void defaultISR();

// externs from syscalls.S
extern void parallelPortISR();
extern void deviceNotAvailableException();
extern void coprocessorException();

// externs from pageFault.S
extern void pageFaultException();

void doubleFaultExceptionHandler(long esp, long error_code) {
    for(;;);
}

void generalProtectionFaultExceptionHandler(long esp, long error_code) {
    for(;;);
}

void divideExceptionHandler(long esp, long error_code) {
    for(;;);
}

void int3ExceptionHandler(long * esp, long error_code,
             long fs,long es,long ds,
             long ebp,long esi,long edi,
             long edx,long ecx,long ebx,long eax) {
    for(;;);
}

void nmiExceptionHandler(long esp, long error_code) {
    for(;;);
}

void overflowExceptionHandler(long esp, long error_code) {
    for(;;);
}

void boundsExceptionHandler(long esp, long error_code) {
    for(;;);
}

void invalidOPCodeExceptionHandler(long esp, long error_code) {
    for(;;);
}

void coprocessorSegmentOverrunExceptionHandler(long esp, long error_code) {
    for(;;);
}

void invalidTSSExceptionHandler(long esp,long error_code) {
    for(;;);
}

void segmentNotPresentExceptionHandler(long esp,long error_code) {
    for(;;);
}

void stackSegmentExceptionHandler(long esp,long error_code) {
    for(;;);
}

void coprocessorExceptionHandler(long esp, long error_code) {
    for(;;);
}

void defaultISRHandler(long esp, long error_code) {
    for(;;);
}

/**
 * Sets up exceptions' handlers and default ISR for hardware interrupts.
 */
void setIDTHandlers() {
    // Exceptions
    setKernelIDTEntry(0, &divideException);
    setKernelIDTEntry(1, &debugException);
    setKernelIDTEntry(2, &nmiException);
    //
    setUserIDTEntry(3, &int3Exception);
    setUserIDTEntry(4, &overflowException);
    setUserIDTEntry(5, &boundsException);
    //
    setKernelIDTEntry(6, &invalidOPCodeException);
    setKernelIDTEntry(7, &deviceNotAvailableException);
    setKernelIDTEntry(8, &doubleFaultException);
    setKernelIDTEntry(9, &coprocessorSegmentOverrunException);
    setKernelIDTEntry(10, &invalidTSSException);
    setKernelIDTEntry(11, &segmentNotPresentException);
    setKernelIDTEntry(12, &stackSegmentException);
    setKernelIDTEntry(13, &generalProtectionFaultException);
    setKernelIDTEntry(14, &pageFaultException);
    setKernelIDTEntry(15, &defaultISR);
    setKernelIDTEntry(16, &coprocessorException);

    // Hardware interrupts
    int i = 17;
    for(;i < 48;i++) {
        setKernelIDTEntry(0, &defaultISR);
    }
    setKernelIDTEntry(45, &irq13);          // coprocessor x87 ISR

    // enable some interrupts by sending command to 2 PICs
    outbDelayed(inbDelayed(0x21) & 0xFB, 0x21);
    outb(inbDelayed(0xA1) & 0xDF, 0xA1);

    setKernelIDTEntry(39, &parallelPortISR);
}