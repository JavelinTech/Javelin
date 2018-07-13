# kernel startup code - 32-bit environment

.text
pageDirectory:     # this code will be overwriten by the page directory

.globl pageDirectory
.globl kernelStart
kernelStart:
	movl $0x10,%eax
	mov %ax,%ds
	mov %ax,%es
	mov %ax,%fs
    mov %ax,%gs

    lss userStackStart, %esp        # from kernel/scheduler.c

    call setIDT
    call setGDT

	movl $0x10,%eax
	mov %ax,%ds
	mov %ax,%es
	mov %ax,%fs
    mov %ax,%gs

    lss userStackStart, %esp        # from kernel/scheduler.c

# set WP bit in CR0
    movl %cr0, %eax
    andl $0x80000011, %eax
    orl $2, %eax
    movl %eax, %cr0
    jmp afterPagingStructures

# setIDT - IDT with 256 entries pointing to defaultISR
# Will be overwritten by the page tables.
setIDT:
    lea defaultISR, %edx
    movl $0x00080000, %eax
    movw %dx, %ax       # selector = 0x0008 - cs
    movw $0x8E00, %dx   # interrupt gate, dpl = 0, Present bit

    lea IDT, %edi
    mov $256, %ecx
fillIDT:
    movl %eax, (%edi)
    movl %edx, 4(%edi)
    addl $8, %edi
    dec %ecx
    jne fillIDT

    lidt IDTDescriptor
    ret

# setGDT - new GDT the same as in setup.S (new GDT because old will be overwritten)
# Will be overwritten by the page tables.
setGDT:
    lgdt GDTDescriptor
    ret
#################################
########KERNEL PAGE TABLES#######
# they are placed after the page directory, using 4 of them to span 16 MB of physical memory.

.org 0x1000
pg0:

.org 0x2000
pg1:

.org 0x3000
pg2:

.org 0x4000
pg3:

########KERNEL PAGE TABLES#######
#################################

#################################
# this area is used by the floppy-driver when DMA can't get a buffer-block

.org 0x5000
noDMAFloppyArea:
    .fill 1024, 1, 0
#################################

afterPagingStructures:
    call setPaging
    call main                          # init/initKernel.c
hang:
    jmp hang

# default ISR
.align 2
defaultISR:
    pushl %eax
    pushl %ecx
    pushl %edx
    push %ds
    push %es
    push %fs
    movl $0x10, %eax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs

    pushl $defaultISRMessage
    call printk

    popl %eax
    pop %fs
    pop %es
    pop %ds
    popl %edx
    popl %ecx
    popl %eax
iret    # ISR
defaultISRMessage:
    .asciz "Unknown interrupt occurred!\n\r"

# set paging by enabling paging bit in CR0
# page tables are set up, identity-mapping first 16 MB of RAM
.align 2
setPaging:
    movl $1024*5, %ecx      # 5 pages - pageDirectory + 4 page tables
    xorl %eax, %eax
    xorl %edi, %edi         # pageDirectory is at 0x0000 in RAM
    cld
    rep stosl

    # set bit P and user R/W
    movl $pg0+7, pageDirectory
    movl $pg1+7, pageDirectory+4
    movl $pg2+7, pageDirectory+8
    movl $pg3+7, pageDirectory+12
    movl $pg3+4092, %edi
    movl $0xFFF007, %eax        # 16 MB - 4096 + 7 (R/W user and P bit)

    std
fillPages:                      # fill pages backwards
    stosl
    subl $0x1000, %eax
    jge fillPages

    cld
    xorl %eax, %eax             # pageDirectory is at 0x0000 in RAM
    movl %eax, %cr3             # set page directory's location in CR3

    movl %cr0, %eax
    orl $0x80000000, %eax       # set Paging bit in CR0
    movl %eax, %cr0
    ret

.align 2
.word 0
IDTDescriptor:
    .word 256*8 - 1     # 256 IDT's entries
    .long IDT

.align 2
.word 0
GDTDescriptor:
    .word 256*8 - 1
    .long GDT

.align 8
IDT:
    .fill 256, 8, 0

GDT:
    .quad 0x0000000000000000	# null descriptor
    .quad 0x00c09a0000000fff	# 16 MB code
    .quad 0x00c0920000000fff	# 16 MB data
    .quad 0x0000000000000000	# temporary
    .fill 252,8,0           # space for other descriptors
