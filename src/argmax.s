.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Registers:
#	t0, index of array
#	t1, memory location of a specific element
#	t2, element at certain index
#	t3, the first index of the largest element in the current iteration
#	t4, the largest element in the current iteration
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    
    # Prologue
	li t0, 1
	blt a1, t0, exception
	li t0, 0
	li t3, 0

loop_start:
	slli t1, t0, 2
	add t1, a0, t1
	lw t2, 0(t1)
	beq t0, x0, load_first
	bge t4, t2, loop_continue
	mv t4, t2
	mv t3, t0

loop_continue:
	addi t0, t0, 1
	blt t0, a1, loop_start

loop_end:
    # Epilogue
    mv a0, t3
    ret
    
load_first:
	mv t4, t2
	j loop_continue

exception:
	li a1, 77
	j exit2
