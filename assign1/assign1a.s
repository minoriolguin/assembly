// CPSC 355 W24 Assignment 1
// Minori Olguin UCID: 30035923
// Description: 
//	Program that finds the minimum of y = 3x^3 + 31x^2 - 15x - 127 and prints the x, y and minimum y values
//	Only uses mul, add, and mov instructions to solve the equation, runs a top pre-test loop for all x in range {-10, 4}

str:	.string "\nCurrent x value: %ld\nCurrent y value %ld\nCurrent minimum value %ld\n" 
						// Initializing the String, setting placeholders for integer values

	.balign 4				// Ensure instructions are divisible by 4 bytes
	.global main				// Making main visible to linker


main: 						// Setting main label to indicate start of main code
	stp	x29, x30, [sp, -16]!		// Allocating 16 bytes of memory and store fp and lr on stack
	mov 	x29, sp				// Updating fp

	mov	x28, 5000			// Initializing x28 to 5000 for first compairison test against min value

						// Saving all constant integers from the polynomial to registers
	mov	x19, -10			// Saving -10 immediate to register x19, x19 will be the x value
	mov	x20, 3				// Saving 3 immediate to register x20
	mov	x21, 31				// Saving 31 immediate to register x21
	mov 	x22, -15			// Saving -15 immediate to register x22
	mov 	x23, -127			// Saving -127 immediate to register x23

index_test:					// Setting an index_test label to jump to
	cmp 	x19, 5				// Compairing x19 to 5 for index pre-test
	b.ge	done				// If x19 is greater than or equal to 5, jump to done label

top:						// Beginning the computation y=3x^3+31x^2-15x-127, setting top label
	mov	x24, xzr			// Resets register x24 to 0
	mul 	x24, x19, x19			// Squaring x (x*x) and saving the result to register x24
	mul 	x24, x19, x24			// Multiplying x by x^2 (x cubed) and saving the result to register x24
	mul 	x24, x20, x24			// Multiply x^3 by 3 and saving the results to register x24

	mul	x25, x19, x19			// Squaring x and saving the result to register x25
	mul	x25, x21, x25			// Multiplying x squared by 31 and saving the result to register x25 
	add	x24, x24, x25			// Adding 3x^3 to 31x^2  and saving the result to register x24
	
	mul	x25, x22, x19			// Multiplying x by -15 and saving the result to register x25
	add	x24, x24, x25			// Adding -15x to 3x^3+31x^2 and saving the result to x25
 
	add 	x24, x24, x23			// Adding -127 to 3x^3+31x-15x and saving the result to register x24
	
min_val:					// Setting label for minimum value test
	cmp	x24, x28			// Comparing contents of x24 and x28, y value and current minimum y value
	b.gt	print				// If x24 is greater than x28 jump to print label
	mov	x28, xzr			// Otherwise (if x24 is less than or equal to x28), set x28 to 0
	mov	x28, x24			// Set x28 to x24, set new minimum y value

print:						// Setting print label
	adrp	x0, str				// Setting arguement 1 for print f: address of the string
	add	x0, x0, :lo12:str		// Setting argument 1 for print f: address of the string
	mov 	x1, x19				// Setting first int value
	mov	x2, x24				// Setting second int value
	mov 	x3, x28				// Setting third int value
	bl	printf				// Function call for printf

	add	x19, x19, 1			// Increment x19 by 1, for next index and x value
	b	index_test			// Unconditional branch, jump to index_test label
	
done:						// Setting done loop so the program can exit from index_test
	ldp 	x29, x30, [sp], 16		// Deallocating 16 bytes of memory
	ret					// return control to OS

