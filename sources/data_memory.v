
`timescale 1ns / 1ps
//------------------------------------------------------------------------------
// DataMem
// Data memory used for load (lw) and store (sw) instructions.
// Writes are synchronous to the clock, while reads are combinational,
// matching single-cycle RISC-V behavior.
//------------------------------------------------------------------------------
module DataMem(mem_read, mem_write, addr, write_data, clk, read_data);

    /** I/O Signals **/
    input        mem_read;     // Memory read enable
    input        mem_write;    // Memory write enable
    input  [8:0] addr;         // Address from ALU
    input  [31:0] write_data;  // Data to be written to memory
    input        clk;          // System clock
    output reg [31:0] read_data; // Data read from memory

    reg [31:0] memory [127:0]; // Data memory array

    /** Module Behavior **/

    // Combinational read for load instructions
    always @(*) begin
        if (mem_read)
            read_data <= memory[addr[8:2]];
        else
            read_data <= 32'b0;
    end

    // Synchronous write for store instructions
    always @(posedge clk) begin
        if (mem_write)
            memory[addr[8:2]] <= write_data;
    end
endmodule // DataMem
