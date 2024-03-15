// CPSC 355 W24 Assignment 4
// Minori Olguin UCID: 30035923

define(FALSE, 0)						// Defining a macro for false = 0
define(TRUE, 1)							// Defining a macro for true = 1

cuboid_str:	.string "\nCuboid %s origin = (%d, %d)\n\tBase width = %d Base length = %d\n\tHeight = %d\n\tVolume = %d\n\n"
								// Setting string to print cuboid info
initial_str:	.string "\nInitial cuboid values:\n"		// Setting string to print initialtitle
changed_str:    .string "\nChanged cuboid values:\n"		// Setting string to print changed title
first_str:	.string "first"					// Setting string to print first label
second_str:	.string "second"				// Setting string to print second label

	x_origin_s = 0						// The stack offset for x 
	y_origin_s = 4						// The stack offset for y

	width_base_s = 8					// The stack offset for base width
	length_base_s = 12					// The stack offset for base length
	height_s = 16						// The stack offset for height
	volume_s = 20						// The stack offset for volume

	cuboid_size = 24					// The size of a cuboid

	alloc = -(16 + (cuboid_size * 2)) & -16			// alloc variable to allocate memory
	dealloc = -alloc					// dealloc variable to deallocate memory
	first_s = 16						// Offset of first cuboid
	second_s =  16 + cuboid_size				// Offset of second cuboid

	cuboid_alloc = -(16 + cuboid_size) & -16		// cuboid_alloc variable for allocating memory in the newCuboid function
	cuboid_dealloc = -cuboid_alloc				// cuboid_dealloc variable for deallocating memory in the newCuboid function

	result_s = 16                          	          	// The stack offset for result 
	result_size = 4                                  	// The size of result (int)
	equal_size_alloc = -(16 + result_size) & -16		// Allocating memory for the equalSize function
	equal_size_dealloc = -equal_size_alloc 			// Deallocating memory for the equalSize function

	.balign 4						// Ensuring the alignment is divisible by 4 columns

newCuboid:							// newCuboid function label
	stp 	x29, x30, [sp, cuboid_alloc]!			// Allocate 16 bytes of memory from the newCuboid frame record
	mov 	x29, sp						// Move the stack pointer to the frame pointer.

	add 	x9, x29, cuboid_size              		// Add cuboid_size to fp 
	str 	xzr, [x9, x_origin_s]				// Store 0 in x origin address
	str 	xzr, [x9, y_origin_s]				// Store 0 in y origin address

	mov 	w10, 2						// Setting w10 to immediate value 2
   	str 	w10, [x9, width_base_s]            		// Storing 2 to width base address
   	str 	w10, [x9, length_base_s]			// Storing 2 to length base address
	
	mov 	w11, 3						// Setting w11 to immediate value 3
	str 	w11, [x9, height_s]	          		// Storing 3 to height address
    
	ldr 	w10, [x9, width_base_s]				// Loading width base value to w10
	ldr 	w11, [x9, length_base_s]			// Loading length base value to w11
	ldr	w12, [x9, height_s]				// Loading height value to w12
					
	mul	w13, w10, w11					// Multiplying w10 * w11 (width * length)
	mul	w13, w13, w12					// Multiplying w13 * w12 (width * length * height)

	str 	w13, [x9, volume_s]				// Storing the multiplication result to volume address

	ldr 	w10, [x9, x_origin_s]               		// Loading x origin value to w10
  	str 	w10, [x8, x_origin_s]             		// Storing x origin value to x8 to be accessible by main
    	ldr 	w10, [x9, y_origin_s]          			// Loading y origin value to w10
   	str 	w10, [x8, y_origin_s]              		// Storing y origin value to x8 to be accessible by main
    	ldr 	w10, [x9, width_base_s]             		// Loading width value to w10
    	str 	w10, [x8, width_base_s]            		// Storing width value to x8 to be accessible by main
    	ldr 	w10, [x9, length_base_s]         		// Loading length value to w10
    	str 	w10, [x8, length_base_s]          		// Storing length value to x8 to be accessible by main
	ldr	w10, [x9, height_s]				// Loading height value to w10
	str	w10, [x8, height_s]				// Storing height value to x8 to be accessible by main
   	ldr 	w10, [x9, volume_s]                		// Loading volume value to w10
   	str 	w10, [x8, volume_s]  				// Storing volume value to x8 to be accessible by main

	ldp 	x29, x30, [sp], cuboid_dealloc			// Deallocating the subroutine memory
	ret							// Return to caller

move:								
	stp 	x29, x30, [sp, -16]!				// Allocate 16 bytes of memory
	mov 	x29, sp						// Updating fp to sp 

	ldr 	w9, [x0, x_origin_s]				// Loading x origin value to w9
	add 	w9, w9, w1					// Add w9 + w1 and store in w9
	str 	w9, [x0, x_origin_s]				// Storing updated y origin value

	ldr 	w9, [x0, y_origin_s]				// Loading y origin value to w9
	add 	w9, w9, w2					// Add w9 + w2 and store in w9
	str 	w9, [x0, y_origin_s]				// Storing updated y origin value

	ldp 	x29, x30, [sp], 16				// Deallocating the subroutine memory
	ret							// Return to caller

