//
// Created by gjm on 12.07.18.
//

#ifndef JAVELIN_MM_H
#define JAVELIN_MM_H

#define PAGE_SIZE 4096          // 4 KB

/**
 * Initializes main memory management.
 * Initializes MemoryMap data structure that is used to management of main memory.
 *
 * @param startMainMemory
 * @param endMainMemory
 */
void mainMemoryManagementInit(long startMainMemory, long endMainMemory);

#endif //JAVELIN_MM_H
