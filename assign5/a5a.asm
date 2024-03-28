// Minori Olguin
// 30035923
// CPSC 355 Assignment 5a
// Description:  Reads input from user with a c program containing main. Using the input from user, the program calls a series of 
// 		 assembly coded functions to preform basic queue operations, including, enqueue, dequeue, display, queueEmpty and 
//		 queueFull, user can terminate the program by input '4'. Basic error handling implemented.

QUEUESIZE = 8										// QUEUESIZE constant
MODMASK = 0x7										// MODMASK constant
FALSE = 0										// FALSE constant
TRUE = 1										// TRUE constant

define(head_base_r, x9)									// Defining a register for head base address
define(tail_base_r, x10)                                                                // Defining a register for tail base address
define(queue_base_r, x11)								// Defining a register for queue base address
define(value_r, w12)									// Defining a register for value
define(head_r, w19)									// Defining a register for head value
define(tail_r, w20)									// Defining a register for tail value
define(count_r, w21)									// Defining a register for count
define(i_r, w22)									// Defining a register for i index
define(j_r, w23)									// Defining a register for j index

		.text									// Text section
enqueue_fmt:	.string "\nQueue overflow! Cannot enqueue into a full queue.\n"		// String initialization for enqueue
dequeue_fmt:	.string "\nQueue underflow! Cannot dequeue from an empty queue.\n"	// String initialization for dequeue
display_empty:	.string "\nEmpty queue\n"						// String initialization for display empty queue
display_fmt:	.string "\nCurrent queue contents:\n"					// String initialization for display queue
queue_fmt:	.string "  %d"								// String initialization for display queue value
head_fmt:	.string "<-- head of queue"						// String initialization for head label
tail_fmt:	.string "<-- tail of queue"						// String initialization for tail label
newline_fmt:	.string "\n"								// String initialization for new line

                .data									// Data section
		.global head								// Making head variable visible to other programs
head: 		.word -1								// Initializing head
		.global tail								// Making tail variable visible to other programs
tail: 		.word -1								// Initializing tail
 		.global queue								// Making queue visible to other programs
queue: 		.word QUEUESIZE * 4							// Initializing queue 

		.text									// Text section
		.balign 4								// Making program divisible by 4
		.global enqueue								// Making enqueue function visible to other programs
		.global dequeue								// Making dequeue function visible to other programs
		.global queueFull							// Making queueFull function visible to other programs
		.global queueEmpty							// Making queueEmpty function visible to other programs
		.global display								// Making display function visible to other programs


// Enqueue Function
enqueue:										// Enqueue function 
		stp 	x29, x30, [sp, -16]!						// Allocating memory space for function
		mov 	x29, sp 							// Moving sp to fp
	
		mov 	value_r, w0							// Moving the input value from w0 to the value register
		bl 	queueFull							// Calling queueFull function

		cmp 	w0, TRUE							// Comparing w0 (return value from queueFull), TRUE
		b.ne 	enqueue_test							// Conditional branch to enqueue test if w0 and TRUE are not equal
			
		ldr 	x0, =enqueue_fmt						// Loading first argument for printf
		bl 	printf								// Calling printf
		b 	enqueue_done							// Unconditional branch to enqueue done

enqueue_test: 										// enqueue test label
		bl 	queueEmpty							// Calling queueEmpty function
		cmp 	w0, TRUE							// Comparing w0 (return value from queueEmpty), TRUE
		b.ne 	enqueue_else							// Branch to enqueue else if w0 and TRUE are not equal

		adrp 	head_base_r, head						// Loading address of head
		add 	head_base_r, head_base_r, :lo12:head				// Finish loading address of head
		str 	wzr, [head_base_r]						// Storing head to address of head

		mov 	tail_r, wzr							// Moving 0 to tail
		adrp 	tail_base_r, tail						// Loading address of tail
		add 	tail_base_r, tail_base_r, :lo12:tail				// Finish loading address of tail
		str 	tail_r, [tail_base_r]						// Storing tail to address of tail

		b 	enqueue_value							// Unconditional branch to enqueue value

enqueue_else:										// enqueue else label
		adrp 	tail_base_r, tail						// Loading the address of tail
		add 	tail_base_r, tail_base_r, :lo12:tail				// Finish loading address of tail
		ldr 	tail_r, [tail_base_r]						// Loading the value at the tail address 

		add 	tail_r, tail_r, 1						// Incrementing tail by 1
		and 	tail_r, tail_r, MODMASK						// Using MODMASK to ensure that tail stays in range of queue

		str 	tail_r, [tail_base_r]						// Storing tail to tail address

