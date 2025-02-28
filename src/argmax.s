.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    addi t0, x0, 1
    bge a1, t0, loop_start
    li a0, 36
    j exit

loop_start:

    addi t0, x0, 0
    lw t1, 0(a0)
    addi t2, x0, 0


loop_continue:
    lw t3, 0(a0)
    bge t1, t3, loop_branch
    addi t0, t2, 0
    addi t1, t3, 0

loop_branch:
    addi t2, t2, 1
    addi a0, a0, 4
    blt t2, a1, loop_continue

loop_end:
    # Epilogue
    mv a0, t0

    jr ra
