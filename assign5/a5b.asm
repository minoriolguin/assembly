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
define(min, 1)							
define(maxMonth, 13)
define(maxDay, 32)

		.text						// Specifying text type
fmt:		.string "%s %d%s is %s\n"			// String for printing main message month day, season
err_m:		.string "usage: a5b mm dd\n"			// Error message

spr_m:		.string "Spring"				// Spring string
sum_m:		.string "Summer"				// Summer string
fal_m:		.string "Fall"					// Fall string
win_m:		.string "Winter"				// Winter string

jan_m:		.string "January"				// January string
feb_m:          .string "February"				// Febrary string
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
th_sfx:		.string "th"					// th suffix"

		.data						// Specifying data type
		.balign 8					// Word alignment for addresses
								// Month array

month_m:	.dword jan_m, feb_m, mar_m, apr_m, may_m, jun_m, jul_m, aug_m, sep_m, oct_m, nov_m, dec_m

season_m:       .dword spr_m, sum_m, fal_m, win_m 	      	// Season array
suffix_m:	.dword st_sfx, nd_sfx, rd_sfx, th_sfx		// Suffix array 

		.text						// Returning to type text
		.balign 4					// Ensuring that the program is divisible by 4
		.global main					// Linking to main

main:								// main label
		stp 	x29, x30, [sp, -16]!			// Allocating memory for program 
		mov	x29, sp

		mov	argc_r, w0				// Storing user input count
		mov	argv_r, x1				// Storing user input as an array
		mov	i_r, 1					// Initializing index
err_test:							// Error test label
		cmp	argc_r, inputc				// Comparing argc_r to input_c, number of arguments received to immediate 2
		b.ne	print_err				// If they're not equal, then go to print error label

month:								// Month label
		ldr	x0, [argv_r, i_r, SXTW 3]
		bl	atoi
		mov	month_r, w0
		add	i_r, i_r, 1

		ldr	x0, [argv_r, i_r, SXTW 3]
 		bl	atoi
 		mov	day_r, w0
		
		cmp	month_r, min
		b.lt	print_err
		cmp	month_r, maxMonth
		b.ge	print_err
		
		cmp	day_r, min
		b.lt 	print_err
		cmp 	day_r, maxDay
		b.ge	print_err
		
		cmp	day_r, 1
		b.eq	first_suffix
		cmp	day_r, 21
		b.eq	first_suffix
		cmp	day_r, 31
		b.eq	first_suffix
		cmp	day_r, 2
		b.eq	second_suffix
		cmp	day_r, 22
		b.eq	second_suffix

		cmp	day_r, 3
		b.eq	third_suffix
		cmp	day_r, 23
		b.eq	third_suffix
		
		mov     suffix_r, 3
		b	season

first_suffix:			
		mov	suffix_r, 0				
		b	season
second_suffix:	
		mov	suffix_r, 1
		b	season
third_suffix:	
		mov	suffix_r, 2
		b	season

season:
		cmp	month_r, 3
		b.lt	winter
		cmp	month_r, 3
		b.eq	winter_test
		
		cmp	month_r, 6
		b.lt	spring
		cmp	month_r, 6
		b.eq	spring_test		

		cmp	month_r, 9
		b.lt	summer
		cmp	month_r, 9
		b.eq	summer_test

		cmp	month_r, 12
		b.lt	fall
		cmp	month_r, 12
		b.eq	fall_test

winter_test:
		cmp	day_r, 20
		b.le	winter
		b	spring
winter:
		mov	i_r, 3
		b	print_fmt
spring_test:		
		cmp	day_r, 20
		b.le	spring
		b	summer
spring:
		mov	i_r, 0
		b	print_fmt
summer_test:	
		cmp	day_r, 20
		b.le	summer
		b	fall

summer:
		mov	i_r, 1
		b	print_fmt
fall_test:
		cmp	day_r, 20
		b.le	fall
		b	winter
fall:
		mov	i_r, 2
		b	print_fmt
print_err:
		ldr     x0, =err_m
		bl      printf
		b       done

print_fmt:	
		sub	month_r, month_r, 1		

		ldr	x0, =fmt
		adrp	base_r, month_m
		add	base_r, base_r, :lo12:month_m
		ldr	x1, [base_r, month_r, SXTW 3]
		mov	w2, day_r
		adrp	base_r, suffix_m
		add	base_r, base_r, :lo12:suffix_m
		ldr	x3, [base_r, suffix_r, SXTW 3]
                adrp    base_r, season_m
                add     base_r, base_r, :lo12:season_m
                ldr     x4, [base_r, i_r, SXTW 3]
		
		bl	printf

done:
		ldp	x29, x30, [sp], 16
		ret
