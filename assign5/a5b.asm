// Minori Olguin 
// 30035923
// CPSC 355 Assignment 5b
// Description:
//	Program takes two integers as input, month and day of month, the program returns the month, 
//	day and season that the input day and month correspond to.

define(i_r, w19)						// Defining an index register
define(base_r, x20)						// Defining a base register
define(argc_r, w21)						// Defining an argument count register
define(argv_r, x22)						// Defining an argument array of pointers
define(month_r, w23)						// Defining a register for input month
define(day_r, w24)						// Defining a register for input day
define(suffix_r, w25)						// Defining a register for day suffix
define(season_r, w26)						// Defining a register for season
define(inputc, 3)						// Defining an input count
define(min, 1)							// Defining a minimum value for days and months
define(maxMonth, 13)						// Defining a maximum value for months
define(maxDay, 32)						// Defining a maximum value for day

		.text						// Specifying text type
fmt:		.string "\n%s %d%s is %s\n\n"			// String for printing main message month day, season
err_m:		.string "\nusage: a5b mm dd\n\n"		// Error message

spr_m:		.string "Spring"				// Spring string
sum_m:		.string "Summer"				// Summer string
fal_m:		.string "Fall"					// Fall string
win_m:		.string "Winter"				// Winter string

jan_m:		.string "January"				// January string
feb_m:		.string "February"				// Febrary string
mar_m:		.string "March"					// March string
apr_m:		.string "April"					// April string
may_m:		.string "May"					// May string
jun_m:		.string "June"					// June string
jul_m:		.string "July"					// July string
aug_m:		.string "August"				// August string
sep_m:		.string "September"				// September string
oct_m:		.string "October"				// October string
nov_m:		.string "November"				// November string
dec_m:		.string "December"				// December string

st_sfx:		.string "st"					// st suffix
nd_sfx:		.string "nd"					// nd suffix
rd_sfx:		.string "rd"					// rd suffix
th_sfx:		.string "th"					// th suffix

		.data						// Specifying data type
		.balign 8					// Word alignment for addresses
								// Month array
month_m:	.dword jan_m, feb_m, mar_m, apr_m, may_m, jun_m, jul_m, aug_m, sep_m, oct_m, nov_m, dec_m
season_m:   	.dword spr_m, sum_m, fal_m, win_m 	      	// Season array
suffix_m:	.dword st_sfx, nd_sfx, rd_sfx, th_sfx		// Suffix array 

		.text						// Returning to type text
		.balign 4					// Ensuring that the program is divisible by 4
		.global main					// Linking to main

main:								// main label
		stp 	x29, x30, [sp, -16]!			// Allocating memory for program 
		mov	x29, sp					// Moving stack pointer to frame pointer

		mov	argc_r, w0				// Storing user input count
		mov	argv_r, x1				// Storing user input as an array
		mov	i_r, 1					// Initializing index
err_test:							// Error test label
		cmp	argc_r, inputc				// Comparing argc_r to input_c, number of arguments received to immediate 3
		b.ne	print_err				// If they're not equal, then go to print error label

month:								// Month label
		ldr	x0, [argv_r, i_r, SXTW 3]		// Loading the first element of the user input array 
		bl	atoi					// Branch link to ascii to int
		mov	month_r, w0				// Moving the int result from w0 into month register
		add	i_r, i_r, 1				// Incrementing the index

		ldr	x0, [argv_r, i_r, SXTW 3]		// Loading the second element of the user input array 
 		bl	atoi					// Branch link to ascii to int
 		mov	day_r, w0				// Moving the int result from w0 into the day register
		
		cmp	month_r, min				// Comparing the month int to min (immediate 1) 
		b.lt	print_err				// If the month is less than 1, branching to print error
		cmp	month_r, maxMonth			// Comparing the month int to max month (immediate 13)
		b.ge	print_err				// If the month is greater than or equal to 13, brannching to print error
		
		cmp	day_r, min				// Comparing the day int to min (immediate 1)
		b.lt 	print_err				// If the day is less than 1, branching to print error
		cmp 	day_r, maxDay				// Comparing the day int to max day (immediate 31)
		b.ge	print_err				// If the month is greater than or equal to 31, branching to print error
		
		cmp	day_r, 1				// Comparing the day int to 1
		b.eq	first_suffix				// If equal, branching to first suffix 
		cmp	day_r, 21				// Comparing the day int to 21
		b.eq	first_suffix				// If equal, branching to first suffix
		cmp	day_r, 31				// Comparing the day int to 31
		b.eq	first_suffix				// If equal, branching to first suffix
		cmp	day_r, 2				// Comparing the day int to 2
		b.eq	second_suffix				// If equal, branching to second suffix
		cmp	day_r, 22				// Comparing the day int to 22
		b.eq	second_suffix				// If equal, branching to second suffix
		cmp	day_r, 3				// Comparing the day int to 3
		b.eq	third_suffix				// If equal, branching to third suffix
		cmp	day_r, 23				// Comparing the day int to 23
		b.eq	third_suffix				// If equal, branching to third suffix
		
		mov     suffix_r, 3				// Moving 3 to the suffix register to use as an index later
		b	season					// Unconditional branch to season 