scale:
	stp 	x29, x30, [sp, -16]!				// Allocate 16 bytes of memory
	mov 	x29, sp						// Updating fp to sp

	ldr 	w9, [x0, width_base_s]				// Loading base width to w9
	mul 	w9, w9, w1					// w9 = w9 * w1
	str 	w9, [x0, width_base_s]				// Storing updated base width value

	ldr 	w9, [x0, length_base_s]				// Loading base length to w9
	mul 	w9, w9, w1					// w9 = w9 * w1
	str 	w9, [x0, length_base_s]				// Storing updated base length value

	ldr 	w9, [x0, height_s]				// Load height to w9
	mul 	w9, w9, w1					// w9 = w9 * w1
	str 	w9, [x0, height_s]				// Storing updated height value

	ldr     w9, [x0, width_base_s]				// Loading width to w9
	ldr     w10, [x0, length_base_s]			// Loading length to w10
	ldr     w11, [x0, height_s]				// Loading height to w11

	mul 	w9, w9, w10					// w9 = w9 * w10 (new width * new length)
	mul 	w9, w9, w11					// w9 = w9 * w11 (new width * new length* new height)
	str 	w9, [x0, volume_s]				// Storing new volume value to volume address

	ldp 	x29, x30, [sp], 16				// Deallocating space in the stack 
	ret							// Returning to caller

printCuboid:							// Print cuboid function label
	stp 	x29, x30, [sp, -16]!				// Allocating space in the stack
	mov 	x29, sp						// Moving sp to fp	

    	ldr 	x2, [x1, x_origin_s]				// Set x2 to the value of x origin
    	ldr 	x3, [x1, y_origin_s]				// Set x3 to the value of y origin
	ldr	x4, [x1, width_base_s]				// Set x4 to the value of the width of the base
	ldr	x5, [x1, length_base_s]				// Set x5 to the value of the length of the base
	ldr	x6, [x1, height_s]				// Set x6 to the value of the height
	ldr	x7, [x1, volume_s]				// Set x7 to the value of the volume

    	mov 	x1, x0						// Move the string parameter (already set up in main) to the second parameter
    	ldr 	x0, =cuboid_str					// Load cuboid string to x0

	bl 	printf						// Calling print function

	ldp 	x29, x30, [sp], 16				// Deallocating memory space
	ret							// Returning to caller

equalSize:							// Equal size function label 
	stp 	x29, x30, [sp, equal_size_alloc]!		// Allocating memory for equal size function
	mov 	x29, sp						// Moving sp to fp

	mov 	w9, FALSE					// Moving false (0) to result register
	str	w9, [x29, result_s]				// Storing the result to result address

	ldr 	w10, [x0, width_base_s]				// Loading base width of first cuboid to w9
	ldr 	w11, [x1, width_base_s]				// Loading base width of second cuboid to w10
	cmp	w10, w11					// Comparing width of cuboid 1 to cuboid 2
	b.ne	equal_size_exit					// If not equal, then branch to exit 

	ldr 	w10, [x0, length_base_s]			// Loading base length of first cuboid to w9
	ldr 	w11, [x1, length_base_s]			// Loading base length of second cuboid to w10
	cmp	w10, w11					// Comparing length of cuboid 1 to cuboid 2
	b.ne	equal_size_exit					// If not equal, then branch to exit

	ldr 	w10, [x0, height_s]				// Loading height of cuboid 1 to w9
	ldr 	w11, [x1, height_s]				// Loading height of cuboid 2 to w10
	cmp	w10, w11					// Comparing height of cuboid 1 to cuboid 2
	b.ne	equal_size_exit					// If not equal, then branch to exit
											
	mov 	w9, TRUE					// Move true to result register
	str 	w9, [x29, result_s]				// Save result to result address
    	ldr 	w0, [x29, result_s]				// Loading resutls to w0 to make it accessible to main				

equal_size_exit:						// Equal size exit label	
	ldp 	x29, x30, [sp], equal_size_dealloc		// Deallocating mememory
	ret 							// Return to caller 


	.global main			        		// Linking to main

main:								// Main label 
	stp 	x29, x30, [sp, alloc]!				// Allocating space in the stack
	mov 	x29, sp						// Setting fp to sp 

	add 	x8, x29, first_s				// Adding x29 and first address to x8
	bl 	newCuboid					// Create a new cuboid by branch link to newCuboid

	add 	x8, x29, second_s				// Adding x29 and second address to x8
	bl 	newCuboid					// Create a new cuboid by branch link to newCuboid

	ldr 	x0, =initial_str				// Loading initial string to x0
	bl 	printf						// Calling print function

	ldr 	x0, =first_str					// Loading first string to x0
	add	x1, x29, first_s				// Adding x29 and first 
	bl 	printCuboid					// Calling print function

	ldr 	x0, =second_str					// Loading first string to x0
	add	x1, x29, second_s
	bl 	printCuboid					// Calling print function

	add 	x0, x29, first_s				// Adding fp and first address
	add 	x1, x29, second_s				// Adding  fp and second address
	bl 	equalSize					// Branch link to equal size function 
if:								// If label
	cmp 	w0, TRUE					// Checking if w0 holds true value
	b.ne 	else						// Conditional branch to else 

	add 	x0, x29, first_s				// Adding fp and first address
	mov 	w1, 3						// Moving immediate 3 into w1
	mov 	w2, -6						// Moving immediate -6 into w2
	bl 	move						// Branch link to move function

	add 	x0, x29, second_s				// Adding fp and second address
	mov 	w1, 4						// Moving immediate 4 into w1 
	bl 	scale						// Branch link to scale funciton 

else:								// Else label		
	ldr 	x0, =changed_str				// Loading changed string to x0
	bl 	printf						// Calling print function

	ldr 	x0, =first_str					// Adding x29 and first address to x0
	add 	x1, x29, first_s				// Loading first string to x1
	bl 	printCuboid					// Branch link to printCuboid function

	ldr	x0, =second_str					// Adding fp to second address
	add 	x1, x29, second_s				// Loading second string to w1
	bl 	printCuboid					// Branch link to printCuboid function

	ldp 	x29, x30, [sp], dealloc				// Deallocate space in stack
	ret							// Return control to OS	
