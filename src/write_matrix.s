.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    # step1 open the file
    mul t0, a2, a3
    addi sp, sp, -24
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw a3, 16(sp)
    sw t0, 20(sp)

    addi a1, x0, 1
    jal fopen
    addi a1, x0, -1
    beq a0, a1, fopen_error

    sw a0, 4(sp)

    # step2 write row and column
    addi a1, sp, 12
    addi a2, x0, 2
    addi a3, x0, 4

    jal fwrite
    addi a2, x0, 2
    bne a0, a2, fwrite_error

    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw t0, 20(sp)
    addi sp, sp, 24

    # step3 write the matrix
    addi sp, sp, -12
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw t0, 8(sp)

    addi a2, t0, 0
    addi a3, x0, 4
    jal fwrite
    lw t0, 8(sp)
    bne a0, t0, fwrite_error

    lw ra, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 12

    # step4 close the file
    addi sp, sp, -4
    sw ra, 0(sp)

    jal fclose
    bne a0, x0, fclose_error

    # Epilogue
    lw ra, 0(sp)
    addi sp, sp, 4
    
    jr ra

fopen_error:
    li a0, 27
    j exit

fwrite_error:
    li a0, 30
    j exit

fclose_error:
    li a0, 28
    j exit