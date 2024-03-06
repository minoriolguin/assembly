// CPSC 355 W24 Assignment 1b
// Minori Olguin UCID: 30035923
// Description:
//	Optimized program that finds the minimum of y = 3x^3 + 31x^2 - 15x - 127 and prints out the x, y, and mimimum y values
//	Uses m4 and runs a loop with a bottom pre-test to solve for all x values in the range {-10, 4}
						// Defining coeficients for a cubic polynomial 3x^3 + 31x^2 - 15x - 127
define(coef1, x22)				// Defining coef1 to be reg x22
define(coef2, x23)				// Defining coef2 to be reg x23
define(coef3, x24)				// Defining coef3 to be reg x24

define(x_r, x19)				// Defining x_r to be x19 for x value
define(y_r, x20)				// Defining y_r to be x20 for y value
define(m_r, x28)				// Defining m_r to be x28 for minimum value

str:	.string "\nCurrent x value: %ld\nCurrent y value %ld\nCurrent minimum value %ld\n"
min_str: .string "\nFinal  minimum value %ld\n" // Initializing minimum y value string 
						// Initializing the xy and min Strings, setting placeholders for integer values

	.balign 4				// Ensure instructions are divisible by 4 bytes
	.global main				// Making main visible to linker

main: 						// Setting main label to indicate start of main code
	stp	x29, x30, [sp, -16]!		// Allocating 16 bytes of memory and store fp and lr on stack
	mov 	x29, sp				// Updating fp

	mov	x22, 3				// Initializing coef1 to be 3
	mov 	x23, 31				// Initializing coef2 to be 31
	mov	x24, -15			// Initializing coef3 to be -15
	
	mov	m_r, 5000			// Initializing x28 to 5000 for first compairison test against min value
	mov	x_r, -10			// Initializing x_r to hold the first x value -10

	b index_test				// Unconditional branch to pre-test, jumps to index_test label	

top:						// Beginning the computation y=3x^3+31x^2-15x-127, setting top label
	mul 	y_r, x_r, x_r			// Squaring x (x*x) and saving the result to y_r
	mul 	y_r, x_r, y_r			// Multiplying x by x^2 (x cubed) and saving the result to y_r
	mul	y_r, y_r, coef1			// Multiply x^3 by coef1 (3) and saving the result to y_r

	mul	x21, x_r, x_r			// Squaring x and saving the result to register x25
	madd	y_r, coef2, x21, y_r		// Multiplying x squared by coef2 (31), adding it to y_r, and saving the result to y_r
	
	madd	y_r, coef3, x_r, y_r		// Multiplying x by coef3 (-15), adding the result to y_r, and saving the result to y_r
	add 	y_r, y_r, -127			// Adding -127 to 3x^3+31x-15x and saving the result to y_r
	
min_val:					// Setting label for minimum value test
	cmp	y_r, m_r			// Comparing contents of y_r and m_r, y value and current minimum y value
	b.gt	print_xy			// If y_r is greater than m_r jump to print label
	
	mov	m_r, y_r			// Else, set m_r to y_r, set new minimum y value

print_xy:					// Setting print x and y label
	ldr	x0, =str			// Setting argument 1 for print f: address of the string
	mov 	x1, x_r				// Setting first int value
	mov	x2, y_r				// Setting second int value
	mov	x3, m_r				// Setting third int value
	bl	printf				// Function call for printf

	add	x_r, x_r, 1			// Increment x by 1

index_test:					// Setting label for index test
	cmp	x_r, 4				// Comparing index (x value) to max value of 4, comparing x_r to 4 
	b.le	top				// Conditional branch to top if x_r is less than or equal to 4

done:						// Setting done loop so the program can end
	ldr	x0, =min_str			// Setting argument 1 for print f: address of the string
	mov	x1, m_r				// Setting int value for string
	bl	printf				// Function call for printf

	ldp 	x29, x30, [sp], 16		// Deallocating 16 bytes of memory
	ret					// return control to OS

