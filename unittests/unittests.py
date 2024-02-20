from unittest import TestCase
from framework import AssemblyTest, print_coverage


class TestAbs(TestCase):
    def test_zero(self):
        t = AssemblyTest(self, "abs.s")
        # load 0 into register a0
        t.input_scalar("a0", 0)
        # call the abs function
        t.call("abs")
        # check that after calling abs, a0 is equal to 0 (abs(0) = 0)
        t.check_scalar("a0", 0)
        # generate the `assembly/TestAbs_test_zero.s` file and run it through venus
        t.execute()

    def test_one(self):
        # same as test_zero, but with input 1
        t = AssemblyTest(self, "abs.s")
        t.input_scalar("a0", 1)
        t.call("abs")
        t.check_scalar("a0", 1)
        t.execute()
    
    def test_minus_one(self):
    	t = AssemblyTest(self, "abs.s")
    	t.input_scalar("a0", -1)
    	t.call("abs")
    	t.check_scalar("a0", 1)
    	t.execute()

    @classmethod
    def tearDownClass(cls):
        print_coverage("abs.s", verbose=False)


class TestRelu(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "relu.s")
        # create an array in the data section
        array0 = t.array([1, -2, 3, -4, 5, -6, 7, -8, 9])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", len(array0))
        # call the relu function
        t.call("relu")
        # check that the array0 was changed appropriately
        t.check_array(array0, [1, 0, 3, 0, 5, 0, 7, 0, 9])
        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute()
    
    def test_all_zero(self):
    	t = AssemblyTest(self, "relu.s")
    	array0 = t.array([0, 0, 0, 0, 0, 0, 0, 0, 0])
    	t.input_array("a0", array0)
    	t.input_scalar("a1", len(array0))
    	t.call("relu")
    	t.check_array(array0, [0, 0, 0, 0, 0, 0, 0, 0, 0])
    	t.execute()
    
    def test_exception_handling(self):
    	t = AssemblyTest(self, "relu.s")
    	array0 = t.array([1])
    	t.input_array("a0", array0)
    	t.input_scalar("a1", 0)
    	t.call("relu")
    	t.check_array(array0, [1])
    	t.execute(code = 78)

    @classmethod
    def tearDownClass(cls):
        print_coverage("relu.s", verbose=False)


class TestArgmax(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([1,4,-1,8,10,2,10])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 4)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()
    
    def test_length_one(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([-100])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 0)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()
    
    def test_exception_handling(self):
    	t = AssemblyTest(self, "argmax.s")
    	array0 = t.array([1])
    	t.input_array("a0", array0)
    	t.input_scalar("a1", 0)
    	t.call("argmax")
    	t.check_scalar("a0", 0)
    	t.execute(code = 77)

    @classmethod
    def tearDownClass(cls):
        print_coverage("argmax.s", verbose=False)


class TestDot(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        array1 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])

        # load array addresses into argument registers
       	t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", 9)
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 1)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 285)
        t.execute()
    
    def test_simple_stride(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        array1 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])

        # load array addresses into argument registers
       	t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", 3)
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 2)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 22)
        t.execute()
    
    def test_exception_handling_vector(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        array1 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])

        # load array addresses into argument registers
       	t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", 0)
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 1)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 285)
        t.execute(75)
        
    def test_exception_handling_stride(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        array1 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])

        # load array addresses into argument registers
       	t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", 9)
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 0)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 285)
        t.execute(76)
    
    
    @classmethod
    def tearDownClass(cls):
        print_coverage("dot.s", verbose=False)


