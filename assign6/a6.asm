// Minori Olguin
// 30035923
// CPSC 355 Assignment 6
// 	Description: Program reads a floating point number from a file, the float is then used in a subroutine
// 			calculation e^x and e^-x, once the value is less than 1.0e-10, the value is returned to 
//			the main method and printed off, the program then reads the next value from the file. The program 
//			prints the values in three columns.The program implements basic error handling when opening the 
//			file. The program detects the end of the file and terminates once all the values have been read. 

define(base_r, x9)									// Defining a base register 
define(even_r, w10)									// Defining a sign (-/+) register 
define(value_r, d10)									// Defining a value register 
define(add_result_r, d11)								// Defining a added result register 
define(sub_result_r, d12)								// Defining a subtracted result register 
define(input_r, d13)									// Defining a input register 
define(denom_r, d14)									// Defining a denominator register 
define(numerator_r, d15)								// Defining a numerator register 
define(abs_val_r, d16)									// Defining a absolute value register 
define(lim_r, d19)									// Defining a limit register 
define(one_r, d21)									// Defining a register for float 1.0
define(j_r, d22)									// Defining a j index register 
define(fd_r, w19)									// Defining a fd register 
define(i_r, w20)									// Defining a index register
define(bytes_read_r, x21)								// Defining a bytes read register

		.text									// text section 
open_err_fmt:	.string "Can't open  %s for writing.\n"					// open error format string
done_read_fmt: 	.string "\nFinished reading all values from %s\n"			// done reading format string
FILENAME:	.string "input.bin"							// FILENAME constant string
col_head_fmt: 	.string "\ninput x\t\t\toutput e^x\t\toutput e^-x\n\n"			// column header format string
fmt: 		.string "%-20.10f\t%-20.10f\t%-20.10f\n"				// format for printing floats
lim_m:		.double 0r1.0e-10							// constant limit 1.0e-10

		.balign 4								// Ensuring the program is divisible by 4
		.global main								// Making main visible 

buf_size = 8										// buf size of 8 for floats
alloc = -(16 + buf_size) & -16								// allocating memory size
dealloc = -alloc 									// deallocating memory size
buf_s = 16										// location of buf on stack 

main:											// Main label
		stp 	x29, x30, [sp, alloc]!						// Allocating memory
		mov 	x29, sp								// Moving sp to fp 
	
open_file:										// open file label 
		mov 	w0, -100							// 1st arg for open file (use cwd)
		ldr	x1, =FILENAME							// 2nd arg for open file (pathname)
		mov 	w2, 0								// 3rd arg for open file (read only)
		mov 	w3, 0								// 4th arg for open file (not used)

		mov 	x8, 56								// Open I/O request
		svc 	0								// Call system function

		mov 	fd_r, w0							// fd is in w0, move it to fd_r

		cmp 	fd_r, -1							// Check if opening file was successful
		b.gt 	read								// if the file opened then branch to read
	
		ldr	x0, =open_err_fmt						// else load open error format to x0 (1st print arg)
		ldr 	x1, =FILENAME							// load the file name string to x1 (2nd print arg)
		bl 	printf								// call printf

		mov 	w0, -1								// return -1
		b	done								// unconditional branch to done

read:											// Read label
		ldr 	x0, =col_head_fmt						// load col head format to x0 (1st print arg)
		bl 	printf								// call printf
		b 	read_test							// unconditional branch to read test

loop_top:										// loop top label
		fmov 	d0, input_r							// move input into d0 (1st func arg)
		bl 	func								// branch link to func subroutine

		fmov 	add_result_r, d0						// move 1st return value to add result register
		fmov 	sub_result_r, d1						// move 2nd return value to subtract result register

		ldr 	x0, =fmt							// load fmt to x0 (1st print arg)
		fmov 	d0, input_r							// move input_r to d0 (2nd print arg)
		fmov 	d1, add_result_r						// move add result to d1 (3rd print arg)
		fmov 	d2, sub_result_r						// move sub result to d2 (4rd print arg)

		bl 	printf								// call printf

read_test:										// read test label
		mov 	w0, fd_r							// 1st read arg (fd)
		add 	x1, x29, buf_s 							// 2nd read arg (pointer to buf)
		mov 	w2, buf_size							// 3rd read arg (# of bytes to read)
	
		mov 	x8, 63								// read I/O request
		svc 	0								// call sys function 

		mov 	bytes_read_r, x0						// move the number of bytes read to register
		ldr 	input_r, [x29, buf_s]						// load the value read to input register

		cmp 	bytes_read_r, buf_size						// compare bytes read to expected bytes read
		b.ne 	done_read							// if bytes read was not equal to expected
											// conditional branch to done read
		b 	loop_top							// else unconditional branch to loop top

done_read:										// done read label
		ldr 	x0, =done_read_fmt						// load done read format (1st print arg)
		ldr 	x1, =FILENAME							// load file name (2nd print arg)
		bl 	printf								// call printf
		b 	done								// unconditional branch to done

done: 											// done label
		ldp 	x29, x30, [sp], dealloc						// deallocate memory
		ret									// return control to os

// FUNCTION e^x a nd e^-x
func:											// func subroutine
		stp 	x29, x30, [sp, -16]!						// allocating memory (standard setup)
		mov 	x29, sp 							// moving sp to fp

		fmov 	input_r, d0							// saving input value to input register
		fmov 	one_r, 1.0							// setting one register to 1.0
		fmov 	j_r, one_r							// setting j index counter to 1.0
		mov 	i_r, 1								// setting index to 1
		fmov 	add_result_r, one_r						// setting add result to 1
		fmov 	sub_result_r, one_r						// setting sub result to 1
		fmov 	denom_r, one_r							// setting denominator to 1
		fmov 	numerator_r, input_r						// setting numerator to input 
	
func_top:										// function top label
		fdiv 	value_r, numerator_r, denom_r					// dividing numerator by denominator and storing in value
		fadd 	add_result_r, add_result_r, value_r				// adding value to result 

		and 	even_r, i_r, 1							// using 1 bitmask to check if number is even or odd
		cmp 	even_r, wzr							// comparing even register to 0
		b.eq 	func_add_even							// if the index is even, branch to func add even

		fsub 	sub_result_r, sub_result_r, value_r				// else subtract value from result
		b 	func_val_test							// unconditional branch to function value test

func_add_even:										// func add even label
		fadd 	sub_result_r, sub_result_r, value_r				// add value to sub result
		
func_val_test:										// func val test label
		fabs 	abs_val_r, value_r						// change to absolute value of value and store in abs val regisiter

		adrp 	base_r, lim_m							// get the address of lim 
		add 	base_r, base_r, :lo12:lim_m					// finish getting the address of lim
		ldr 	lim_r, [base_r]							// load value of lim from address

		fcmp 	abs_val_r, lim_r						// compare abs value of value to limit
		b.ge 	func_next							// if it's greater than or equal, then continue to loop

		fmov 	d0, add_result_r						// else move add result to return register
		fmov 	d1, sub_result_r						// move sub result to return register 
		b 	func_exit							// unconditional branch to exit

func_next:										// func next label
		fadd 	j_r, j_r, one_r							// increment j index by 1
		add 	i_r, i_r, 1							// increment i index by 1
		fmul 	denom_r, j_r, denom_r 						// multiply denominator by incremented j
		fmul 	numerator_r, numerator_r, input_r				// multiply numerator by original input
		b 	func_top							// unconditional branch to func top

func_exit:										// func exit label
		ldp 	x29, x30, [sp], 16						// deallocating memory
		ret									// return control to calling code 

