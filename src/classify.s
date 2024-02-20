.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Registers:
    #	s0 is the pointer to the pointers of char array
    #   s1 is the print_classification indicator
    #   s2 is the pointer to the start of m0
    #   s3 is the pointer to the start of m1
    #	s4 is the pointer to the start of input matrix
    #   s5 is the pointer to array of m0_row, m0_col, input_row, input_col, m1_row, m1_col
    #   s6 is the pointer to the result of matmul(m0, input)
    #	s7 is the pointer to the result of matmul(m1, hidden_layer)
    #   s8 is the classification result
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>


    # Prologue
	addi sp, sp, -40
	sw s0, 0(sp)
	sw s1, 4(sp)
	sw s2, 8(sp)
	sw s3, 12(sp)
	sw s4, 16(sp)
	sw s5, 20(sp)
	sw s6, 24(sp)
	sw s7, 28(sp)
	sw s8, 32(sp)
	sw ra, 36(sp)	
	
    # first word of a1 contains "TestClassify_test_simple0_input0.s"
	addi s0, a1, 4
    	mv s1, a2
    	ebreak
    # Exception handling    
        li t0, 5
        bne a0, t0, argnum_error

    # =====================================
    # LOAD MATRICES
    # =====================================

    # malloc space of storing row, col num of m0, input, m1
    # Set arguments for malloc
    	li a0, 24
    # Call malloc. Don't forget to free the allocated memory in the end!
        jal malloc
    # Save the returned pointer to memory
	mv s5, a0
    # Exception handling
	li t0, 0
	beq s5, t0, malloc_error
	ebreak
    # Load pretrained m0
    # Set arguments for read_matrix
	lw a0, 0(s0)
	addi a1, s5, 0
	addi a2, s5, 4
    # Call read_matrix
    	jal read_matrix
    # Save the return pointer to matrix. Free s2 in the end!
    	mv s2, a0

    # Load pretrained m1
    # Set arguments for read_matrix
	lw a0, 4(s0)
	addi a1, s5, 8
	addi a2, s5, 12
    # Call read_matrix
    	jal read_matrix
    # Save the return pointer to matrix. Free s3 in the end!
    	mv s3, a0
    	
    # Load input matrix
    # Set arguments for read_matrix
	lw a0, 8(s0)
	addi a1, s5, 16
	addi a2, s5, 20
    # Call read_matrix
    	jal read_matrix
    # Save the return pointer to matrix. Free s4 in the end!
    	mv s4, a0


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # Allocate memory for the mult result
    # Set arguments for malloc
    	lw t0, 0(s5)
    	lw t1, 20(s5)
    	mul a0, t0, t1
    	slli a0, a0, 2
    # Call malloc. Don't forget to free the allocated memory in the end!
        jal malloc
    # Save the returned pointer to memory
	mv s6, a0
    # Exception handling
	li t0, 0
	beq s6, t0, malloc_error
	
    # Set arguments for matmul
    	mv a0, s2
    	lw a1, 0(s5)
    	lw a2, 4(s5)
    	mv a3, s4
    	lw a4, 16(s5)
    	lw a5, 20(s5)
    	mv a6, s6
    # Call matmul
    	jal matmul
    
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # Set arguments for relu
    	mv a0, s6
    	lw t0, 0(s5)
    	lw t1, 20(s5)
    	mul a1, t0, t1
    # Call relu
    	jal relu
    
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    # Set arguments for malloc
    	lw t0, 8(s5)
    	lw t1, 20(s5)
    	mul a0, t0, t1
    	slli a0, a0, 2
    # Call malloc. Don't forget to free the allocated memory in the end!
        jal malloc
    # Save the returned pointer to memory
	mv s7, a0
    # Exception handling
	li t0, 0
	beq s7, t0, malloc_error

    # Set arguments for matmul
    	mv a0, s3
    	lw a1, 8(s5)
    	lw a2, 12(s5)
    	mv a3, s6
    	lw a4, 0(s5)
    	lw a5, 20(s5)
    	mv a6, s7
    # Call matmul
    	jal matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    # set arguments for write_matrix
    	lw a0, 12(s0)
    	mv a1, s7
    	lw a2, 8(s5)
    	lw a3, 20(s5)
    # Call write_matrix
	jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    # Set arguments for argmax
    	mv a0, s7
    	lw t0, 8(s5)
    	lw t1, 20(s5)
    	mul a1, t0, t1
    # Call argmax
    	jal argmax
    # Save the return value
    	mv s8, a0
   	
    	mv t0, x0
    	bne s1, t0, skip_print
    	
    # Print classification
    # Set arguments for print_int
    	mv a1, s8
    # Call print_int
    	jal print_int

    # Print newline afterwards for clarity
    # Set arguments for print_char
    	li a1, 10
    # Call print_char
    	jal print_char

skip_print:
    # Free allocated memeory
    	mv a0, s2
    	jal free
    	
    	mv a0, s3
    	jal free
    	
    	mv a0, s4
    	jal free
    	
    	mv a0, s5
    	jal free
    	
    	mv a0, s6
    	jal free
    	
    	mv a0, s7
    	jal free
    
    # Epilogue
    	lw s0, 0(sp)
	lw s1, 4(sp)
	lw s2, 8(sp)
	lw s3, 12(sp)
	lw s4, 16(sp)
	lw s5, 20(sp)
	lw s6, 24(sp)
	lw s7, 28(sp)
	lw s8, 32(sp)
	lw ra, 36(sp)
	addi sp, sp, 40
	
	mv a0, s8
    ret
    
argnum_error:
	li a1, 89
	j exit2
	
malloc_error:
	li a1, 88
	j exit2
