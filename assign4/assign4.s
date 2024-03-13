// CPSC 355 W24 Assignment 1
// Minori Olguin UCID: 30035923
// Description: 
//	




origin_str:		.string "Cuboid %s origin = (%d, %d)\n"
base_str:		.string "\tBase width = %d   Base length = %d\n"
height_str:		.string "\tHeight = %d\n"
volume_str:		.string "\tVolume = %d\n\n"

initial_str:	.string "Initial cuboid values:\n"
changed_str:    .string "\nChanged cuboid values:\n"
first_str:		.string "first"
second_str:		.string "second"

	x_s = 0								// offset of xPoint_s from base of struct point
	y_s = 4								// offset of yPoint_s from base of struct point
	point_size = 8						// size of struct point

	width_s = 0							// stack from base of struct dimension
	length_s = 4						// stack from base of struct dimension
	dimension_size = 8					// size of dimension

	cuboid_origin = 0					// 
	cuboid_base = 8						// 
	cuboid_height = 16					// initialize height
	cuboid_volume = 20					// volume of the struct cuboid
	cuboid_offset = 16					// base offset of the cuboid
	cuboid_1 = 20						// assembler equate of cuboid 1
	cuboid_2 = 20						// assembler equate of cuboid 2
	total_size = cuboid_base			// calculate total_size

	alloc = -(16 + total_size) & -16	// define total memory allocation
	dealloc = -alloc					// set size to be deallocated
	cuboid_s = 16						// cuboid volume
	first_s = 16						// offset of cuboid_1
	second_s = 36	

	.balign 4

newCuboid:
	stp 	x29, x30, [sp, alloc]!							// Allocate 16 bytes of memory from the newCuboid frame record
	mov 	x29, sp											// Move the stack pointer to the frame pointer.

	mov 	w1, 0											// register w1 --> holds 0
	str 	w1, [x29, cuboid_s + cuboid_origin + x_s]	// storing w1 back into the stack

	mov 	w2, 0											// register w2 --> holds 0
	str 	w2, [x29, cuboid_s + cuboid_origin + y_s]		// storing w2 back into the stack

	mov 	w3, 2											// register w3 --> holds 2
	str 	w3, [x29, cuboid_s + cuboid_base + width_s]		// storing w3 into the stack

	mov 	w4, 2											// register w4 --> holds 2
	str 	w4, [x29, cuboid_s + cuboid_base + length_s]		// storing w4 into the stack

	mov 	w5, 3											// register w5 --> holds 3
	str 	w5, [x29, cuboid_s + cuboid_height]				// storing w5 into the stack

	mul 	w6, w3, w4										// 
	mul 	w6, w5, w6										// 
	str 	w6, [x29, cuboid_s + cuboid_volume]				// 

	ldr 	w9, [x29, cuboid_s + cuboid_origin + x_s]	// 
	str 	w9, [x8, cuboid_origin + x_s]				// 

	ldr 	w9, [x29, cuboid_s + cuboid_origin + y_s]		// 
	str 	w9, [x8, cuboid_origin + y_s]				// 

	ldr 	w9, [x29, cuboid_s + cuboid_base + width_s]		// 
	str 	w9, [x8, cuboid_base + width_s]						// store w9 as cuboid in dimension w

	ldr 	w9, [x29, cuboid_s + cuboid_base + length_s]					// load cuboid dim l into w9
	str 	w9, [x8, cuboid_base + length_s]						// store w9 as cuboid in dimension l

	ldr 	w9, [x29, cuboid_s + cuboid_height]				// load cuboid height into w9
	str 	w9, [x8, cuboid_height]					// store w9 as cuboid in height

	ldr 	w9, [x29, cuboid_s + cuboid_volume]						// load cuboid volume into w9
	str 	w9, [x8, cuboid_volume]							// store w9 as cuboid into cuboid a

	ldp 	x29, x30, [sp], dealloc							// De-allocate the subroutine memory
	ret										// Return to caller


move:
	stp 	x29, x30, [sp, -16]!							// Allocate 16 bytes of memory from the newcuboid frame record
	mov 	x29, sp									// Set x29 to the value of sp

	ldr 	w9, [x0, cuboid_origin + x_s]						// load current cuboid X value
	add 	w9, w9, w1									// add w9 and w1 and store in w9
	str 	w9, [x0, cuboid_origin + x_s]						// store new cuboid X value

	ldr 	w10, [x0, cuboid_origin + y_s]						// load current cuboid Y value
	add 	w10, w10, w2								// add w10 and w2 and store into w10
	str 	w10, [x0, cuboid_origin + y_s]						// store new cuboid Y value

	ldp 	x29, x30, [sp], 16								// De-allocate the subroutine memory
	ret										// Return to caller

