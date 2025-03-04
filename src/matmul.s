.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    addi t0, x0, 1
    blt a1, t0, error_exit
    blt a2, t0, error_exit
    blt a4, t0, error_exit
    blt a5, t0, error_exit
    bne a2, a4, error_exit

    # Prologue
    addi t1, x0, 0  # the row index of d
    addi t2, x0, 0  # the column index of d
    add a7, x0, a6  # the pointer to the start of d

outer_loop_start:


inner_loop_start:
    addi sp, sp, -60
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw a3, 16(sp)
    sw a4, 20(sp)
    sw a5, 24(sp)
    sw a6, 28(sp)
    sw a7, 32(sp)
    sw t0, 36(sp)
    sw t1, 40(sp)
    sw t2, 44(sp)
    sw t3, 48(sp)
    sw t4, 52(sp)
    sw t5, 56(sp)

    slli t3, t1, 2
    mul t3, t3, a2
    add a0, a0, t3
    slli t4, t2, 2
    add a1, a3, t4
    addi a3, x0, 1
    add a4, x0, a5
    jal dot
    mv t6, a0

    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    lw a3, 16(sp)
    lw a4, 20(sp)
    lw a5, 24(sp)
    lw a6, 28(sp)
    lw a7, 32(sp)
    lw t0, 36(sp)
    lw t1, 40(sp)
    lw t2, 44(sp)
    lw t3, 48(sp)
    lw t4, 52(sp)
    lw t5, 56(sp)
    addi sp, sp, 60

    sw t6, 0(a7)

inner_loop_end:
    addi a7, a7, 4
    addi t2, t2, 1
    blt t2, a5, inner_loop_start
    addi t2, x0, 0
    addi t1, t1, 1
    blt t1, a1, outer_loop_start
    j outer_loop_end

outer_loop_end:

    # Epilogue


    jr ra

error_exit:
    li a0, 38
    j exit