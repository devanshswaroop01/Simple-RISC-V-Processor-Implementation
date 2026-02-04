`timescale 1ns / 1ps
//------------------------------------------------------------------------------
// InstrMem
// Read-only instruction memory storing the program instructions.
// Instructions are indexed using the Program Counter (PC).
//------------------------------------------------------------------------------
module InstrMem(addr, instr_out);

    /** I/O Signals **/
    input  [7:0]  addr;       // Program Counter value
    output wire [31:0] instr_out; // Fetched instruction

    reg [31:0] memory [0:63]; // Instruction memory array

    /** Instruction Codes **/
    // Preloaded test program covering R-type, I-type, load, and store
    initial begin
        memory[0]  = 32'b00000000000000000111000000110011; // and  x0,  x0, x0
        memory[1]  = 32'b00000000000100000000000010010011; // addi x1,  x0, 1
        memory[2]  = 32'b00000000001000000000000100010011; // addi x2,  x0, 2
        memory[3]  = 32'b00000000001100001000000110010011; // addi x3,  x1, 3
        memory[4]  = 32'b00000000010000001000001000010011; // addi x4,  x1, 4
        memory[5]  = 32'b00000000010100010000001010010011; // addi x5,  x2, 5
        memory[6]  = 32'b00000000011000010000001100010011; // addi x6,  x2, 6
        memory[7]  = 32'b00000000011100011000001110010011; // addi x7,  x3, 7
        memory[8]  = 32'b00000000001000001000010000110011; // add  x8,  x1, x2
        memory[9]  = 32'b01000000010001000000010010110011; // sub  x9,  x8, x4
        memory[10] = 32'b00000000001100010111010100110011; // and  x10, x2, x3
        memory[11] = 32'b00000000010000011110010110110011; // or   x11, x3, x4
        memory[12] = 32'b00000000010000011010011000110011; // slt  x12, x3, x4
        memory[13] = 32'b00000000011100110100011010110011; // nor  x13, x6, x7
        memory[14] = 32'b01001101001101001111011100010011; // andi x14, x9, imm
        memory[15] = 32'b10001101001101011110011110010011; // ori  x15, x11, imm
        memory[16] = 32'b01001101001001101010100000010011; // slti x16, x13, imm
        memory[17] = 32'b01001101001001000100100010010011; // nori x17, x8, imm
        memory[18] = 32'b00000010101100000010100000100011; // sw   x11, 48(x0)
        memory[19] = 32'b00000011000000000010011000000011; // lw   x12, 48(x0)
    end

    // Word-aligned instruction fetch (PC[1:0] ignored)
    assign instr_out = memory[addr[7:2]];

endmodule // InstrMem
 
