# bootsector
.code16

# ROOT_DEVICE:
#   1) 0x000 - floppy
#   2) 0x301 - first partition on second disk drive
    .equ ROOT_DEVICE, 0x301

# JAVELIN_SIZE is the number of multiplication of 16 B to be loaded.
# 0x3000 is 0x30000 B = 196 KB, more than needed for current Javelin
    .equ JAVELIN_SIZE, 0x3000
    .equ JAVELIN_START_SEGMENT, 0x1000
    .equ JAVELIN_END_SEGMENT, JAVELIN_START_SEGMENT + JAVELIN_SIZE

# this file is loaded at 0x7C00 by BIOS and moves itself at 0x90000
# then loads setup after itself at 0x90200 and kernel at 0x10000

# read errors will result in a unbreakable loop

    .equ SETUP_LENGTH, 4        # 4 setup sectors
    .equ SETUP_SEGMENT, 0x9020

    .equ BOOT_SEGMENT, 0x07C0
    .equ RELOCATE_SEGMENT, 0x9000   # segment after relocation

# sections
    .global beginText, beginData, beginBss
    .global endText, endData, endBss
.text
beginText:

.data
beginData:

.bss
beginBss:


.global _start
.text

    ljmp $BOOT_SEGMENT, $_start
_start:

# relocation
    mov $BOOT_SEGMENT, %ax
    mov %ax, %ds

    mov $RELOCATE_SEGMENT, %ax
    mov %ax, %es

    mov $256, %cx
    sub %si, %si
    sub %di, %di
    rep movsw
    ljmp $RELOCATE_SEGMENT, $afterRelocate

afterRelocate:
    mov %cs, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %ss
    mov $0xFF00, %sp        # stack at 0x9FF00

# load setup.S
loadSetup:
    # es set up
    mov $0x0000, %dx    # drive 0, head 0
    mov $0x0002, %cx    # sector 2, track 0
    mov $0x0200, %bx    # address = 512 in RELOCATE_SEGMENT pointed by es
    .equ TEMP, 0x0200 + SETUP_LENGTH
    mov $TEMP, %ax   # number of function = 2; number of sectors = SETUP_LENGTH
    int $0x13
    jnc loadSetupSuccess

    mov $0x0000, %dx
    mov $0x0000, %ax    # reset floppy
    int $0x13
    jmp loadSetup
loadSetupSuccess:

# get drive parameters
    mov $0x00, %dl
    mov $0x0800, %ax    # get drive parameters
    int $0x13
    mov $0x00, %ch

    mov %cx, %cs:sectors+0
    mov $RELOCATE_SEGMENT, %ax
    mov %ax, %es

# print message
    mov $0x03, %ah  # read cursor position
    xor %bh, %bh
    int $0x10

    mov $25, %cx
    mov $0x0007, %bx    # page 0, attribute 7
    mov $bootMessage, %bp
    mov $0x1301, %ax    # write string with moving the cursor
    int $0x10

# load Javelin at 0x10000
    mov $JAVELIN_START_SEGMENT, %ax
    mov %ax, %es
readJavelin:
    test $0x0FFF, %ax
hang:   jne hang        # es must be on 64 KB alignment
    xor %bx, %bx        # segment offset = 0

repeatRead:
    mov %es, %ax
    cmp $JAVELIN_END_SEGMENT, %ax   # if we loaded all sectors
    jb read1
    jmp readDone
read1:
    mov %cs:sectors+0, %ax
    sub sectorsRead, %ax
    mov %ax, %cx
    shl $9, %cx
    add %bx, %cx
    jnc read2
    je read2
    xor %ax, %ax
    sub %bx, %ax
    shr $9, %ax
read2:
    call readTrack
    mov %ax, %cx
    add sectorsRead, %ax
    cmp %cs:sectors+0, %ax
    jne read3
    mov $1, %ax
    sub head, %ax
    jne read4
    incw track
read4:
    mov %ax, head
    xor %ax, %ax
read3:
    mov %ax, sectorsRead
    shl $9, %cx
    add %cx, %bx
    jnc repeatRead
    mov %es, %ax
    add $0x1000, %ax
    mov %ax, %es
    xor %bx, %bx
    jmp repeatRead

readDone:
# Javelin loaded
# switch off floppy motor
    push %dx
    mov $0x3F2, %dx
    mov $0, %al
    outsb
    pop %dx

# jump to the setup.S
    ljmp $SETUP_SEGMENT, $0

readTrack:
    push	%ax
	push	%bx
	push	%cx
	push	%dx
	mov	track, %dx
	mov	sectorsRead, %cx
	inc	%cx
	mov	%dl, %ch
	mov	head, %dx
	mov	%dl, %dh
	mov	$0, %dl
	and	$0x0100, %dx
	mov	$2, %ah
	int	$0x13
	jc	badRead
	pop	%dx
	pop	%cx
	pop	%bx
	pop	%ax
	ret
badRead:	mov	$0, %ax
	mov	$0, %dx
	int	$0x13
	pop	%dx
	pop	%cx
	pop	%bx
	pop	%ax
    jmp readTrack

# variables
sectors:
    .word 0
sectorsRead:
    .word 1 + SETUP_LENGTH
head:
    .word 0
track:
    .word 0

bootMessage:
    .byte 13, 10
    .ascii "Javelin is starting"
    .byte 13,10,13,10

.org 508
rootDevice:
    .word ROOT_DEVICE

.word 0xAA55

.text
endText:
.data
endData:
.bss
endBss:
