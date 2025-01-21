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
    bge x0 a2 invalid_1 # invalid length of array
    bge x0 a3 invalid_2 # invalid stride value
    bge x0 a4 invalid_2 # invalid stride value
    addi t4 x0 0 # final_value = 0
    slli a3 a3 2 # byte offset based on stride_1
    slli a4 a4 2 # byte offset based on stride_2
    addi t5 x0 0 # counter = 1
loop_start:
    bge t5 a2 loop_end # when t5 >= a2, go to loop_end
    lw t1 0(a0) # t1 = array_1[i]
    lw t2 0(a1) # t2 = array_2[i]
    mul t3 t1 t2 # t1 * t2
    add t4 t4 t3 # final_value += t3
    add a0 a0 a3 # changes the address
    add a1 a1 a4 # changes the address
    addi t5 t5 1 # add 1 to counter
    j loop_start
invalid_1:
    li a0 36
    j exit
    
invalid_2:
    li a0 37
    j exit

loop_end:
    add a0 t4 x0 # return value
    # Epilogue


    jr ra
