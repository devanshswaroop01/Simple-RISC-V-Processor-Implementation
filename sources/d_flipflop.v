
`timescale 1ns / 1ps
//------------------------------------------------------------------------------
// FlipFlop
// Acts as the Program Counter (PC) register.
// Stores the current instruction address and updates it on every clock edge.
//------------------------------------------------------------------------------
module FlipFlop(clk, reset, d, q);

    /** I/O Signals **/
    input        clk;     // System clock
    input        reset;   // Synchronous reset
    input  [7:0] d;       // Next PC value
    output reg [7:0] q;   // Current PC value
 
    /** Module Behavior **/
    // On every rising edge of the clock, update PC
    always @(posedge clk) begin
        if (reset) begin
            // Reset PC to zero during system reset
            q <= 8'b0;
        end
        else begin
            // Load next PC value
            q <= d;
        end
    end

endmodule // FlipFlop

