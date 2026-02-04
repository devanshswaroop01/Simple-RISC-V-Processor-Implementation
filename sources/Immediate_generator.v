`timescale 1ns/1ps
//------------------------------------------------------------------------------
// ImmGen (Immediate Generator)
// Extracts and sign-extends immediate values from the instruction word.
// Supports I-type, S-type, and U-type instruction formats as required
// by the implemented RISC-V subset.
//------------------------------------------------------------------------------
module ImmGen (instr_code, imm_out);

    /** I/O Signals **/
    input  [31:0] instr_code;  // Full 32-bit instruction
    output reg [31:0] imm_out; // Generated immediate value

    /** Module Behavior **/
    always @(instr_code) begin
        case (instr_code[6:0])

            // I-type instructions (lw, addi, andi, ori, slti, etc.)
            7'b0000011,           // Load
            7'b0010011: begin     // I-type ALU
                imm_out = {instr_code[31] ? {20{1'b1}} : 20'b0,instr_code[31:20]};
            end
            
            // S-type instructions (store)
            7'b0100011: begin
                imm_out = {instr_code[31] ? {20{1'b1}} : 20'b0,instr_code[31:25], instr_code[11:7]};
            end
            
            // U-type instructions (e.g., LUI / AUIPC)
            7'b0010111: begin
                imm_out = {instr_code[31:12], 12'b0};
            end
                
            // Default case for unsupported opcodes
            default: begin
                imm_out = 32'b0;
            end
                
        endcase
    end

endmodule // ImmGen

