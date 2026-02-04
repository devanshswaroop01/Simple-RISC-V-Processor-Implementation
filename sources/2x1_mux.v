
`timescale 1ns / 1ps
//------------------------------------------------------------------------------
// Mux2_1
// A generic 2-to-1 multiplexer.
// Used in the datapath to select between:
// 1) Register operand and immediate value (ALU source)
// 2) ALU result and memory data (write-back stage)
//------------------------------------------------------------------------------
module Mux2_1(s, d0, d1, y);

    /** I/O Signals **/
    input         s;      // Select signal
    input  [31:0] d0;     // Input 0
    input  [31:0] d1;     // Input 1
    output [31:0] y;      // Selected output
    
    /** Module Behavior **/
    // Select between d0 and d1 based on select signal
    assign y = s ? d1 : d0;

endmodule // Mux2_1
 
