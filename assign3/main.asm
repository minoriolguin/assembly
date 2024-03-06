// Minori Olguin  UCID: 30035923
// CPSC 355 W24
// Assignment 3
// Description:
//      Generate an unsorted array with random integers, print the unsorted array
//      Then sort the array using an insertion sort and print the sorted array

define(ia_base_r, x19)
define(i_r, w20)
define(j_r, w21)
define(offset_r, w22)
define(temp_r, w23)

        size = 50
        ia_size = size * 4
        alloc = -(16 + ia_size) & -16
        dealloc = -alloc

array_elem_str: .string "V[%d]: %d\n"                   // Declaring string for printing values of the array
unsorted_str:   .string "Unsorted Array\n"
sotrted_str:    .string "Sorted Array\n"

        .balign 4                                       // Ensuring instructions are divisible by 4 bytes
        .global main                                    // Making main visible to linker

main:                                                   // Setting main label to indicate start of main code
        stp     x29, x30, [sp, alloc]!                  // Allocating 16 bytes of memory and store fp and lr on stack
        mov     x29, sp                                 // Updating fp

        mov     offset_r, 16

        mov     ia_base_r, offset_r                     // Updating ia base to be address of start of array

        ldr     w0, =unsorted_str                       // Setting argument 1 for printf: address of the unsorted_string
        bl      printf

        b       test

array_gen_loop:

        bl      rand
        and     temp_r, w0, 0xFF

        str     temp_r, [ia_base_r, i_r, sxtw 2]

        ldr     w0, =array_elem_str
        mov     w1, i_r
        ldr     x2, [ia_base_r, i_r]

        bl      printf

        add     i_r, i_r, 1
test:
        cmp     i_r, size
        b.lt    array_gen_loop

done:
        ldp     x29, x30, [sp], dealloc
        ret