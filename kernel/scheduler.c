//
// Created by gjm on 12.07.18.
//

#include <javelin/mm.h>

long userStack[PAGE_SIZE >> 2];

struct {
    long *a;
    short b;
} userStackStart = {
      &userStack[PAGE_SIZE >> 2], 0x10
};