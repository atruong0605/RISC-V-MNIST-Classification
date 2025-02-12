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
    addi a2 x0 1
    add t1 x0 x0
    add t0 x0 x0
    bge a1 a2 loop_start_1
    j invalid

    
loop_start_1:
	lw t3 0(a0)
    beq a1 x0 loop_end
    lw t2 0(a0)
    addi t2 t2 1
    
    blt t2 t3 loop_continue
    
    add t3 t2 x0
    add t0 t1 x0
    j loop_continue
    j loop_start

loop_start:
	beq a1 x0 loop_end
    lw t2 0(a0)
    addi t2 t2 1
    
    blt t2 t3 loop_continue
    
    add t3 t2 x0
    add t0 t1 x0
    j loop_continue
    
loop_continue:
	addi t1 t1 1
	addi a0 a0 4
    addi a1 a1 -1
    j loop_start

loop_end:
	add a0 t0 x0
    jr ra
    
 invalid:
    li a0 36
    j exit
