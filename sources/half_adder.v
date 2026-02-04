
`timescale 1ns / 1ps
//------------------------------------------------------------------------------
// HalfAdder
// Used for simple addition operations.
// In this design, it is specifically used to compute PC + 4 for sequential
// instruction execution in the single-cycle RISC-V processor.
//------------------------------------------------------------------------------
module HalfAdder(a, b, c_out, sum);

    /** I/O Signals **/
    input  [7:0] a;       // First operand (PC value)
    input  [7:0] b;       // Second operand (constant 4)
    output        c_out;  // Carry-out (unused in PC logic)
    output [7:0]  sum;    // Sum output (next PC value)
        
    /** Module Behavior **/
    // Perform addition and concatenate carry-out with sum
    assign {c_out, sum} = a + b; 

endmodule // HalfAdder