class TestMatmul(TestCase):

    def do_matmul(self, m0, m0_rows, m0_cols, m1, m1_rows, m1_cols, result, code=0):
        t = AssemblyTest(self, "matmul.s")
        # we need to include (aka import) the dot.s file since it is used by matmul.s
        t.include("dot.s")

        # create arrays for the arguments and to store the result
        array0 = t.array(m0)
        array1 = t.array(m1)
        array_out = t.array([0] * len(result))

        # load address of input matrices and set their dimensions
        t.input_array("a0", array0)
        t.input_scalar("a1", m0_rows)
        t.input_scalar("a2", m0_cols)
        t.input_array("a3", array1)
        t.input_scalar("a4", m1_rows)
        t.input_scalar("a5", m1_cols)
        # load address of output array
        t.input_array("a6", array_out)

        # call the matmul function
        t.call("matmul")

        # check the content of the output array
        t.check_array(array_out, result)

        # generate the assembly file and run it through venus, we expect the simulation to exit with code `code`
        t.execute(code=code)

    def test_simple(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150]
        )
    def test_edge(self):
        self.do_matmul(
            [1, -4, 9, 5, 4, -8, -8, 9], 4, 2,
            [2, 0, 4, 7, 0, 8, 9, 8], 2, 4,
            [2, -32, -32, -25, 18, 40, 81, 103, 8, -64, -56, -36, -16, 72, 49, 16]
        )
        self.do_matmul(
            [7, 8, 5, 1, 1, 1, 6, 4], 4, 2,
            [7, 7, 2, 4, 6, 7, 8, 4, 9, 0], 2, 5,
            [105, 113, 46, 100, 42, 42, 43, 14, 29, 30, 14, 15, 6, 13, 6, 70, 74, 28, 60, 36]
        )
        self.do_matmul(
            [-10], 1, 1,
            [-20], 1, 1,
            [200]
        )
        self.do_matmul(
            [1, 9, 4, 8], 4, 1,
            [2, 0, 4, 7], 1, 4,
            [2, 0, 4, 7, 18, 0, 36, 63, 8, 0, 16, 28, 16, 0, 32, 56]
        )
        self.do_matmul(
            [1, -4, 2], 1, 3,
            [-2, 0, 2], 3, 1,
            [2]
        )
        self.do_matmul(
            [7, 6, 7], 1, 3,
            [3, 1, 1, 8, 8, 1], 3, 2,
            [83, 62]
        )
        
    def test_exception_handling(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 0, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150],
            72
        )
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 0, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150],
            73
        )
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 0,
            [30, 36, 42, 66, 81, 96, 102, 126, 150],
            73
        )
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 0,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150],
            72
        )
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 6, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150],
            74
        )
        
    @classmethod
    def tearDownClass(cls):
        print_coverage("matmul.s", verbose=False)


class TestReadMatrix(TestCase):

    def do_read_matrix(self, fail='', code=0):
        t = AssemblyTest(self, "read_matrix.s")
        # load address to the name of the input file into register a0
        t.input_read_filename("a0", "inputs/test_read_matrix/test_input.bin")

        # allocate space to hold the rows and cols output parameters
        rows = t.array([-1])
        cols = t.array([-1])

        # load the addresses to the output parameters into the argument registers
        t.input_array("a1", rows)
        t.input_array("a2", cols)

        # call the read_matrix function
        t.call("read_matrix")

        # check the output from the function
        t.check_array(rows, [3])
        t.check_array(cols, [3])
        t.check_array_pointer("a0", [1, 2, 3, 4, 5, 6, 7, 8, 9])

        # generate assembly and run it through venus
        t.execute(fail=fail, code=code)

    def test_simple(self):
        self.do_read_matrix()
        self.do_read_matrix(fail='fopen', code = 90)
        self.do_read_matrix(fail='malloc', code = 88)
        self.do_read_matrix(fail='fread', code = 91)
        self.do_read_matrix(fail='fclose', code = 92)
    
    def do_read_matrix_2(self, fail='', code=0):
        t = AssemblyTest(self, "read_matrix.s")
        # load address to the name of the input file into register a0
        t.input_read_filename("a0", "inputs/test_read_matrix/m1.bin")

        # allocate space to hold the rows and cols output parameters
        rows = t.array([-1])
        cols = t.array([-1])

        # load the addresses to the output parameters into the argument registers
        t.input_array("a1", rows)
        t.input_array("a2", cols)

        # call the read_matrix function
        t.call("read_matrix")

        # check the output from the function
        t.check_array(rows, [5])
        t.check_array(cols, [3])
        t.check_array_pointer("a0", [1, -3, 4, 46, -2, -5, 2, -62, 0, 1, 3, 13, 26, -7, 34])

        # generate assembly and run it through venus
        t.execute(fail=fail, code=code)
        
    def test_simple_2(self):
        self.do_read_matrix_2()
        self.do_read_matrix_2(fail='fopen', code = 90)
        self.do_read_matrix_2(fail='malloc', code = 88)
        self.do_read_matrix_2(fail='fread', code = 91)
        self.do_read_matrix_2(fail='fclose', code = 92)

    @classmethod
    def tearDownClass(cls):
        print_coverage("read_matrix.s", verbose=False)


