#
# Created by gjm on 14.07.18.
#

# exceptions handling
# memory page faults are handled by mm
# coprocessor exception, parallel port interrupt and device not available exceptions are handled by kernel

.globl divideException,debugException,nmiException,int3Exception,overflowException,boundsException,invalidOPCodeException
.globl doubleFaultException,coprocessorSegmentOverrunException
.globl invalidTSSException,segmentNotPresentException,stackSegmentException
.globl generalProtectionFaultException,coprocessorException,irq13,defaultISR

divideException:
    pushl $divideExceptionHandler
noErrorCode:
    xchgl %eax,(%esp)
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %edi
    pushl %esi
    pushl %ebp
    push %ds
    push %es
    push %fs
    pushl $0		# "error code"
    lea 44(%esp),%edx
    pushl %edx
    movl $0x10,%edx
    mov %dx,%ds
    mov %dx,%es
    mov %dx,%fs
    call *%eax
    addl $8,%esp
    pop %fs
    pop %es
    pop %ds
    popl %ebp
    popl %esi
    popl %edi
    popl %edx
    popl %ecx
    popl %ebx
    popl %eax
    iret

debugException:
    pushl $int3ExceptionHandler		# _do_debug
    jmp noErrorCode

nmiException:
    pushl $nmiExceptionHandler
    jmp noErrorCode

int3Exception:
    pushl $int3ExceptionHandler
    jmp noErrorCode

overflowException:
    pushl $overflowExceptionHandler
    jmp noErrorCode

boundsException:
    pushl $boundsExceptionHandler
    jmp noErrorCode

invalidOPCodeException:
    pushl $invalidOPCodeExceptionHandler
    jmp noErrorCode

coprocessorSegmentOverrunException:
    pushl $coprocessorSegmentOverrunExceptionHandler
    jmp noErrorCode

defaultISR:
    pushl $defaultISRHandler
    jmp noErrorCode

irq13:
    pushl %eax
    xorb %al,%al
    outb %al,$0xF0
    movb $0x20,%al
    outb %al,$0x20
    jmp 1f
1:	jmp 1f
1:	outb %al,$0xA0
    popl %eax
    jmp coprocessorExceptionHandler

doubleFaultException:
    pushl $doubleFaultExceptionHandler
withErrorCode:
    xchgl %eax,4(%esp)		# error code <-> %eax
    xchgl %ebx,(%esp)		# &function <-> %ebx
    pushl %ecx
    pushl %edx
    pushl %edi
    pushl %esi
    pushl %ebp
    push %ds
    push %es
    push %fs
    pushl %eax			# error code
    lea 44(%esp),%eax		# offset
    pushl %eax
    movl $0x10,%eax
    mov %ax,%ds
    mov %ax,%es
    mov %ax,%fs
    call *%ebx
    addl $8,%esp
    pop %fs
    pop %es
    pop %ds
    popl %ebp
    popl %esi
    popl %edi
    popl %edx
    popl %ecx
    popl %ebx
    popl %eax
    iret

invalidTSSException:
    pushl $invalidTSSExceptionHandler
    jmp withErrorCode

segmentNotPresentException:
    pushl $segmentNotPresentExceptionHandler
    jmp withErrorCode

stackSegmentException:
    pushl $stackSegmentExceptionHandler
    jmp withErrorCode

generalProtectionFaultException:
    pushl $generalProtectionFaultExceptionHandler
    jmp withErrorCode