enqueue_value:										// enqueue value label
		adrp 	queue_base_r, queue						// Loading address of queue
		add 	queue_base_r, queue_base_r, :lo12:queue				// Finish loading address of queue
		str 	value_r, [queue_base_r, tail_r, SXTW 2]				// Storing value to address of queue[tail]

enqueue_done:
		ldp 	x29, x30, [sp], 16						// Deallocating memory
		ret									// Return control to calling code


// Dequeue Function
dequeue:
		stp 	x29, x30, [sp, -16]!						// Allocating memory for function
		mov 	x29, sp								// Moving sp to fp 

		bl 	queueEmpty							// Calling queueEmpty Function 
		cmp 	w0, TRUE							// Comparing w0 to TRUE
		b.ne 	dequeue_if							// Branch to dequeue if, if w0 does not equal TRUE

		ldr 	x0, =dequeue_fmt						// Loading 1st argument for printf 
		bl 	printf								// Calling printf
		mov 	value_r, -1							// Moving -1 to value register 

dequeue_if:										// dequeue if label
		adrp 	head_base_r, head						// Loading address of head
		add 	head_base_r, head_base_r, :lo12:head				// Finish loading address of head
		ldr 	head_r, [head_base_r]						// Loading value at the address of head

		adrp 	queue_base_r, queue						// Loading address of queue
		add 	queue_base_r, queue_base_r, :lo12:queue				// Finish loading address of queue
		ldr 	value_r, [queue_base_r, head_r, SXTW 2]				// Loading value at the address of queue

		adrp 	tail_base_r, tail						// Loading address of tail
		add 	tail_base_r, tail_base_r, :lo12:tail				// Finish loading address of tail
		ldr 	tail_r, [tail_base_r]						// Loading value at the address of tail

		cmp 	head_r, tail_r							// Comparing head and tail values 
		b.ne 	dequeue_else							// Conditional branch to dequeue else if head does not equal tail

		mov 	head_r, -1							// Moving -1 into head (head == -1)
		str 	head_r, [head_base_r]						// Storing head to the address of head
		str 	head_r, [tail_base_r]						// Storing head to the address of tail

		b 	dequeue_done							// Unconditional branch to dequeue done

dequeue_else:										// dequeue else label
		add 	head_r, head_r, 1						// Incrementing head by 1
		and 	head_r, head_r, MODMASK						// Using MODMASK to ensure head values stay in queue range
		str 	head_r, [head_base_r]						// Storing head to head address

dequeue_done:										// dequeue done label
		mov 	w0, value_r							// Moving value to w0 (return register)

		ldp 	x29, x30, [sp], 16						// Deallocating space 
		ret									// Return control to calling code


// Queue Full Function
queueFull:										// queueFull function 
		stp 	x29, x30, [sp, -16]!						// Allocating memory for function
		mov 	x29, sp 							// Moving sp to fp

		adrp 	head_base_r, head						// Loading address of head
		add 	head_base_r, head_base_r, :lo12:head				// Finish loading address of head	
		ldr 	head_r, [head_base_r]						// Loading value at address of head

		adrp 	tail_base_r, tail						// Loading address of tail
		add 	tail_base_r, tail_base_r, :lo12:tail				// Finish loading address of tail
		ldr 	tail_r, [tail_base_r]						// Loading value at address of tail
			
		add 	tail_r, tail_r, 1						// Incrementing tail by 1
		and 	tail_r, tail_r, MODMASK						// Using MODMASK to ensure that tail stays in queue range

		cmp 	tail_r, head_r							// Comparing head to tail
		b.ne 	queueFull_else							// Branch to queueFull else if not equal
		
		mov 	w0, TRUE							// Moving TRUE to w0 (return register)
		b 	queueFull_done							// Unconditional branch to queueFull done 

queueFull_else:										// queueFull else label
		mov 	w0, FALSE							// Moving FALSE to w0 (return register)

queueFull_done:										// queueFull done label
		ldp 	x29, x30, [sp], 16						// Deallocating memory
		ret									// Return control to calling code


// Queue Empty Function
queueEmpty:                                                     			// queueEmpty Function
    		stp 	x29, x30, [sp, -16]!                                   		// Allocating memory for function
    		mov 	x29, sp                                                		// Moving sp to fp

    		adrp 	head_base_r, head						// Loading address of head
    		add 	head_base_r, head_base_r, :lo12:head				// Finish loading address of head
    		ldr 	head_r, [head_base_r]						// Loading contents at address of head
    		cmp 	head_r, -1                                                  	// Comparing head to -1
    		b.eq 	queueEmpty_true                                      		// Conditional branch to done if head = -1

    		mov 	w0, FALSE							// Moving FALSE into w0 (return register)
    		b 	queueEmpty_done							// Unconditional branch to queueEmpty done

