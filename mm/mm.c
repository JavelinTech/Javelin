//
// Created by gjm on 13.07.18.
//

#include <javelin/mm.h>

#define LOW_MEMORY      0x100000            // first 1 MB of RAM
#define PAGED_MEMORY    (15 * 1024 * 1024)  // 15 MB (after LOW_MEMORY)
#define MEMORY_PAGES    (PAGED_MEMORY >> 12)    // PAGED_MEMORY in page's unit

#define USED_ENTRY      100     // mark of used entry in MemoryMap

#define MAP_NR(address) (((address) - LOW_MEMORY) >> 12)        // conversion physical address to number of page in paged main memory

static long HIGH_MEMORY = 0;            // end of paged main memory

// Data structure used to managing of paged main memory.
// In MemoryMap Javelin keeps the reference number (number of uses) of each page.
static unsigned char MemoryMap[MEMORY_PAGES] = {0};

/**
 * Initializes main memory management.
 * Initializes MemoryMap data structure that is used to management of main memory.
 *
 * @param startMainMemory
 * @param endMainMemory
 */
void mainMemoryManagementInit(long startMainMemory, long endMainMemory) {
    HIGH_MEMORY = endMainMemory;

    // Mark all entries of MemoryMap data structure as used.
    int i = 0;
    for(; i < MEMORY_PAGES;i++) {
        MemoryMap[i] = USED_ENTRY;
    }

    i = MAP_NR(startMainMemory);
    endMainMemory -= startMainMemory;
    endMainMemory >>= 12;

    while(endMainMemory-- > 0) {
        MemoryMap[i++] = 0;         // UNUSED entry
    }
}