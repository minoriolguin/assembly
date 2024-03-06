// Minori Olguin  UCID: 30035923
// CPSC 355 W24 
// Assignment 2a
// Description: 
//	Integer multiplication program that uses long integers and integers to multiply two number together using ASR and add 

define(multc, w19)					// Defining multc for the multiplicand value
define(multp, w20)					// Defining multp for the multiplier value
define(prod, w21)					// Defining prod for the product value
define(neg, w22)					// Defining neg for the negative value 
define(i_r, w28)					// Defining i_r for the index register
define(res_r, x19) 					// Defining res_r for the results register
define(temp1, x23)					// Defining temp1 to store the first temporary value
define(temp2, x24)					// Defining temp2 to store the second temporary value

initial_str:	.string "multiplier = 0x%08x (%d) multiplicand = 0x%08x (%d)\n\n"	// Setting initial string and placeholders for integer values
result_str: 	.string "product = 0x%08x  multiplier = 0x%08x\n"			// Setting result string and placeholders for hex values 
long_str:	.string "64-bit result = 0x%016lx (%ld)\n"				// Setting 64-bit string and placeholders for hex & long integer values

	.balign 4					// Ensuring instructions are divisible by 4 bytes
	.global main					// Making main visible to linker 
	
main:							// Setting main label to indicate start of main code
	stp	x29, x30, [sp, -16]!			// Allocating 16 bytes of memory and store fp and lr on stack
	mov	x29, sp					// Updating fp
	
	mov	w19, -16843010				// Setting value of multicand to -16843010
	mov	w20, 70					// Setting value of multiplier to 70
	mov	w21, 0					// Setting value of product to 0
	mov 	w22, 0					// Setting value of negative flag to 0

	ldr	w0, =initial_str			// Setting arguement 1 for print f: address of the initial string
	mov	w1, multp				// Setting hex value for the initial string
	mov	w2, multp				// Setting integer value for the initial string
	mov	w3, multc				// Setting hex value for the initial string
	mov 	w4, multc				// Setting integer value for the initial string 

	bl	printf					// Function call for printf

	cmp	multp, wzr				// Comparing value of multiplier to zero
	b.ge	loop					// Conditional branch to loop
	
	mov 	neg, 1 					// Else set negative flag to 1 (True) 

loop:							// Label for start of for loop  
	tst 	multp, 0x1				// Testing if the multiplicand's LSB has the value of 1 or 0
	b.eq	multc_bit_clear				// Conditional branch: If the bit is clear (0) then branch to multc_bit_clear

multc_bit_set:						// Multiplicand LSB set (bit set to 1) label 
	add	prod, prod, multc			// Else: Adding the product with the multiplicand and storing the value to the product register

multc_bit_clear:					// Multiplicand LSB clear (bit set to 0) label
	asr	multp, multp, 1				// Using arithmetic shift right on the multiplier value, shift by one

	tst	prod, 0x1				// Testing if the multiplier's LSB has the value of 1 or 0
	b.eq	prod_bit_clear				// Conditional branch: If the bit is clear (0) hten branch to prod_bit_clear

prod_bit_set:						// Product LSB set (bit set to 1) label
	orr	multp, multp, 0x80000000		// Logical OR operator on multiplier value and hex value 0x80000000
	b	next					// Unconditional branch: bypass the else statement

prod_bit_clear:						// Product LSB clear (bit set to 0) label
	and 	multp, multp, 0x7FFFFFFF		// Logical AND operator on multiplier and hex value 0x7FFFFFFF

next:							// Label for next section, label used to skip prod_bit_clear else statement
	asr	prod, prod, 1				// Using arithmetic shift right on the product value, shfit by one 

	add	i_r, i_r,  1				// Increment index register by 1

	cmp	i_r, 32					// Comparing value of index register to 32
	b.lt	loop					// Conditional branch: If index is within range (less than 32) then loop
	
set_negative:						// Label for setting negative value 
	cmp	neg, wzr				// Comparing negative flag to 0 (False)
	b.eq	print					// Conditional branch: If negative flag is false then branch to print

	sub	prod, prod, multc			// Else: subtract multicand from the product and store the result to product register

print:							// Label for printing results
	ldr	w0, =result_str				// Setting argument 1 for printf: address of the results string
	mov	w1, prod				// Setting first hex value for the results string 
	mov	w2, multp				// Setting second hex value for the results string g 
	
	bl 	printf					// Function call for printf

long_result:						// Label for generating long results (64-bit)
	sxtw	temp1, prod				// Using signed extend word to extend bit 31 of product to bits 32-63
	and 	temp1, temp1, 0xFFFFFFFF		// Using logical AND on temp1 (extended value of product)
	
	lsl	temp1, temp1, 32			// Using logical shift left on temp1 (extended value of product) to move 
							// product values into the leftmost bits 
	sxtw	temp2, multp				// Using signed extend word to extend bit 31 of multiplier to bits 32-63				
	and 	temp2, temp2, 0xFFFFFFFF		// Using logical AND on temp2 to clear leftmost values not essental to multiplier

	add	res_r, temp1, temp2			// Add temp1 and temp2 together and store the results in results register
	
	ldr	x0, =long_str				// Setting argument 1 for printf: address of the long results string
	mov	x1, res_r 				// Setting first hex long int value for the long results string 
	mov	x2, res_r				// Setting second long int value for the long results string
	
	bl	printf					// Function call for printf

done:							// Label for end of program
	ldp	x29, x30, [sp], 16			// Deallocating 16 bytes of memory
	ret						// Returning control to OS
