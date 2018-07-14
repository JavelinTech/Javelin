.globl parallelPortISR, deviceNotAvailableException, coprocessorException

.align 2
coprocessorException:
	a: jmp a        # later change

.align 2
deviceNotAvailableException:
	b: jmp b        # later change

parallelPortISR:
    c: jmp c        # later change