queueEmpty_true:    									// queueEmpty true label
		mov 	w0, TRUE  							// Else set w0 to true

queueEmpty_done:									// queueEmpty done label
    		ldp 	x29, x30, [sp], 16                                      	// Deallocate space
    		ret                                                         		// Return control to calling code


// Display Function 
display: 										// display Function
		stp 	x29, x30, [sp, -16]!						// Allocating memory for function
		mov 	x29, sp 							// Moving sp to fp

		mov 	count_r, wzr							// Moving zero to count register

		bl 	queueEmpty							// Branch link to queueEmpty function
		cmp 	w0, TRUE							// Comparing the return value to TRUE
		b.ne 	display_count							// If not equal, branch to display count

		ldr 	x0, =display_empty						// Loading the 1st argument for printf 
		bl 	printf								// Calling print f

		b 	display_done							// Unconditional branch to display done

display_count:										// display count label 
		adrp 	tail_base_r, tail						// Loading address for tail
		add 	tail_base_r, tail_base_r, :lo12:tail				// Finish loading address for tail
		ldr 	tail_r, [tail_base_r]						// Loading contents at address for tail

		adrp 	head_base_r, head						// Loading address for head
		add 	head_base_r, head_base_r, :lo12:head				// Finish loading address for head
		ldr 	head_r, [head_base_r]						// Loading contents at address of head 

		sub 	count_r, tail_r, head_r						// Subtracting head from tail and storing in count register
		add 	count_r, count_r, 1						// Incrementing count by 1

		cmp 	count_r, wzr							// Comparing count to 0
		b.gt	display_next							// If count is greater than 0, branch to display next

		add 	count_r, count_r, QUEUESIZE					// Add QUEUESIZE to count and store in count register

display_next:										// display next label 
		ldr 	x0, =display_fmt						// Loading 1st argument for printf
		bl 	printf								// Calling print f

		adrp 	head_base_r, head						// Loading address of head
		add 	head_base_r, head_base_r, :lo12:head				// Finish loading address of head
		ldr 	i_r, [head_base_r]						// Load value at address of head to index register
		mov 	j_r, wzr							// Set j register to 0
		b 	display_test							// Unconditional branch to display test

display_loop:										// display loop label 
		ldr 	x0, =queue_fmt							// Loading 1st argument for printf 
		adrp 	queue_base_r, queue						// Loading address of queue
		add 	queue_base_r, queue_base_r, :lo12:queue				// Finish loading address of queue
		ldr 	w1, [queue_base_r, i_r, SXTW 2]					// Loading value at queue address to 2nd arguemnet for printf
		bl 	printf								// Calling printf 
		
		adrp 	head_base_r, head						// Loading address of head
		add 	head_base_r, head_base_r, :lo12:head				// Finish loading address of head
		ldr 	head_r, [head_base_r]						// Loading value at head address to head register
		cmp 	i_r, head_r							// Comparing index regsiter to head register
		b.ne 	display_tail							// Branch to display tail if index does not equal head 
			
		ldr 	x0, =head_fmt							// Loading 1st printf argument 
		bl 	printf								// Calling printf

display_tail: 										// display tail label 
		adrp 	tail_base_r, tail						// Loading address of tail 	
		add 	tail_base_r, tail_base_r, :lo12:tail				// Finish loading address of tail
		ldr 	tail_r, [tail_base_r]						// Loading value at address of tail to tail regsiter 

		cmp 	i_r, tail_r							// Comparing index to tail
		b.ne 	display_newline							// Branching to display newline if index does not equal tail 

		ldr 	x0, =tail_fmt							// Loading 1st printf argument 
		bl 	printf								// Calling printf

display_newline: 									// display newline label 
		ldr 	x0, =newline_fmt						// Loading first printf arugment 
		bl 	printf								// Calling printf 

		add 	i_r, i_r, 1							// Incrementing index by 1
		and 	i_r, i_r, MODMASK						// Using modmask AND to ensure the queue stays in range

		add 	j_r, j_r, 1							// Incrementing j register by 1 

display_test:										// display test label 
		cmp 	j_r, count_r							// Comparing j to count 
		b.lt 	display_loop							// Branch to display loop if j is less than count

display_done:										// display done label
		ldp 	x29, x30, [sp], 16						// Deallocating space 
		ret									// Return control to calling code

