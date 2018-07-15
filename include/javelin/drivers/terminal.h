//
// Created by gjm on 15.07.18.
//

#ifndef JAVELIN_TERMINAL_H
#define JAVELIN_TERMINAL_H

#define TERMINAL_BUFFER_SIZE        1024

typedef struct {
    unsigned long data;

    unsigned long head;
    unsigned long tail;

    /*
     * Process *processList;
     */
    char buffer[TERMINAL_BUFFER_SIZE];
} TerminalQueue;

/**
 * Initializes the terminal.
 */
void terminalInit();

#endif //JAVELIN_TERMINAL_H
