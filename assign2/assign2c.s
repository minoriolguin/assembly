// Minori Olguin  UCID: 30035923
// CPSC 355 W24 
// Assignment 2c
// Description: 
//	Integer multiplication program that uses long integers and integers to multiply two number together using ASR and add 

					// Defining w19 for the multiplicand value
					// Defining w20 for the multiplier value
					// Defining w21 for the product value
					// Defining w22 for the negative value 
					// Defining w28 for the index register
 					// Defining x19 for the results register
					// Defining x23 to store the first temporary value
					// Defining x24 to store the second temporary value

initial_str:	.string "multiplier = 0x%08x (%d) multiplicand = 0x%08x (%d)\n\n"	// Setting initial string and placeholders for integer values
result_str: 	.string "product = 0x%08x (%d) multiplier = 0x%08x (%d)\n"		// Setting result string and placeholders for hex values 
long_str:	.string "64-bit result = 0x%016lx (%ld)\n"				// Setting 64-bit string and placeholders for hex & long integer values

	.balign 4					// Ensuring instructions are divisible by 4 bytes
	.global main					// Making main visible to linker 
	
main:							// Setting main label to indicate start of main code
	stp	x29, x30, [sp, -16]!			// Allocating 16 bytes of memory and store fp and lr on stack
	mov	x29, sp					// Updating fp
	
	mov	w19, -252645136				// Setting value of multicand to -252645136
	mov	w20, -256				// Setting value of multiplier to -256
	mov	w21, 0					// Setting value of product to 0
	mov 	w22, 0					// Setting value of negative flag to 0

	ldr	w0, =initial_str			// Setting arguement 1 for print f: address of the initial string
	mov	w1, w20				// Setting hex value for the initial string
	mov	w2, w20				// Setting integer value for the initial string
	mov	w3, w19				// Setting hex value for the initial string
	mov 	w4, w19				// Setting integer value for the initial string 

	bl	printf					// Function call for printf

	cmp	w20, wzr				// Comparing value of multiplier to zero
	b.ge	loop					// Conditional branch to loop
	
	mov 	w22, 1 					// Else set negative flag to 1 (True) 

loop:							// Label for start of for loop  
	tst 	w20, 0x1				// Testing if the multiplicand's LSB has the value of 1 or 0
	b.eq	multc_bit_clear				// Conditional branch: If the bit is clear (0) then branch to multc_bit_clear

multc_bit_set:						// Multiplicand LSB set (bit set to 1) label 
	add	w21, w21, w19			// Else: Adding the product with the multiplicand and storing the value to the product register

multc_bit_clear:					// Multiplicand LSB clear (bit set to 0) label
	asr	w20, w20, 1				// Using arithmetic shift right on the multiplier value, shift by one

	tst	w21, 0x1				// Testing if the multiplier's LSB has the value of 1 or 0
	b.eq	prod_bit_clear				// Conditional branch: If the bit is clear (0) hten branch to prod_bit_clear

prod_bit_set:						// Product LSB set (bit set to 1) label
	orr	w20, w20, 0x80000000		// Logical OR operator on multiplier value and hex value 0x80000000
	b	next					// Unconditional branch: bypass the else statement

prod_bit_clear:						// Product LSB clear (bit set to 0) label
	and 	w20, w20, 0x7FFFFFFF		// Logical AND operator on multiplier and hex value 0x7FFFFFFF

next:							// Label for next section, label used to skip prod_bit_clear else statement
	asr	w21, w21, 1				// Using arithmetic shift right on the product value, shfit by one 

	add	w28, w28,  1				// Increment index register by 1

	cmp	w28, 32					// Comparing value of index register to 32
	b.lt	loop					// Conditional branch: If index is within range (less than 32) then loop
	
set_negative:						// Label for setting negative value 
	cmp	w22, wzr				// Comparing negative flag to 0 (False)
	b.eq	print					// Conditional branch: If negative flag is false then branch to print

	sub	w21, w21, w19			// Else: subtract multicand from the product and store the result to product register

print:							// Label for printing results
	ldr	w0, =result_str				// Setting argument 1 for printf: address of the results string
	mov	w1, w21				// Setting first int value for the results string
	mov	w2, w21				// Setting second int value for the results string 
	mov	w3, w20				// Setting third int value for the results string 
	mov	w4, w20				// Setting fourth int value for the results string 
	
	bl 	printf					// Function call for printf

long_result:						// Label for generating long results (64-bit)
	sxtw	x23, w21				// Using signed extend word to extend bit 31 of product to bits 32-63
	and 	x23, x23, 0xFFFFFFFF		// Using logical AND on x23 (extended value of product)
	
	lsl	x23, x23, 32			// Using logical shift left on x23 (extended value of product) to move 
							// product values into the leftmost bits 
	sxtw	x24, w20				// Using signed extend word to extend bit 31 of multiplier to bits 32-63				
	and 	x24, x24, 0xFFFFFFFF		// Using logical AND on x24 to clear leftmost values not essental to multiplier

	add	x19, x23, x24			// Add x23 and x24 together and store the results in results register
	
	ldr	x0, =long_str				// Setting argument 1 for printf: address of the long results string
	mov	x1, x19 				// Setting first hex long int value for the long results string 
	mov	x2, x19				// Setting second long int value for the long results string
	
	bl	printf					// Function call for printf

done:							// Label for end of program
	ldp	x29, x30, [sp], 16			// Deallocating 16 bytes of memory
	ret						// Returning control to OS
