//
// Created by gjm on 15.07.18.
//

#include <types.h>

#include <javelin/drivers/block.h>              // only for data structures, without defining MAJOR_DEVICE_NUMBER

BlockDevice blockDevices[NUMBER_OF_DEVICES] = {
        {NULL, NULL},               // no device - reserved
        {NULL, NULL},               // ramdisk     - currently NOT supported
        {NULL, NULL},               // floppy
        {NULL, NULL},               // hdd
        {NULL, NULL},               // ttyx ????
        {NULL, NULL},               // tty ?????
        {NULL, NULL}                // lp ??????
};

DeviceRequest requests[NUMBER_OF_REQUESTS];

/**
 * Initializes block devices' layer.
 */
void blockDeviceInit() {
    for(int i = 0; i < NUMBER_OF_REQUESTS;i++) {
        requests[i].device = -1;                // mark that means that this DeviceRequest doesn't correspond to any block device.
        requests[i].nextEntry = NULL;
    }
}