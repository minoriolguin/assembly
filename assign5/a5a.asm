// Minori Olguin
// 30035923
// CPSC 355 Assignment 5a
// Description: 
// 	

define(QUEUESIZE, 8)
define(MODMASK, 0x7)
define(FALSE, 0)
define(TRUE, 1)
define(base_r, x9)
define(head_r, w19)
define(tail_r, w20)
define(value_r, w21)
define(queue_r, x22)
define(index_r, w23)
define(j_r, w24)
define(count_r, w25)



		.text
enqueue_fmt:	.string "\nQueue overflow! Cannot enqueue into a full queue.\n"
dequeue_fmt:	.string "\nQueue underflow! Cannot dequeue from an empty queue.\n"
display_empty:	.string "\nEmpty queue\n"
display_fmt:	.string "\nCurrent queue contents:\n"
display_queue:	.string "  %d"
head_fmt:	.string "<-- head of queue"
tail_fmt:	.string "<-- tail of queue"
newline_fmt:	.string "\n"


                .data
                .global head_m
                .global tail_m
head_m:         .word -1
tail_m:         .word -1

                .bss
                .global queue_m
queue_m:        .skip QUEUESIZE * 4



		.text
		.balign 4
		.global enqueue
		.global dequeue
		.global queueFull
		.global queueEmpty
		.global display


// Enqueue Function 
enqueue:										// enqueue subroutine
    		stp 	x29, x30, [sp, -16]!                                   		// Allocating memory for program
    		mov 	x29, sp                                                		// Moving sp to fp

		mov 	value_r, w0							// Move the input value into value register

		bl 	queueFull							// Branch link to queue full
		cmp 	w0, TRUE							// Check if the queue full value is true 
		b.ne 	enqueue_test							// Conditional branch to enqueue test, if false

		ldr 	x0, =enqueue_fmt						// 
		bl 	printf								// 
		b 	enqueue_done

enqueue_test:
		bl 	queueEmpty
		cmp 	w0, TRUE
		b.ne 	enqueue_else

		adrp	base_r, head_m
		add	base_r, base_r, :lo12:head_m
		str 	wzr, [base_r]
		adrp	base_r, tail_m
		add	base_r, base_r, :lo12: tail_m
		str 	wzr, [base_r]
		b 	enqueue_next

enqueue_else:
	    	adrp 	base_r, tail_m
    		add 	base_r, base_r, :lo12:tail_m
    		ldr 	tail_r, [base_r]

		add 	tail_r, tail_r, 1
		and	tail_r, tail_r, MODMASK
		str	tail_r, [base_r]

enqueue_next:
    		ldr 	tail_r, [base_r]
		adrp 	base_r, queue_m
    		add 	base_r, base_r, :lo12:queue_m
    		str 	value_r, [base_r, tail_r, SXTW 2]

enqueue_done:
    		ldp 	x29, x30, [sp], 16						// Deallocate space
    		ret 


// Dequeue Function
dequeue:                                                     				// dequeue subroutine
     		stp 	x29, x30, [sp, -16]!    	                      		// Allocating memory for program
     		mov 	x29, sp                                          		// Moving sp to fp

 		bl      queueEmpty             	        	                        // Branch link to queue empty
 		cmp     w0, TRUE	                  	        	        // Check if the queue empty value is true
 		b.ne    dequeue_test                                  	        	// Conditional branch to dequeue test, if false
	
 		ldr     x0, =dequeue_fmt	                            	        // 
 		bl      printf         	                                        	//
 		mov 	value_r, -1							//
 		b       dequeue_done							//

 dequeue_test:	
  		adrp	base_r, head_m							//
 		add	base_r, base_r, head_m						//
 		ldr	head_r, [base_r]
 									//
 		adrp	base_r, queue_m 						//
 		add     base_r, base_r, :lo12:queue_m					//
  		ldr     value_r, [base_r, head_r, SXTW 2]						//	
		
 		adrp	base_r, tail_m							//
 		add	base_r, base_r, :lo12:tail_m					//
 		ldr	tail_r, [base_r]						//

 		cmp	head_r, tail_r
 		b.ne	dequeue_else

 		mov	head_r, -1
 		adrp	base_r, head_m
 		add	base_r, base_r, :lo12:head_m
 		str	head_r, [base_r]
 		adrp	base_r, tail_m
 		add	base_r, base_r, :lo12:tail_m
 		str	head_r, [base_r]

 		b	dequeue_done							//

 dequeue_else:										//
 		add	head_r, head_r, 1
 		and	head_r, head_r, MODMASK

		adrp	base_r, head_m
		add	base_r, base_r, :lo12:head_m
		str 	head_r, [base_r]
 dequeue_done:										//
 		mov	w0, value_r							//
     		ldp 	x29, x30, [sp], 16                                   		// Deallocate space
  	   	ret 									// Return control to calling code 



