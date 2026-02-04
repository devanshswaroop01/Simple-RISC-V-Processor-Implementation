
`timescale 1ns / 1ps
//------------------------------------------------------------------------------
// RegFile
// Implements the RISC-V register file consisting of 32 registers,
// each 32 bits wide. Supports two simultaneous read ports (rs1, rs2)
// and one synchronous write port (rd).
//
// Special handling ensures x0 is always zero by blocking writes to it.
//------------------------------------------------------------------------------
module RegFile(clk, reset, rg_wrt_en,
    rg_rd_addr1, rg_rd_addr2, rg_wrt_addr, rg_wrt_data,
    rg_rd_data1, rg_rd_data2);

    /** I/O Signals **/
    input clk, reset, rg_wrt_en;     // Clock, reset, and register write enable
    input [4:0] rg_wrt_addr;         // Destination register address (rd)
    input [4:0] rg_rd_addr1;         // Source register 1 address (rs1)
    input [4:0] rg_rd_addr2;         // Source register 2 address (rs2)
    input [31:0] rg_wrt_data;        // Data to be written into rd
    output reg [31:0] rg_rd_data1;   // Read data from rs1
    output reg [31:0] rg_rd_data2;   // Read data from rs2

    integer i;
    reg [31:0] register_file [0:31]; // 32 general-purpose registers
    
    /** Module Behavior **/
    
    // Reset and write operations are synchronous
    always @(posedge clk or posedge reset) begin 
        if (reset) begin
            // Clear all registers during reset
            for (i = 0; i < 32; i = i + 1)
                register_file[i] <= 32'b0;
        end
        // Write data only when enabled and destination is not x0
        else if (rg_wrt_en && rg_wrt_addr != 5'd0) begin
            register_file[rg_wrt_addr] <= rg_wrt_data;
        end
    end    
    
    // Read operations are combinational for single-cycle execution
    always @(*) begin
        rg_rd_data1 <= register_file[rg_rd_addr1];
        rg_rd_data2 <= register_file[rg_rd_addr2];
    end

endmodule // RegFile

