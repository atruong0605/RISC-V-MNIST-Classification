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
    addi t3 x0 1
	add t0 t3 x0
    bge a1 t0 loop_start
    j invalid
   

loop_start:
	beq a1 x0 loop_end
    lw t1 0(a0)
    
    bge t1 x0 loop_continue
    
    sw x0 0(a0)
    
loop_continue:
    addi t4 x0 -1
	add a1 a1 t4
    addi t5 x0 4
    add a0 a0 t5
    j loop_start

loop_end:
	jr ra
    
invalid:
    li a0 36
    j exit
