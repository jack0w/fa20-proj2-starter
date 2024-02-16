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
# Registers:
#   s0 is the pointer to string representing the filename
#   s1 is the pointer to the number of rows
#   s2 is the pointer to the number of columns
#   s3 is the file descriptor, which is a unique integer tied to the file
#   s4 is the pointer to reader buffer (This is redundant)
#   s5 is the number of rows
#   s6 is the number of columns
#   t0 is the temp comparator

# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

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
	
	mv s0, a0
	mv s1, a1
	mv s2, a2
	
    # Set arguments for fopen
	mv a1, s0
	mv a2, x0
    # Call fopen
        jal fopen
    # Save the returned file descriptor
        mv s3, a0
    # Exception handling    
        li t0, -1
        beq s3, t0, fopen_error
	
    # Set arguments for read_words: Read num of row & col in binary file
    	mv a0, s3
    	li a1, 2
    # Call read_words
    	jal read_words
    # Save the returned pointer to reader buffer
    	mv s4, a0
    # Get num of row & col
    	lw s5, 0(s4)
    	lw s6, 4(s4)
    # Save num of row & col in return pointers to int 
    	sw s5, 0(s1)
    	sw s6, 0(s2)
    # Free the allocated memory
    	mv a0, s4
    	jal free
    # Set arguments for read_words: Read the matrix
    	mv a0, s3
    	mul t0, s5, s6
    	mv a1, t0
    # Call read_words
    	jal read_words
    # Save the returned pointer to reader buffer
    	mv s4, a0

    # Set argument for fclose
    	mv a0, s3
    # Call fclose
    	jal fclose
    # Exception handling
    	li t0, -1
        beq a0, t0, fclose_error
    # Copy s4 to return pointer a0
    	mv a0, s4
    
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
    
fopen_error:
	li a1, 90
	j exit2

malloc_error:
	li a1, 88
	j exit2

fread_error:
	li a1, 91
	j exit2
	
fclose_error:
	li a1, 92
	j exit2

# Arguments:
# args:
#   a0 = file descriptor
#   a1 = Number of elements(integer) to be read.
# return:
#   a0 = pointer to the read buffer
# registers:
#   s0 = file descriptor
#   s1 = Number of bytes to be read
#   s2 = pointer to the read buffer

read_words:
    # Prologue
    	addi sp, sp, -16
    	sw s0, 0(sp)
    	sw s1, 4(sp)
    	sw s2, 8(sp)
    	sw ra, 12(sp)

	mv s0, a0
    	slli a1, a1, 2
	mv s1, a1

    # Set arguments for malloc
    	mv a0, s1
    # malloc for reader buffer. Don't forget to free the allocated memory in the end!
        jal malloc
    # Save the returned buffer reader
	mv s2, a0
    # Exception handling
	li t0, 0
	beq s2, t0, malloc_error
	
    # Set arguments for fread
    	mv a1, s0
    	mv a2, s2
    	mv a3, s1
    # Call fread
    	jal fread
    # Exception handling
    	bne a0, s1, fread_error
    	mv a0, s2
    	
    # Epilogue
    	lw s0, 0(sp)
    	lw s1, 4(sp)
    	lw s2, 8(sp)
    	lw ra, 12(sp)
	addi sp, sp, 16
	
	ret
