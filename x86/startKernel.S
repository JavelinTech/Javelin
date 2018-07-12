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

a: jmp a
