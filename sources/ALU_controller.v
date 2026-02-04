
`timescale 1ns/1ps
//------------------------------------------------------------------------------
// ALUController
// Generates the final ALU control signals based on:
// 1) High-level ALU operation (ALU_Op) from the main controller
// 2) Instruction-specific fields (Funct3 and Funct7)
//
// This module ensures correct ALU operation selection for:
// - R-type instructions
// - I-type ALU instructions
// - Load/Store address calculations
//------------------------------------------------------------------------------
module ALUController (
    input  [1:0] ALU_Op,     // High-level ALU operation code from Controller
    input  [2:0] Funct3,     // Instruction funct3 field
    input  [6:0] Funct7,     // Instruction funct7 field
    output reg [3:0] Operation // Final ALU control signal
);

    always @(*) begin
        // Default operation set to ADD (safe fallback)
        Operation = 4'b0010;

        case (ALU_Op)

            // --------------------------------------------------
            // I-type ALU instructions (addi, andi, ori, slti, nori)
            // --------------------------------------------------
            2'b00: begin
                case (Funct3)
                    3'b000: Operation = 4'b0010; // ADDI
                    3'b111: Operation = 4'b0000; // ANDI
                    3'b110: Operation = 4'b0001; // ORI
                    3'b010: Operation = 4'b0111; // SLTI
                    3'b100: Operation = 4'b1100; // NORI (custom)
                    default: Operation = 4'b0010;
                endcase
            end

            // --------------------------------------------------
            // Load / Store instructions
            // ALU used only for address calculation (base + offset)
            // --------------------------------------------------
            2'b01: begin
                Operation = 4'b0010; // ADD
            end

            // --------------------------------------------------
            // R-type instructions
            // Decode using funct3 and funct7 fields
            // --------------------------------------------------
            2'b10: begin
                case (Funct3)

                    // ADD / SUB selection based on funct7
                    3'b000: begin
                        if (Funct7[5])
                            Operation = 4'b0110; // SUB
                        else
                            Operation = 4'b0010; // ADD
                    end

                    3'b111: Operation = 4'b0000; // AND
                    3'b110: Operation = 4'b0001; // OR
                    3'b010: Operation = 4'b0111; // SLT
                    3'b100: Operation = 4'b1100; // NOR
                    default: Operation = 4'b0010;
                endcase
            end
        endcase
    end

endmodule // ALUController
