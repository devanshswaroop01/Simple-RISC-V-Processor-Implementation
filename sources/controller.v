
`timescale 1ns/1ps
//------------------------------------------------------------------------------
// Controller (Main Control Unit)
// Decodes the instruction opcode and generates high-level control signals
// that govern datapath behavior such as:
// - Register write enable
// - ALU source selection
// - Memory read/write
// - Write-back data selection
//------------------------------------------------------------------------------
module Controller(
    ALU_Op, ALU_Src, Mem_Read, Mem_to_Reg, Mem_Write, Opcode, Reg_Write
);

    /** I/O Signals **/
    input  [6:0] Opcode;      // Instruction opcode
    output reg [1:0] ALU_Op;  // ALU operation category
    output reg       ALU_Src; // Selects register or immediate as ALU input
    output reg       Mem_Read;// Enables memory read
    output reg       Mem_to_Reg;// Selects memory data for write-back
    output reg       Mem_Write;// Enables memory write
    output reg       Reg_Write;// Enables register write-back

    /** Module Behavior **/
    always @(*) begin
        case (Opcode)

            // --------------------------------------------------
            // R-type instructions
            // --------------------------------------------------
            7'b0110011: begin
                ALU_Op      = 2'b10;
                ALU_Src     = 1'b0;
                Mem_Read    = 1'b0;
                Mem_to_Reg  = 1'b0;
                Mem_Write   = 1'b0;
                Reg_Write   = 1'b1;
            end
          
            // --------------------------------------------------
            // I-type ALU instructions (addi, andi, ori, slti)
            // --------------------------------------------------
            7'b0010011: begin
                ALU_Op      = 2'b00;
                ALU_Src     = 1'b1;
                Mem_Read    = 1'b0;
                Mem_to_Reg  = 1'b0;
                Mem_Write   = 1'b0;
                Reg_Write   = 1'b1;
            end
          
            // --------------------------------------------------
            // Load word (lw)
            // --------------------------------------------------
            7'b0000011: begin
                ALU_Op      = 2'b01;
                ALU_Src     = 1'b1;
                Mem_Read    = 1'b1;
                Mem_to_Reg  = 1'b1;
                Mem_Write   = 1'b0;
                Reg_Write   = 1'b1;
            end
          
            // --------------------------------------------------
            // Store word (sw)
            // --------------------------------------------------
            7'b0100011: begin
                ALU_Op      = 2'b01;
                ALU_Src     = 1'b1;
                Mem_Read    = 1'b0;
                Mem_to_Reg  = 1'b0;
                Mem_Write   = 1'b1;
                Reg_Write   = 1'b0;
            end
  
        endcase
    end

endmodule // Controller
