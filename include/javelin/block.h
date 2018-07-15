//
// Created by gjm on 15.07.18.
//

#ifndef JAVELIN_BLOCK_H
#define JAVELIN_BLOCK_H

/**
 * Number of currently supported block devices.
 */
#define NUMBER_OF_DEVICES         7

/**
 * Number of entries in the request-queue.
 */
#define NUMBER_OF_REQUESTS        32

typedef struct {
    int device;
    int command;                // R/W - Read or Write
    int errors;
    unsigned long sector;
    unsigned long numberOfSectors;
    char *buffer;
    /*
     * Process *waitingProcess;         // process which is waiting for complexion of this operation - represented by DeviceRequest instance
     * BufferHead *bufferHead;
     */
    struct DeviceRequest *nextEntry;           // next DeviceRequest in queue
} DeviceRequest;

typedef struct {
    void (*deviceRequestFunction)();
    DeviceRequest *currentDeviceRequest;
} BlockDevice;

extern BlockDevice blockDevices[NUMBER_OF_DEVICES];
extern DeviceRequest requests[NUMBER_OF_REQUESTS];

/**
 * Every block device must have this type of construction here:
 *
 * #if (MAJOR_DEVICE_NUMBER == numberOfThisDevice)              // MAJOR_DEVICE_NUMBER > 0
 *  #define DEVICE_NAME "name"
 *  #define DEVICE_ISR deviceISR           <------ optional - not every device has its own interrupt
 *  #define DEVICE_REQUEST requestFunction
 *  #define DEVICE_NUMBER(device) logicalNumberOfDevice
 *  #define DEVICE_ON(device) switchDeviceOn
 *  #define DEVICE_OFF(device) switchDeviceOff
 * #endif
 */
#ifdef MAJOR_DEVICE_NUMBER

// Devices
#if (MAJOR_DEVICE_NUMBER == 1)      // currently ramdisk not supported
    // ramdisk
#endif

#if (MAJOR_DEVICE_NUMBER == 2)
    // floppy
#endif

#if (MAJOR_DEVICE_NUMBER == 3)
    // HDD
#endif

// Things that must be defined only if this file is included by driver of some block device that defines MAJOR_DEVICE_NUMBER.

#endif

/**
 * Initializes block devices' layer.
 */
void blockDeviceInit();

#endif //JAVELIN_BLOCK_H
