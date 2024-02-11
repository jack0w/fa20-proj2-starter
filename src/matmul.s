.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Registers:
#	t0, index of row in iteration
#	t1, index of column in iteration
#	t2, memory location of a specific element of m0 or m1
#	t3, position to fill in the return array
#	s0, the pointer to the start of m0
#	s1, the # of rows of m0
#	s2, the # of columns of m0
#	s3, the pointer to the start of m1
#	s4, the # of rows of m1
#	s5, the # of columns of m1
#	s6, the pointer to the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:
	ebreak
    # Error checks
	li t0, 1
	blt a1, t0, exception_m0
	blt a2, t0, exception_m0
	blt a4, t0, exception_m1
	blt a5, t0, exception_m1
	bne a2, a4, exception_match

    # Prologue
	addi sp, sp, -32
	sw s0, 0(sp)
	sw s1, 4(sp)
	sw s2, 8(sp)
	sw s3, 12(sp)
	sw s4, 16(sp)
	sw s5, 20(sp)
	sw s6, 24(sp)
	sw ra, 28(sp)
	
    # Move args of matmul to s0-s5. a0-a5 need to be reset as args of dots
	mv s0, a0
	mv s1, a1
	mv s2, a2
	mv s3, a3
	mv s4, a4
	mv s5, a5
	mv s6, a6
   
    # Initialize the indices of iterations
	mv t0, x0
	mv t1, x0
        mv t3, x0

outer_loop_start:
	
	bge t0, s1, outer_loop_end 


inner_loop_start:
    # Compute dot product of row i = t0 of m0 and column j = t1 of m1
	slli t2, t0, 2
	mul t2, t2, s2
	add a0, s0, t2
	
	slli t2, t1, 2
	add a1, s3, t2
	
	mv a2, s2
	li a3, 1
	mv a4, s5
	
    # prologue
	addi sp, sp, -12
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t3, 8(sp)
    # call dot
	jal dot
    # epilogue
    	lw t0, 0(sp)
    	lw t1, 4(sp)
    	lw t3, 8(sp)
    	addi sp, sp, 12
    	
    # save return from dot to matrix output d
        slli t4, t3, 2
        add t4, t4, s6
	sw a0, 0(t4)
	
	addi t1, t1, 1
	addi t3, t3, 1
	blt t1, s5, inner_loop_start

inner_loop_end:
	
	mv t1, x0
	addi t0, t0, 1
	j outer_loop_start


outer_loop_end:

    # Epilogue
	lw s0, 0(sp)
	lw s1, 4(sp)
	lw s2, 8(sp)
	lw s3, 12(sp)
	lw s4, 16(sp)
	lw s5, 20(sp)
	lw s6, 24(sp)
	lw ra, 28(sp)
    	addi sp, sp, 32
    ret

    
exception_m0:
	li a1, 72
	j exit2

exception_m1:
	li a1, 73
	j exit2

exception_match:
	li a1, 74
	j exit2
