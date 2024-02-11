.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Registers:
#	t0, index of two arrays 
#	t1, memory location of a specific element of one array
#	t2, element at certain index of one array
#	t3, dot product value in current iteration
#	t4, dot product sum
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:

    # Prologue
	li t0, 1
	blt a2, t0, exception_vector
	blt a3, t0, exception_stride
	blt a4, t0, exception_stride
	li t0, 0
	li t4, 0

loop_start:
	# get element of v0 
	slli t1, t0, 2
	mul t1, t1, a3
	add t1, a0, t1
	lw t2, 0(t1)
	mv t3, t2
	
	# get element of v1
	slli t1, t0, 2
	mul t1, t1, a4
	add t1, a1, t1
	lw t2, 0(t1)
	mul t3, t3, t2
	
	# increment the total sum
	add t4, t4, t3
	
	addi t0, t0, 1
	blt t0, a2, loop_start
	
loop_end:


    # Epilogue

    	mv a0, t4
    ret


exception_vector:
	li a1, 75
	j exit2

exception_stride:
	li a1, 76
	j exit2

	

