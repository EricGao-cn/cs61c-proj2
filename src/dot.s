.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:

    # Prologue
    addi t0, x0, 1
    blt a2, t0, exp1
    blt a3, t0, exp2
    blt a4, t0, exp2
    j loop_start

exp1:
    li a0, 36
    j exit
exp2:
    li a0, 37
    j exit

loop_start:
    addi t0, x0, 0  # result
    addi t1, x0, 0  # index of arr0
    slli t5, a3, 2  # step of add0
    slli t6, a4, 2  # step of add1

loop_body:
    lw t3, 0(a0)  # load arr0[i]
    lw t4, 0(a1)  # load arr1[i]
    mul t3, t3, t4  # arr0[i] * arr1[i]
    add t0, t0, t3  # result += arr0[i] * arr1[i]
    add a0, a0, t5  # arr0 += stride0
    add a1, a1, t6  # arr1 += stride1
    addi t1, t1, 1 
    blt t1, a2, loop_body
    j loop_end

loop_end:

    # Epilogue
    mv a0, t0

    jr ra
