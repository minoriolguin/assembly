// Minori Olguin  UCID: 30035923
// CPSC 355 W24
// Assignment 3
// Description:
//      Generate an unsorted array with random integers, print the unsorted array
//      Then sort the array using an insertion sort and print the sorted array

                                  // Defining a macro for x19 array base register
                                        // Defining a macro for w20 index register
                                        // Defining a macro for w21 second index register
                                     // Defining a macro for offset_r register that holds the offset
                                    // Defining a macro for w22 temporary register for temp values
                                    // Defining a macro for w23 second temp register for temp values

        size = 50                                       // Using assembler equate to assign size 50
        ia_size = size * 4                              // Using assembler equate to assign integer array size 200
        ia_offset = 16                                  // Setting offset to 16 for the integer array
        alloc = -(16 + ia_size) & -16                   // Usinng assembler equate to sum memory to be allocated
        dealloc = -alloc                                // Using assembler equate to create a deallocate variable

array_elem_str: .string "V[%d]: %d\n"                   // Declaring string for printing values of the array
unsorted_str:   .string "\nUnsorted Array\n"            // Declaring string for unsorted array label
sorted_str:     .string "\nSorted Array\n"              // Declaring string for sorted array label

        .balign 4                                       // Ensuring instructions are divisible by 4 bytes
        .global main                                    // Making main visible to linker

main:                                                   // Setting main label to indicate start of main code
        stp     x29, x30, [sp, alloc]!                  // Allocating 16 bytes of memory and store fp and lr on stack
        mov     x29, sp                                 // Updating fp

        mov     w21, wzr
        add     x19, x29, ia_offset               // Updating ia base to be address of start of array
        mov     w20, wzr                                // Clearing the index register to 0

        ldr     w0, =unsorted_str                       // Setting argument 1 for printf: address of the unsorted_string
        bl      printf                                  // Calling printf function

        b       array_gen_test                          // Unconditional branch to array generator test

array_gen_loop:                                         // Setting label for array generator loop

        bl      rand                                    // Calling random function to produce random integer
        mov     w22, w0                              // Retreiving the random integer from register w0
        and     w22, w22, 0xFF                    // Using logical and to clear extra bytes for rand value

        str     w22, [x19, w20, sxtw 2]        // Storing the random integer to stack

        ldr     w0, =array_elem_str                     // Loading the array element string
        mov     w1, w20                                 // Saving w20 to register w1 for the print string
        ldr     w2, [x19, w20, sxtw 2]            // Loading the array at index w20 to w2 from stack

        bl      printf                                  // Calling print function

        add     w20, w20, 1                             // Incrementing index register by 1

array_gen_test:                                         // Setting label for array generator test

        cmp     w20, size                               // Comparing the index register to array size
        b.lt    array_gen_loop                          // Conditional branch if index is less than array size, branch to array_gen_loop

        mov     w20, 0                                  // Else set the value of index for the next for loop
        b       sort_array_test                         // Unconditional branch to sort_array_test

sort_array_loop:                                        // Setting label for sort array loop

        ldr     w22, [x19, w20, sxtw 2]        // Loading value of temp register from address for v[i]

        mov     w21, w20                                // Moving the value of index register to j index register
        b       j_index_test                            // Unconditional branch to j index test

sort_values:                                            // Setting label for sort values

        str     w23, [x19, w24, sxtw 2]   // Storing temp2 register to stack at v[w24]

j_index_test:                                           // Setting label for j index test

        cmp     w21, wzr                                // Comparing the values of j index to 0
        b.gt    value_test                              // Conditional branch for if j index is greater than 0 jump to value test

        mov     w24, w21                            // Moving the value j index to temp register 3

        //str     w22, [x19, w24, sxtw 2]    // Storing the value of temp register to the stack in a new postition
                                                        // Eqivalent to C code v[j] = v[j-1]
        b       sort_array_test                         // Unconditional branch to sort array test

value_test:                                             // Setting label for value test

        mov     w24, w21                            // Moving the j index value to a temporary register
        sub     w21, w21, 1                             // Decrementing j index register by 1
        ldr     w23, [x19, w21, sxtw 2]       // Loading the value of temporary register 2 to stack at v[j]

        cmp     w22, w23                         // Comparing the values of temporary register wih temp register 2, temp < v[j-1]
        b.lt    sort_values                             // Conditional branch to sort values label if temp register is less than temp2 register

        //str     w22, [x19, w24, sxtw 2]    // Storing the value of temp register to the stack in a new postition
                                                        // Eqivalent to C code v[j] = v[j-1]
sort_array_test:                                        // Setting label for the sort array test

        str     w22, [x19, w24, sxtw 2]    // Storing the value of temp register to the stack in a new postition


        add     w20, w20, 1                             // Incrementing the index register by 1

        cmp     w20, size                               // Compairing the value of index register to array size
        b.lt    sort_array_loop                         // Conditional branch for if the index is less than size
                                                        // then branch to sort array loop else continue below
        mov     w20, wzr                                // Clearing the index register for the next loop

        ldr     w0, =sorted_str                         // Loading the string label for the sorted array for print command
        bl      printf                                  // Print function call

        b       print_loop_test                         // Unconditional branch to  print loop test

print_loop:                                             // Setting label for print loop

        ldr     w0, =array_elem_str                     // Loading the array element string for print command
        mov     w1, w20                                 // Copying the value of w20 to w1 for the print statement
        ldr     w2, [x19, w20, sxtw 2]            // Loading the value of array[i] to w2 for the print statement

        bl      printf                                  // Calling the printf function

        add     w20, w20, 1                             // Incrementing the index register by 1

print_loop_test:                                        // Label for print_loop_test

        cmp     w20, size                               // Comparing the integer values of index to array size
        b.lt    print_loop                              // Conditional branch to the print loop

done:                                                   // Done label for end of program

        ldp     x29, x30, [sp], dealloc                 // Deallocating memory
        ret                                             // Returning control to OS
