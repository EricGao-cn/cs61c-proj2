.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue


loop_start:

addi t0, x0, 1
bge a0, t0, loop_continue
li a0, 36
j exit

addi t0, x0, 1

loop_continue:

lw t1, 0(a0)
bge t1, x0, loop_branch
li t1, 0
sw t1, 0(a0)

loop_branch:
addi t0, t0, 1
addi a0, a0, 4
blt t0, a1, loop_continue

loop_end:


    # Epilogue


    jr ra
