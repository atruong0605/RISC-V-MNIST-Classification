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
    addi t0 x0 5
    j check_1
   
    save_1:
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
        sw ra 36(sp)
        sw s9 40(sp)
        sw s10 44(sp)
        j malloc_1
    
    malloc_1:
        addi s6 x0 4
        add s0 a0 x0
        add s1 a1 x0
        add s2 a2 x0
        addi a0 x0 24
        call malloc
        j check_2
    # Read pretrained m0
    read_m0:
        add s0 a0 x0
        lw a0 4(s1)
        addi a1 s0 0 
        add a2 a1 s6
        call read_matrix
        add s3 a0 x0
        j read_m1
    # Read pretrained m1
    read_m1:
        lw a0 8(s1)
        addi a1 s0 8 
        add a2 a1 s6 
        call read_matrix
        add s4 a0 x0
        j read_input

    # Read input matrix
    read_input:
        lw a0 12(s1)
        addi a1 s0 16 
        add a2 a1 s6 
        call read_matrix
        add s5 a0 x0

        j matmul_1
    # Compute h = matmul(m0, input)
    matmul_1:
      lw a0 0(s0)
      lw t0 20(s0)
      mul a0 a0 t0
      add s7 a0 x0
      mul a0 a0 s6
      call malloc
      j check_4
      
     matmul_2:
      
        add s8 a0 x0
        add a0 s3 x0
        lw a1 0(s0)
        lw a2 4(s0)
        lw a4 16(s0)
        lw a5 20(s0)
        add a3 s5 x0
        add a6 s8 x0
        call matmul
        j relu_1

    # Compute h = relu(h)
    relu_1:
        add a0 s8 x0
        add a1 s7 x0
        call relu
        j matmul_3

    # Compute o = matmul(m1, h)
    matmul_3:
        lw a0 8(s0)
        lw t0 20(s0)
        mul a0 a0 t0
        add s9 a0 x0
        mul a0 a0 s6
        call malloc
        j check_5
     matmul_4:
        add s10 a0 x0
        add a0 s4 x0
        lw a1 8(s0)
        lw a2 12(s0)
        lw a4 0(s0)
        lw a5 20(s0)
        add a3 s8 x0
        add a6 s10 x0
        call matmul
        j write_output
    # Write output matrix o
    write_output:
        lw a0 16(s1)
        add a1 s10 x0
        lw a2 8(s0)
        lw a3 20(s0)
        call write_matrix
        j argmax_1

    # Compute and return argmax(o)
    argmax_1:
        add a0 s10 x0
        add a1 s9 x0
        call argmax
        j print_argmax_1

    # If enabled, print argmax(o) and newline
    print_argmax_1:
        j check_3
        add s9 a0 x0
        j free_1
    free_1:
        add a0 s0 x0
        call free
        add a0 s3 x0
        call free
        add a0 s4 x0
        call free
        add a0 s5 x0
        call free
        add a0 s8 x0
        call free
        add a0 s10 x0
        call free
        add a0 s9 x0
    
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw s8 32(sp)
    lw ra 36(sp)
    lw s9 40(sp)
    lw s10 44(sp)
    addi sp sp 48

    jr ra
    
    check_1:
        bne t0 a0 invalid_1
        j save_1
        
    check_2:
        beq a0 x0 invalid_2
        j read_m0
        
    check_3:
        beq x0 s2 print_1
        add s9 a0 x0
        j free_1
    check_4:
        beq a0 x0 invalid_2
        j matmul_2
    check_5:
        beq a0 x0 invalid_2
        j matmul_4
        
    print_1:
        add s9 a0 x0
	    jal ra print_int
        li a0 '\n'
        jal ra print_char
        add a0 s9 x0
        j free_1
    
    invalid_1:
        li a0 31 
        j exit
    
    invalid_2:
        li a0 26
        j exit