first_suffix:							// First suffix label
		mov	suffix_r, 0				// Moving 0 to the suffix register to use as an index later
		b	season					// Unconditional branch to season
second_suffix:							// Second suffix label
		mov	suffix_r, 1				// Moving 0 to the suffix register to use as an index later
		b	season					// Unconditional branch to season
third_suffix:							// Third suffix label
		mov	suffix_r, 2				// Moving 0 to the suffix register to use as an index later
		b	season					// Unconditional branch to season

season:								// Season label
		cmp	month_r, 3				// Comparing month int to 3, as months 1 and 2 are winter months
		b.lt	winter					// If month is less than 3, branch to winter
		cmp	month_r, 3				// Comparing moth int to 3, as month 3 is winter until the 21st
		b.eq	winter_test				// Branching to winter test if month is month 3
		
		cmp	month_r, 6				// Comparing month int to 6, as months 4 and 5 are spring months
		b.lt	spring					// If month is less than 6, branch to spring
		cmp	month_r, 6				// Comparing month int to 6, as month 6 is spring until the 21st
		b.eq	spring_test				// Branching to spring test if month is month 6

		cmp	month_r, 9				// Comparing month int to 9, as months 7 and 8 are summer months
		b.lt	summer					// If month is less than 9, branch to summer
		cmp	month_r, 9				// Comparing month int to 9, as month 9 is summer until the 21st
		b.eq	summer_test				// Branching to summer test if month is month 9

		cmp	month_r, 12				// Comparing month int to 12, as months 10 and 11 are fall months
		b.lt	fall					// If month is less than 12, branch to fall 
		cmp	month_r, 12				// Comparing month int to 12, as month 12 is fall until the 21st
		b.eq	fall_test				// Branching to fall test if month is month 12

winter_test:							// Winter test label
		cmp	day_r, 20				// Comparing day to 20
		b.le	winter					// If day is less than or equal to 20, branch to winter
		b	spring					// Else branch to spring
winter:								// Winter label
		mov	i_r, 3					// Moving immediate 3 into index register
		b	print					// Unconditional branch to print
spring_test:							// Spring test label
		cmp	day_r, 20				// Comparing day to 20
		b.le	spring					// If day is less than or equal to 20, branch to spring
		b	summer					// Unconditional branch to summer
spring:								// Spring
		mov	i_r, 0					// Moving immediate 0 into index register
		b	print                                   // Unconditional branch to print
summer_test:							// Summer test label
		cmp	day_r, 20				// Comparing day to 20
		b.le	summer					// If day is less than or equal to 20, branch to summer
		b	fall					// Unconditional branch to fall
summer:								// Summer label
		mov	i_r, 1					// Moving immediate 1 into index register
		b	print                                   // Unconditional branch to print
fall_test:							// Fall test label
		cmp	day_r, 20				// Comparing day to 20
		b.le	fall					// If day is less than or equal to 20, branch to fall
		b	winter					// Unconditional branch to winter
fall:								// Fall label
		mov	i_r, 2					// Moving immediate 2 into index register
		b	print                                   // Unconditional branch to print 
print_err:							// Print error label
		ldr     x0, =err_m				// Loading print error string into x0
		bl      printf					// Calling printf 
		b       done					// Unconditional branch to done

print:								// Print label
		sub	month_r, month_r, 1			// Subtracting 1 from the month value to account for index of array starting at 0 not 1

		ldr	x0, =fmt				// Loading fmt string into x0
		adrp	base_r, month_m				// Step 1: loading the address of month array to base register
		add	base_r, base_r, :lo12:month_m		// Step 2: loading the address of month array to base register
		ldr	x1, [base_r, month_r, SXTW 3]		// Loading the month string from month array to x1 for print statement
		mov	w2, day_r				// Moving the day int to w2 for pring statement
		adrp	base_r, suffix_m			// Step 1: loading the address of suffix array to base register
		add	base_r, base_r, :lo12:suffix_m		// Step 2: loading the address of month array to base register
		ldr	x3, [base_r, suffix_r, SXTW 3]		// Loading the suffix string from suffix array to x3 for print statement
        	adrp    base_r, season_m			// Step 1: loading the address of season array to base register
        	add     base_r, base_r, :lo12:season_m		// Step 2: loading the address of month array to base register
        	ldr     x4, [base_r, i_r, SXTW 3]		// Loading the season string from season array to x4 for print statement
		
		bl	printf					// Calling printf
done:								// Done label
		ldp	x29, x30, [sp], 16			// Deallocating space from memory
		ret						// Returning control to OS

