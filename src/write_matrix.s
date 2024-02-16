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
# Registers:
#   s0 is the pointer to string representing the filename
#   s1 is the pointer to the start of the matrix in memory
#   s2 is the number of rows in the matrix
#   s3 is the number of columns in the matrix
#   s4 is the file descriptor
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
	addi sp, sp, -24
	sw s0, 0(sp)
	sw s1, 4(sp)
	sw s2, 8(sp)
	sw s3, 12(sp)
	sw s4, 16(sp)
	sw ra, 20(sp)
	
	mv s0, a0
	mv s1, a1
	mv s2, a2
	mv s3, a3
	
    # Set arguments for fopen
	mv a1, s0
	li a2, 1
    # Call fopen
        jal fopen
    # Save the returned file descriptor
        mv s4, a0
    # Exception handling    
        li t0, -1
        beq s4, t0, fopen_error

    # Set arguments for fwrite: Write num of rows & cols
    	mv a1, s4
    	li a3, 2
    	li a4, 4
    # Use stack pointer as pointer to buffer
    	addi sp, sp, -8
    	sw s2, 0(sp)
    	sw s3, 4(sp)
    	mv a2, sp
    # Call fwrite
    	jal fwrite
    # Exception handling
    	li t0, 2
    	bne a0, t0, fwrite_error
    # Reset sp
    	addi sp, sp, 8
    
    # Set arguments for fwrite: Write matrix
    	mv a1, s4
    	mv a2, s1
    	mul t0, s2, s3
    	mv a3, t0
    	li a4, 4
    # Call fwrite
    	jal fwrite
    # Exception handling
    	mul t0, s2, s3
    	bne a0, t0, fwrite_error
    	
    # Set argument for fclose
    	mv a0, s4
    # Call fclose
    	jal fclose
    # Exception handling
    	li t0, -1
        beq a0, t0, fclose_error
    
    # Epilogue
	lw s0, 0(sp)
	lw s1, 4(sp)
	lw s2, 8(sp)
	lw s3, 12(sp)
	lw s4, 16(sp)
	lw ra, 20(sp)
	addi, sp, sp, 24
    ret
    
fopen_error:
	li a1, 93
	j exit2

fwrite_error:
	li a1, 94
	j exit2
	
fclose_error:
	li a1, 95
	j exit2