scale:
	stp 	x29, x30, [sp, -16]!							// Allocate 16 bytes of memory from the newcuboid frame record
	mov 	x29, sp									// setting x29 to the value of sp

	ldr 	w9, [x0, cuboid_base + width_s]						// load current dim W value
	mul 	w9, w9, w1									// w9 = w9 * w1
	str 	w9, [x0, cuboid_base + width_s]						// store new dim W value

	ldr 	w10, [x0, cuboid_base + length_s]						// load current dim L value
	mul 	w10, w10, w1								// w10 = w10 * w1
	str 	w10, [x0, cuboid_base + length_s]						// store new dim L value

	ldr 	w11, [x0, cuboid_height]					// load current height value
	mul 	w11, w11, w1								// w11 = w11 * w1
	str 	w11, [x0, cuboid_height]					// store new height value

	mul 	w4, w9, w10									// w4 = w9 * w10
	mul 	w4, w11, w4									// w4 = w11 * w4 (replace value in w4 with final volume)
	str 	w4, [x0, cuboid_volume]							// store new value of volume in w4

	ldp 	x29, x30, [sp], 16								// reallocating space back in the stack
	ret										

printCuboid:
	stp 	x29, x30, [sp, -32]!							// allocating space in the stack
	mov 	x29, sp									

	str 	x19, [x29, 16]								
	mov 	x19, x0								

	ldr 	x0, =origin_str
	mov 	w1, w1								
	ldr 	w2, [x19, cuboid_origin + x_s]					
	ldr 	w3, [x19, cuboid_origin + y_s]				
	bl 		printf
	
	ldr		x0, =base_str			
	ldr 	w4, [x19, cuboid_base + width_s]					
	ldr 	w5, [x19, cuboid_base + length_s]					
	bl		printf

	ldr		x0, =height_str
	ldr 	w6, [x19, cuboid_height]								
	ldr 	w7, [x19, cuboid_volume]						

	bl 		printf									
	ldp 	x29, x30, [sp], 32								// deallocating stack memeory
	ret										


						

equalSize:
	stp 	x29, x30, [sp, -32]!
	mov 	x29, sp								

	mov 	w24, 0							

	ldr 	w9, [x0, cuboid_base + width_s]					
	ldr 	w10, [x0, cuboid_base + length_s]			
	ldr 	w11, [x0, cuboid_height]			

	ldr 	w12, [x1, cuboid_base + width_s]				
	ldr 	w13, [x1, cuboid_base + length_s]				
	ldr 	w14, [x1, cuboid_height]			

	cmp 	w9, w12					
	b.ne 	next						

	cmp 	w10, w13						
	b.ne 	next							

	cmp 	w11, w14					
	b.ne 	next								

	mov 	w24, 1						
	mov 	w0, w24							
	bl 		end								

next:
	mov 	w0, w24							

end:
	ldp 	x29, x30, [sp], 32					
	ret 										// return to caller

	.global main			        			//

main:
	stp 	x29, x30, [sp, alloc]!					// allocating space in the stack
	mov 	x29, sp									// setting the value of sp to x29

	add 	x8, x29, first_s						// add x29 and first_s and store in x8
	bl 		newCuboid									// create a new cuboid by branching to newCuboid

	add 	x8, x29, second_s							// add x29 and second_s and store in x8
	bl 		newCuboid									// create a new cuboid by branching to newCuboid

	ldr 	x0, =initial_str								// initialize print function
	bl 		printf									// call print function

	add 	x0, x29, first_s								// add x29 and first_s and store in x0
	ldr 	w1, =first_str									// load =first into w1
	bl 		printCuboid									// print

	add 	x0, x29, second_s								// add x29 and second_s to x0
	ldr 	w1, =second_str									// ldr =second into w1
	bl 		printCuboid									// print

	add 	x0, x29, first_s						// add x29 and first_s and store in x0
	add 	x1, x29, second_s						// add x29 and second_s and store in x1
	bl 		equalSize								// bl equalsize
	cmp 	w0, 1								// compare the output returned from equalSize (w0) and 1
	b.ne 	else									// if w0 != 1 branch to else

	add 	x0, x29, first_s						// add x29 anad first_s and store in x0
	mov 	w1, 3									// set w1 to 3
	mov 	w2, -6									// set w2 to -6
	bl 		move										// bl move

	add 	x0, x29, second_s						// add x29 and second_s and store in x0
	mov 	w1, 4									// set w1 to 4
	bl 		scale									// bl scale

else:											// Print modified values
	ldr 	x0, =changed_str						// initilize the statement
	bl 		printf									// print

	add 	x0, x29, first_s								// add x29 and first_s and store in x0
	ldr 	w1, =first_str								// load =first into w1
	bl 		printCuboid									// bl printCuboid


	add 	x0, x29, second_s							// add x29 and second_s and store in x0
	ldr 	w1, =second_str								// load =second into w1
	bl 		printCuboid									// bl printCuboid

	mov 	w0, 0								//
	ldp 	x29, x30, [sp], dealloc				// deallocate space in stack
	ret										// return control to OS
	
