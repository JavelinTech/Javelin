# get the system data from BIOS and pass them to the kernel through memory
# 0x90000 - 0x901FF - parameters to kernel

.code16

.equ RELOCATE_SEGMENT, 0x9000   # segment after relocation
.equ SETUP_SEGMENT, 0x9020
.equ JAVELIN_START_SEGMENT, 0x1000

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

    ljmp $SETUP_SEGMENT, $_start
_start:
    mov %cs, %ax
    mov %ax, %ds
    mov %ax, %es

# print message from setup
    mov $0x03, %ah
    xor %bh, %bh
    int $0x10

    mov $46, %cx
    mov $0x000B, %bx
    mov $setupMessage, %bp
    mov $0x1301, %ax
    int $0x10

# pass cursor position to the kernel
    mov $RELOCATE_SEGMENT, %ax
    mov %ax, %ds
    mov $0x03, %ah
    xor %bh, %bh
    int $0x10
    mov %dx, %ds:0      # 0x90000

# pass memory size in KB to the kernel
    mov $0x88, %ah
    int $0x15
    mov %ax, %ds:2

# pass display page, video mode and console width to the kernel
    mov $0x0F, %ah
    int $0x10
    mov %bx, %ds:4      # display page
    mov %ax, %ds:6      # video mode, console width

# pass EGA configuration to the kernel
    mov $0x12, %ah
    mov $0x10, %bl
    int $0x10
    mov %ax, %ds:8
    mov %bx, %ds:10
    mov %cx, %ds:12

# pass hd0 data to the kernel
    mov $0x0000, %ax
    mov %ax, %ds
    lds %ds:4*0x41, %si
    mov $RELOCATE_SEGMENT, %ax
    mov %ax, %es
    mov $0x0080, %di
    mov $0x10, %cx
    rep movsb

# pass hd1 data to the kernel
    mov $0x0000, %ax
    mov %ax, %ds
    lds %ds:4*0x46, %si
    mov $RELOCATE_SEGMENT, %ax
    mov %ax, %es
    mov $0x0090, %di
    mov $0x10, %cx
    rep movsb

# check first if there was hd1
    mov $0x01500, %ax
    mov $0x81, %dl
    int $0x13
    jc noHd1
    cmp $3, %ah
    je isHd1
noHd1:
    mov $RELOCATE_SEGMENT, %ax
    mov %ax, %es
    mov $0x0090, %di
    mov $0x10, %cx
    mov $0x00, %ax
    rep stosb
isHd1:

# SWITCH OFF INTERRUPTS
    cli         # SWITCH OFF INTERRUPTS

# relocate Javelin to 0x0000
    mov $0x0000, %ax
    cld
relocateJavelin:
    mov %ax, %es        # destination
    add $0x1000, %ax
    cmp $0x9000, %ax
    jz end
    mov %ax, %ds        # source
    sub %di, %di
    sub %si, %si
    mov $0x8000, %cx
    rep movsw
    jmp relocateJavelin
end:

    mov $SETUP_SEGMENT, %ax
    mov %ax, %ds
# setup empty GDT
    lgdt gdtDescriptor

# setup empty IDT
    lidt idtDescriptor

# enable A20 by Fast Gate A20
    inb $0x92, %al
    orb $0b00000010, %al
    outb %al, $0x92

# reprogram PIC controller
# hardware interrupts will be in IDT at the offsets from 0x20 up to 0x2F
    mov $0x11, %al
    out %al, $0x20
    .word 0x00eb, 0x00eb
    out %al, $0xA0
    .word 0x00eb, 0x00eb
    mov $0x20, %al
    out %al, $0x21
    .word 0x00eb, 0x00eb
    mov $0x28, %al
    out %al, $0xA1
    .word 0x00eb, 0x00eb
    mov $0x04, %al
    out %al, $0x21
    .word 0x00eb, 0x00eb
    mov $0x02, %al
    out %al, $0xA1
    .word 0x00eb, 0x00eb
    mov $0x01, %al
    out %al, $0x21
    .word 0x00eb, 0x00eb
    out %al, $0xA1
    .word 0x00eb, 0x00eb
    mov $0xFF, %al
    out %al, $0x21
    .word 0x00eb, 0x00eb
    out %al, $0xA1

# move to protected mode
    mov %cr0, %eax
    bts $0, %eax
    mov %eax, %cr0

# jump to startKernel.S
    .equ CODE_SELECTOR, 0x0008
    ljmp $(CODE_SELECTOR), $0      # 8 is code selector in GDT (second descriptor)
                         # offset = 0

GDT:
    # null descriptor
	.word	0,0,0,0

    # code descriptor
	.word	0x07FF		# 8Mb - limit=2047 (2048*4096=8Mb)
	.word	0x0000		# base address=0
	.word	0x9A00		# code read/exec
	.word	0x00C0		# granularity=4096, 386

    # data descriptor
	.word	0x07FF		# 8Mb - limit=2047 (2048*4096=8Mb)
	.word	0x0000		# base address=0
	.word	0x9200		# data read/write
    .word 0x00C0        # granularity=4096, 386

idtDescriptor:
    .word 0     # limit = 0
    .word 0, 0  # base = 0 <- doubleword

gdtDescriptor:
    .word 0x800 # 2048 = 256 GDT entries * 8 B for each entry
    .word 512 + GDT, 0x9    # GDT base (added 512 because setup is moved to 0x9020 * 0x10)

setupMessage:
    .byte 13,10
    .ascii "Setuping Javelin's execution environment"
    .byte 13,10,13,10

bootMessage:
    .byte 13, 10
    .ascii "Javelin is starting"
    .byte 13,10,13,10

.text
endText:
.data
endData:
.bss
endBss:
