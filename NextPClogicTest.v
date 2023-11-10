`timescale 1ns / 1ps
`define STRLEN 32
module NextPClogic_TB;

	task passTest;
		input [63:0] actualOut, expectedOut;
		input [`STRLEN*8:0] testType;
		inout [7:0] passed;
	
		if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
		else $display ("%s failed: %x should be %x", testType, actualOut, expectedOut);
	endtask
	
	task allPassed;
		input [7:0] passed;
		input [7:0] numTests;
		
		if(passed == numTests) $display ("All tests passed");
		else $display("Some tests failed");
	endtask

	// Inputs
	reg [63:0] CurrentPC, SignExtImm64;
	reg Branch, ALUZero, Uncondbranch;
	reg [7:0] passed;

	// Outputs
	wire [63:0] NextPC;

	initial 
	begin
		$dumpfile("pclogic.vcd");
		$dumpvars(0, NextPClogic_TB);
	end
	// Instantiate the Unit Under Test (UUT)
	NextPClogic uut (
		.NextPC(NextPC), 
		.CurrentPC(CurrentPC), 
		.SignExtImm64(SignExtImm64), 
		.Branch(Branch), 
		.ALUZero(ALUZero),
		.Uncondbranch(Uncondbranch)
	);

	initial begin
		// Initialize Inputs
		CurrentPC = 0;
		SignExtImm64 = 0;
		Branch = 0;
		ALUZero = 0;
		Uncondbranch = 0;
		passed = 0;

                // Here is one example test vector, testing the ADD instruction:
		#40;{CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'b0, 64'hABCD0000, 1'b0, 1'b0, 1'b0}; #10; passTest({NextPC}, 64'b100, "Case 1", passed);
		#40;{CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'b0, 64'hA, 1'b0, 1'b0, 1'b1}; #10; passTest({NextPC}, 64'hA, "Case 2", passed);
		#40;{CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'b0, 64'hB, 1'b1, 1'b1, 1'b0}; #10; passTest({NextPC}, 64'hB, "Case 2", passed);
		#40;{CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'b0, 64'hA, 1'b1, 1'b0, 1'b0}; #10; passTest({NextPC}, 64'b100, "Case 1,2", passed);
		#40;{CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'b0, 64'hC, 1'b0, 1'b1, 1'b0}; #10; passTest({NextPC}, 64'b100, "Case 1,2", passed);



		//Reformate and add your test vectors from the prelab here following the example of the testvector above.
		allPassed(passed, 5);
	end
endmodule
 
