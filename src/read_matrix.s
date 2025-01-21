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
    addi sp sp -48
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw s8 32(sp)
    sw s9  36(sp)
    sw s10 40(sp)
    sw ra 44(sp)
    add s0 a0 x0
    add s1 a1 x0
    add s2 a2 x0
    addi s3 x0 4
    add a1 x0 x0
    jal ra fopen
    addi s4 x0 -1
    j check_1
    
    fread_1:
        add s5 a0 x0
        add a1 s1 x0
        add a2 s3 x0
        jal ra fread
        add a2 s3 x0
        j check_2
        
    fread_2:
        add a0 s5 x0
        add a1 s2 x0
        jal ra fread
        j check_3
        
    malloc_1:
        lw s7 0(s1)
        lw s4 0(s2)
        mul s6 s4 s7
        mul a0 s3 s6
        jal ra malloc
        j check_4
    
    fread_3:
        add s8 a0 x0
        add a1 a0 x0
        add a0 s5 x0
        mul a2 s3 s6
        jal ra fread
        mul a2 s3 s6
        j check_5
        
    fclose_1:
        add a0 s5 x0
        jal ra fclose
        j check_6
        
    check_1:
        beq s4 a0 invalid_1
        j fread_1
    
    check_2:
        bne a0 a2 invalid_2
        j fread_2
        
    check_3:
        bne a0 s3 invalid_2
        j malloc_1
        
    check_4:
        beq a0 x0 invalid_3
           j fread_3
           
    check_5:
        bne a0 a2 invalid_2
        j fclose_1
        
    check_6:
        bne a0 x0 invalid_4
        add a0 s8 x0




    # Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp) 
    lw s7 28(sp)
    lw s8 32(sp)
    lw s9 36(sp)
    lw s10 40(sp)
    lw ra 44(sp)
   
    addi sp sp 48
    jr ra
    
invalid_1:
    li a0 27
    j exit
invalid_2:
	li a0 29
    j exit
invalid_3:
	li a0 26
    j exit
invalid_4:
	li a0 28
    j exit
