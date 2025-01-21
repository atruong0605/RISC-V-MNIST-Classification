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
    addi sp sp -24
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw ra 20(sp)
    j fopen_1
    
    fopen_1:
        addi s4 x0 4
        add s0 a1 x0
        add s1 a2 x0
        add s2 a3 x0
        addi a1 x0 1
        jal ra fopen
        addi a1 x0 -1
        j check_1
        
     fwrite_1:
        add s3 a0 x0
        addi sp sp -8
        sw s1 0(sp)
        sw s2 4(sp)
        add a1 sp x0
        addi sp sp 8
        add a3 s4 x0
        addi a2 x0 2
        jal ra fwrite
        addi t0 x0 2
        j check_2
        
     fwrite_2:
        add a0 s3 x0
        mul a2 s1 s2
        add a3 s4 x0
        add a1 s0 x0
        jal ra fwrite
        mul a2 s1 s2
        j check_3
     fclose_1:
        add a0 s3 x0
        jal ra fclose
        j check_4
     check_1:
        beq a0 a1 invalid_1
        j fwrite_1
     check_2:
        bne a0 t0 invalid_2
        j fwrite_2
     check_3:
        bne a0 a2 invalid_2
        j fclose_1
     check_4:
        bne a0 x0 invalid_3
        
    # Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw ra 20(sp)
    addi sp sp 24

    jr ra
    
    invalid_1:
        li a0 27
        j exit
     
    invalid_2:
        li a0 30
        j exit
        
    invalid_3:
        li a0 28
        j exit
