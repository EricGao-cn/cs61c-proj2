.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue


    # step1 and step2
    addi sp, sp, -12
    sw ra, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    
    addi a1, x0, 0
    jal fopen
    addi a1, x0, -1
    beq a0, a1, fopen_error

    addi sp, sp, -4
    sw a0, 0(sp)

    lw ra, 4(sp)
    lw a1, 8(sp)
    addi a2, x0, 4
    jal fread
    addi a2, x0, 4
    bne a0, a2, fread_error

    lw a0, 0(sp)
    lw ra, 4(sp)
    lw a1, 12(sp)
    addi a2, x0, 4
    jal fread
    addi a2, x0, 4
    bne a0, a2, fread_error

    lw a0, 0(sp)
    addi sp, sp, 4
    lw ra, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp, sp, 12

    # step3 malloc
    lw t0, 0(a1)   # row
    lw t1, 0(a2)   # column
    mul t0, t0, t1 # row * column
    slli t1, t0, 2 # row * column * 4

    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)

    mv a0, t1
    jal malloc
    beq a0, x0, malloc_error
    mv t1, a0

    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16

    # step4 read matrix start
    # a0: descriptor
    # t1: pointer to the new matrix
    # t0: numbers to read

    addi t2, x0, 0  # t2 is the index of read number
    addi t3, t1, 0  # t3 is the position to write

read_loop:
    addi sp, sp, -24
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw t0, 8(sp)
    sw t1, 12(sp)
    sw t2, 16(sp)
    sw t3, 20(sp)

    mv a1, t3
    addi a2, x0, 4
    jal fread
    addi a2, x0, 4
    bne a0, a2, fread_error

    lw ra, 0(sp)
    lw a0, 4(sp)
    lw t0, 8(sp)
    lw t1, 12(sp)
    lw t2, 16(sp)
    lw t3, 20(sp)
    addi sp, sp, 24

read_loop_end:
    addi t2, t2, 1
    addi t3, t3, 4
    blt t2, t0, read_loop

    # step4 read matrix end

    # step5 fclose
    addi sp, sp, -8
    sw ra, 0(sp)
    sw t1, 4(sp)

    jal fclose
    bne a0, x0, fclose_error

    lw ra, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 8

    # Epilogue
    mv a0, t1
    jr ra


malloc_error:
    li a0, 26
    j exit

fopen_error:
    li a0, 27
    j exit

fclose_error:
    li a0, 28
    j exit

fread_error:
    li a0, 29
    j exit