class TestWriteMatrix(TestCase):

    def do_write_matrix(self, outfile, array0, rows, cols, reference, fail='', code=0):
        t = AssemblyTest(self, "write_matrix.s")
        # load output file name into a0 register
        t.input_write_filename("a0", outfile)
        # load input array and other arguments
        array0 = t.array(array0)
        t.input_array("a1", array0)
        t.input_scalar("a2", rows)
        t.input_scalar("a3", cols)
        # call `write_matrix` function
        t.call("write_matrix")
        # generate assembly and run it through venus
        t.execute(fail=fail, code=code)
        # compare the output file against the reference
        if (fail == ''):
            t.check_file_output(outfile, reference)
        	

    def test_simple(self):
        outfileName = "outputs/test_write_matrix/student.bin"
        arrayVal = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        rowVal = 3
        colVal = 3
        referenceName = "outputs/test_write_matrix/reference.bin"
        self.do_write_matrix(outfileName, arrayVal, rowVal, colVal, referenceName)
        self.do_write_matrix(outfileName, arrayVal, rowVal, colVal, referenceName, fail='fopen', code=93)
        self.do_write_matrix(outfileName, arrayVal, rowVal, colVal, referenceName, fail="fwrite", code=94)
        self.do_write_matrix(outfileName, arrayVal, rowVal, colVal, referenceName, fail="fclose", code=95)
        
    def test_custom(self):
        outfileName = "outputs/test_write_matrix/student_m1.bin"
        arrayVal = [1, -3, 4, 46, -2, -5, 2, -62, 0, 1, 3, 13, 26, -7, 34]
        rowVal = 5
        colVal = 3
        referenceName = "outputs/test_write_matrix/reference_m1.bin"
        self.do_write_matrix(outfileName, arrayVal, rowVal, colVal, referenceName)
        self.do_write_matrix(outfileName, arrayVal, rowVal, colVal, referenceName, fail='fopen', code=93)
        self.do_write_matrix(outfileName, arrayVal, rowVal, colVal, referenceName, fail="fwrite", code=94)
        self.do_write_matrix(outfileName, arrayVal, rowVal, colVal, referenceName, fail="fclose", code=95)

    @classmethod
    def tearDownClass(cls):
        print_coverage("write_matrix.s", verbose=False)


class TestClassify(TestCase):

    def make_test(self):
        t = AssemblyTest(self, "classify.s")
        t.include("argmax.s")
        t.include("dot.s")
        t.include("matmul.s")
        t.include("read_matrix.s")
        t.include("relu.s")
        t.include("write_matrix.s")
        return t

    def test_simple0_input0(self):
        t = self.make_test()
        out_file = "outputs/test_basic_main/student0.bin"
        ref_file = "outputs/test_basic_main/reference0.bin"
        args = ["inputs/simple0/bin/m0.bin", "inputs/simple0/bin/m1.bin",
                "inputs/simple0/bin/inputs/input0.bin", out_file]
        # call classify function
        t.input_scalar("a0", 5)
        t.input_scalar("a2", 0)
        t.call("classify")
        # generate assembly and pass program arguments directly to venus
        t.execute(args=args)
        t.check_file_output(out_file, ref_file)
        t.check_scalar("a0", 2)

    @classmethod
    def tearDownClass(cls):
        print_coverage("classify.s", verbose=False)


class TestMain(TestCase):

    def run_main(self, inputs, output_id, label):
        args = [f"{inputs}/m0.bin", f"{inputs}/m1.bin", f"{inputs}/inputs/input0.bin",
                f"outputs/test_basic_main/student{output_id}.bin"]
        reference = f"outputs/test_basic_main/reference{output_id}.bin"
        t = AssemblyTest(self, "main.s", no_utils=True)
        t.call("main")
        t.execute(args=args, verbose=False)
        t.check_stdout(label)
        t.check_file_output(args[-1], reference)

    def test0(self):
        self.run_main("inputs/simple0/bin", "0", "2")

    def test1(self):
        self.run_main("inputs/simple1/bin", "1", "1")
        
