.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    # Check if there are 5 command line args
    addi t0, x0, 5
    bne t0, a0, arg_error

    addi a3, a1, 4
    lw a3, 0(a3)
    addi a4, a1, 8
    lw a4, 0(a4)
    addi a5, a1, 12
    lw a5, 0(a5)
    addi a6, a1, 16
    lw a6, 0(a6)

    addi sp, sp, -48
    sw a2, 0(sp)
    sw a3, 4(sp)
    sw a4, 8(sp)
    sw a5, 12(sp)
    sw a6, 16(sp)
    sw ra, 20(sp)

    # Read pretrained m0
    li a0, 4
    jal malloc
    beq a0, x0, malloc_error
    sw a0, 24(sp)

    li a0, 4
    jal malloc
    beq a0, x0, malloc_error
    sw a0, 28(sp)

    lw a0, 4(sp)
    lw a1, 24(sp)
    lw a2, 28(sp)
    jal read_matrix
    sw a0, 4(sp)
    
    # Read pretrained m1
    li a0, 4
    jal malloc
    beq a0, x0, malloc_error
    sw a0, 32(sp)

    li a0, 4
    jal malloc
    beq a0, x0, malloc_error
    sw a0, 36(sp)

    lw a0, 8(sp)
    lw a1, 32(sp)
    lw a2, 36(sp)
    jal read_matrix
    sw a0, 8(sp)

    # Read input matrix
    li a0, 4
    jal malloc
    beq a0, x0, malloc_error
    sw a0, 40(sp)

    li a0, 4
    jal malloc
    beq a0, x0, malloc_error
    sw a0, 44(sp)

    lw a0, 12(sp)
    lw a1, 40(sp)
    lw a2, 44(sp)
    jal read_matrix
    sw a0, 12(sp)

    # Compute h = matmul(m0, input)
    lw t0, 24(sp)
    lw a1, 0(t0)
    lw t0, 44(sp)
    lw a2, 0(t0)
    mul a0, a1, a2
    slli a0, a0, 2
    jal malloc
    beq a0, x0, malloc_error

    mv a6, a0
    lw a0, 4(sp)
    lw t0, 24(sp)
    lw a1, 0(t0)
    lw t0, 28(sp)
    lw a2, 0(t0)
    lw a3, 12(sp)
    lw t0, 40(sp)
    lw a4, 0(t0)
    lw t0, 44(sp)
    lw a5, 0(t0)
    jal matmul
    sw a6, 4(sp)


    # Compute h = relu(h)
    lw a0, 4(sp)
    lw t0, 24(sp)
    lw a1, 0(t0)
    lw t0, 44(sp)
    lw a2, 0(t0)
    mul a1, a1, a2
    jal relu

    # write output matrix h for debugging
    # lw a0, 16(sp)
    # lw a1, 4(sp)
    # lw a2, 24(sp)
    # lw a2, 0(a2)
    # lw a3, 44(sp)
    # lw a3, 0(a3)
    # jal write_matrix
    # j exit



    # Compute o = matmul(m1, h)
    lw t0, 32(sp)
    lw a1, 0(t0)
    lw t0, 44(sp)
    lw a2, 0(t0)
    mul a0, a1, a2
    slli a0, a0, 2
    jal malloc
    beq a0, x0, malloc_error

    mv a6, a0
    lw a0, 8(sp)
    lw t0, 32(sp)
    lw a1, 0(t0)
    lw t0, 36(sp)
    lw a2, 0(t0)
    lw a3, 4(sp)
    lw t0, 24(sp)
    lw a4, 0(t0)
    lw t0, 44(sp)
    lw a5, 0(t0)
    jal matmul
    sw a6, 8(sp)


    # Write output matrix o
    lw a0, 16(sp)
    lw a1, 8(sp)
    lw a2, 32(sp)
    lw a2, 0(a2)
    lw a3, 44(sp)
    lw a3, 0(a3)
    jal write_matrix


    # Compute and return argmax(o)
    lw a0, 8(sp)
    lw a2, 32(sp)
    lw a2, 0(a2)
    lw a3, 44(sp)
    lw a3, 0(a3)
    mul a1, a2, a3
    jal argmax
    sw a0, 12(sp)


    # If enabled, print argmax(o) and newline
    lw t0, 0(sp)
    bne t0, x0, classify_end
    lw a0, 12(sp)
    jal print_int
    li a0, '\n'
    jal print_char

classify_end:
    lw a0, 4(sp)
    jal free
    lw a0, 8(sp)
    jal free
    lw a0, 24(sp)
    jal free
    lw a0, 28(sp)
    jal free
    lw a0, 32(sp)
    jal free
    lw a0, 36(sp)
    jal free
    lw a0, 40(sp)
    jal free
    lw a0, 44(sp)
    jal free

    lw a0, 12(sp)
    lw ra, 20(sp)
    addi sp, sp, 48
    jr ra

malloc_error:
    li a0, 26
    j exit

arg_error:
    li a0, 31
    j exit
