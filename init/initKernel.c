//
// Created by gjm on 12.07.18.
//

#include <javelin/fs.h>
#include <javelin/kernel.h>
#include <javelin/mm.h>

#include <javelin/block.h>      // only for init, without defining MAJOR_DEVICE_NUMBER

#define UPPER_MEMORY_KB     (*(unsigned short *) 0x90002)       // memory upper 1 MB in KB

#define BOOT_ROOT_DEVICE         (*(unsigned short *) 0x901FC)       // root device - we're reading from bootsector's memory

#define HDD_INFO            (*(HddInfo *) 0x90080)
typedef struct {
    char info[32];
} HddInfo;

// Memory management addresses
static long mainMemoryStart = 0;
static long mainMemoryEnd = 0;

static long bufferMemoryEnd = 0;

/**
 * Kernel initialization function.
 * Called from x86/startKernel.S
 */
void main() {
    // Interrupts are disabled.

    ROOT_DEVICE = BOOT_ROOT_DEVICE;         // initializing ROOT_DEVICE that is used to mount rootfs in fs/superblock.c

    HddInfo hddInfo = HDD_INFO;

    // Memory management
    mainMemoryEnd = (1 << 20) + (UPPER_MEMORY_KB << 10);        // 1 MB + UPPER_MEMORY_KB in MB
    mainMemoryEnd &= 0xFFFFF000;        // integer multiple of pages (ignore part that is less than one page at the end of memory)
    if(mainMemoryEnd > 16 * 1024 * 1024) {      // round to 16 MB
        mainMemoryEnd = 16 * 1024 * 1024;
    }

    // set bufferMemoryEnd
    if(mainMemoryEnd > 12 * 1024 * 1024) {
        bufferMemoryEnd = 4 * 1024 * 1024;
    } else if(mainMemoryEnd > 6 * 1024 * 1024) {
        bufferMemoryEnd = 2 * 1024 * 1024;
    } else {
        bufferMemoryEnd = 1 * 1024 * 1024;
    }

    mainMemoryStart = bufferMemoryEnd;
    /*
     * Memory layout:
     * |KERNEL|BUFFER|MAIN_MEMORY|
     */

    mainMemoryManagementInit(mainMemoryStart, mainMemoryEnd);
    setIDTHandlers();
    blockDeviceInit();

    for(;;)
        ;
}

// just for a while
void printk() {
//    for(;;)
//        ;
}