// Queue Full Function
queueFull:                                          					// queueFull subroutine
    		stp 	x29, x30, [sp, -16]!                          			// Allocating memory for program
	    	mov 	x29, sp                                        			// Moving sp to fp

    		adrp 	base_r, tail_m							//
    		add 	base_r, base_r, :lo12:tail_m					//
    		ldr 	tail_r, [base_r]						//

		add 	tail_r, tail_r, 1						//
		and 	tail_r, tail_r, MODMASK						//

    		adrp 	base_r, head_m							//
   	 	add 	base_r, base_r, :lo12:head_m					//
    		ldr 	head_r, [base_r]						//

    		cmp 	tail_r, head_r                                                 	// if head == -1
	    	b.eq 	queueFull_true                                      		// Conditional branch to done

    		mov 	w0, FALSE							//
    		b 	queueFull_done							//

queueFull_true:    
		mov 	w0, TRUE  							// else set w0 to true

queueFull_done:
    		ldp 	x29, x30, [sp], 16                                      	// Deallocate space
    		ret 									//


// Queue Empty Function
queueEmpty:                                                     			// queueEmpty subroutine
    		stp 	x29, x30, [sp, -16]!                                   		// Allocating memory for program
    		mov 	x29, sp                                                		// Moving sp to fp

    		adrp 	base_r, head_m							//
    		add 	base_r, base_r, :lo12:head_m					//
    		ldr 	head_r, [base_r]						//
    		cmp 	head_r, -1                                                  	// if head == -1
    		b.eq 	queueEmpty_true                                      		// Conditional branch to done

    		mov 	w0, FALSE							//
    		b 	queueEmpty_done							//

queueEmpty_true:    									//
		mov 	w0, TRUE  							// else set w0 to true

queueEmpty_done:									//
    		ldp 	x29, x30, [sp], 16                                      	// Deallocate space
    		ret                                                         		// Return control to calling code


// Display Function
display:                                                     				// display subroutine
		stp	x29, x30, [sp, -16]!                                   		// Allocating memory for program
		mov 	x29, sp                                                		// Moving sp to fp

		bl 	queueEmpty
		cmp 	w0, TRUE
		b.ne 	display_count

		ldr 	x0, =display_empty
		bl 	printf
		b 	display_done

display_count:
		adrp 	base_r, head_m
		add 	base_r, base_r, :lo12:head_m
		ldr 	head_r, [base_r]

		adrp 	base_r, tail_m
		add 	base_r, base_r, :lo12:tail_m
		ldr 	tail_r, [base_r]

		sub 	count_r, tail_r, head_r
		add 	count_r, count_r, 1

		cmp 	count_r, wzr
		b.gt 	display_next

		add 	count_r, count_r, QUEUESIZE

display_next:
		ldr	x0, =display_fmt
		bl 	printf

		mov 	index_r, head_r
		mov 	j_r, 0
		b	display_test

display_loop:
		ldr 	x0, =display_queue
 		adrp	base_r, queue_m 						//
 		add     base_r, base_r, :lo12:queue_m					//
  		ldr     w1, [base_r, index_r, SXTW 2]
		bl 	printf

		cmp 	index_r, head_r
		b.ne	display_tail

		ldr 	x0, =head_fmt
		bl 	printf

display_tail:
		adrp 	base_r, tail_m
		add 	base_r, base_r, :lo12:tail_m
		ldr 	tail_r, [base_r]

		cmp 	index_r, tail_r
		b.ne	display_tail

		ldr 	x0, =tail_fmt
		bl 	printf

display_newline:
		ldr 	x0, =newline_fmt
		bl 	printf
		add 	index_r, index_r, 1
		and 	index_r, index_r, MODMASK
		add 	j_r, j_r, 1

display_test:
		cmp 	j_r, count_r
		b.lt 	display_loop

display_done:
		ldp 	x29, x30, [sp], 16                                     		// Deallocate space
		ret 									// Return control to calling code
