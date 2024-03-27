// Minori Olguin 
// 30035923
// CPSC 355 Assignment 5a

define(QUEUESIZE, 8)
define(MODMASK, 0x7)
define(FALSE, 0)
define(TRUE, 1)
define(base_r, x19)
define(index_r, w20)

		.data
		.global head_m
//		.global tail_m
head_m:		.word -1
//tail_m:		.word -1

		.bss
		.global queue_m
queue_m:	.skip  QUEUESIZE * 4

		.text
		.balign 4
		.global queueEmpty

queueEmpty:							// queueEmpty subroutine
		stp 	x29, x30, [sp, -16]!			// Allocating memory for program 
		mov	x29, sp					// Moving sp to fp
		
		adrp	base_r, head_m
		add	base_r, base_r, :lo12:head_m
		ldr	w9, [base_r]
		cmp	w9, -1					// if head == -1 
		b.ne	queueEmpty_false			// Conditional branch to done
		
		mov 	w0, TRUE		
		b	queueEmpty_done
queueEmpty_false:
		mov	w0, FALSE				// else set w0 to false
queueEmpty_done:		
		ldp	x29, x30, [sp], 16			// Deallocate space
		ret						// Return control to calling code 
