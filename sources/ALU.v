`timescale 1ns/1ps
//------------------------------------------------------------------------------
// ALU (Arithmetic Logic Unit)
// Performs all arithmetic and logical operations required by the RISC-V
// instruction set supported in this design.
//
// Operations supported:
// - ADD, SUB
// - AND, OR, NOR
// - SLT (Set Less Than)
// - SEQ (Set Equal, custom)
// Flags such as carry-out, overflow, and zero are generated for completeness.
//------------------------------------------------------------------------------
module ALU(alu_sel, a_in, b_in, carry_out, overflow, zero, alu_out);
    
    /** I/O Signals **/
    input  [3:0]  alu_sel;     // ALU control signal selecting the operation
    input  [31:0] a_in, b_in;  // ALU operands
    output reg    carry_out;   // Carry-out flag for addition
    output reg    overflow;    // Signed overflow flag
    output        zero;        // Zero flag (result equals zero)
    output [31:0] alu_out;     // ALU result output

    reg [31:0] alu_result;     // Internal register holding ALU computation
    reg [32:0] temp;           // Temporary register for carry detection
    reg [32:0] twos_com;       // Two's complement of b_in for subtraction
  
    // Drive outputs from internal ALU result
    assign alu_out = alu_result;
    assign zero    = (alu_result == 0);

    /** Module Behavior **/
    always @(*) begin
        // Clear flags by default
        overflow  = 1'b0;
        carry_out = 1'b0;
	  
        // Select ALU operation based on control signal
        case (alu_sel) 

            4'b0000: // AND operation
                alu_result = a_in & b_in;
    
            4'b0001: // OR operation
                alu_result = a_in | b_in;
    
            4'b0010: begin // ADD (signed)
                alu_result = $signed(a_in) + $signed(b_in);

                // Carry-out detection using extended addition
                temp      = {1'b0, a_in} + {1'b0, b_in};
                carry_out = temp[32];

                // Signed overflow detection
                if ((a_in[31] & b_in[31] & ~alu_out[31]) |
                    (~a_in[31] & ~b_in[31] & alu_out[31]))
                    overflow = 1'b1;
            end
    
            4'b0110: begin // SUB (signed)
                alu_result = $signed(a_in) - $signed(b_in);

                // Two's complement used for overflow detection
                twos_com = ~b_in + 1'b1;

                if ((a_in[31] & twos_com[31] & ~alu_out[31]) |
                    (~a_in[31] & ~twos_com[31] & alu_out[31]))
                    overflow = 1'b1;
            end
    
            4'b0111: // SLT: Set result to 1 if a_in < b_in (signed)
                alu_result = ($signed(a_in) < $signed(b_in)) ? 32'd1 : 32'd0;
    
            4'b1100: // NOR operation
                alu_result = ~(a_in | b_in);
    
            4'b1111: // SEQ: Set result to 1 if operands are equal
                alu_result = (a_in == b_in) ? 32'd1 : 32'd0;
    
            default: // Default operation (safe fallback)
                alu_result = a_in + b_in;
          
        endcase
    end

endmodule // ALU
