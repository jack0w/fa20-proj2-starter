.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Registers:
#	t0, index of array
#	t1, memory location of a specific element
#	t2, element at certain index
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
	li t0, 1
	blt a1, t0, exception
	li t0, 0

loop_start:
	slli t1, t0, 2
	add t1, a0, t1
	lw t2, 0(t1)
	
	bge t2, x0, loop_continue
	sw x0, 0(t1)
	
loop_continue:
	addi t0, t0, 1
	blt t0, a1, loop_start
	
	
loop_end:
    # Epilogue
    ret

exception:
	li a1, 78
	j exit2

