
`timescale 1ns/1ps

//------------------------------------------------------------------------------
// Datapath
// Implements the complete single-cycle RISC-V datapath.
// This module interconnects all major functional blocks including:
// - Program Counter (PC)
// - Instruction fetch
// - Register file
// - ALU and immediate generation
// - Data memory
// - Write-back logic
//
// Control signals are provided externally by the Controller and ALUController.
//------------------------------------------------------------------------------
module Datapath #(
    /** Parameterized widths for flexibility **/
    parameter PC_W       = 8,    // Program Counter width
    parameter INSTR_W    = 32,   // Instruction width
    parameter DATA_W     = 32,   // Data width
    parameter DM_ADDR_W  = 9,    // Data memory address width
    parameter ALU_CC_W   = 4     // ALU control width
)(
	
    /** I/O Signals **/
    input                Clock,      // System clock
    input                Reset,      // Global reset
    input                Reg_Write,  // Register file write enable
    input                ALU_Src,    // ALU operand source select
    input [ALU_CC_W-1:0] ALU_CC,     // ALU control code
    input                Mem_Read,   // Data memory read enable
    input                Mem_Write,  // Data memory write enable
    input                Mem_to_Reg, // Write-back data select
        
    output        [2:0] Funct3,         // Instruction funct3 field
    output        [6:0] Funct7,         // Instruction funct7 field
    output        [6:0] Opcode,         // Instruction opcode
    output [DATA_W-1:0] Datapath_Result // ALU result (exposed for testing)
);

    /** Internal Datapath Signals **/
    wire [PC_W-1:0]    PC;              // Current program counter
    wire [PC_W-1:0]    PC_Next;         // Next program counter (PC + 4)
    wire [INSTR_W-1:0] Instruction;     // Fetched instruction
    wire [DATA_W-1:0]  Ext_Imm;         // Sign-extended immediate
    wire [DATA_W-1:0]  Reg1;            // Register rs1 data
    wire [DATA_W-1:0]  Reg2;            // Register rs2 data
    wire [DATA_W-1:0]  Src_B;           // Selected ALU second operand
    wire [DATA_W-1:0]  ALU_Result;      // Output of ALU
    wire [DATA_W-1:0]  DataMem_Read;    // Data read from memory
    wire [DATA_W-1:0]  Write_Back_Data; // Final data written to register file
    
    /** ALU **/
    ALU ALU_inst (
        .alu_sel(ALU_CC),
        .a_in(Reg1),
        .b_in(Src_B),
        .alu_out(ALU_Result),
        .carry_out(),
        .zero(),
        .overflow()
    );

    /** Data Memory **/
    DataMem DataMem_inst (
        .clk(Clock),
        .mem_read(Mem_Read),
        .mem_write(Mem_Write),
        .addr(ALU_Result[DM_ADDR_W-1:0]),
        .write_data(Reg2),
        .read_data(DataMem_Read)
    );
        
    /** Program Counter Register **/
    FlipFlop FlipFlop_inst (
        .clk(Clock),
        .reset(Reset),
        .d(PC_Next),
        .q(PC)
    );

    /** PC Increment Logic (PC + 4) **/
    HalfAdder HalfAdder_inst(
        .a(PC),
        .b(8'd4),
        .c_out(),
        .sum(PC_Next)
    );

    /** Immediate Generator **/
    ImmGen ImmGen_inst (
        .instr_code(Instruction),
        .imm_out(Ext_Imm)
    );
                
    /** Instruction Memory **/
    InstrMem InstrMem_inst (
        .addr(PC),
        .instr_out(Instruction)
    );

    /** ALU Operand Selection (Register vs Immediate) **/
    Mux2_1 Mux_EX (
        .s(ALU_Src),
        .d0(Reg2),
        .d1(Ext_Imm),
        .y(Src_B)
    ); 

    /** Write-Back Selection (ALU result vs Memory data) **/
    Mux2_1 Mux_WB (
        .s(Mem_to_Reg),
        .d0(ALU_Result),
        .d1(DataMem_Read),
        .y(Write_Back_Data)
    );    
        
    /** Register File **/
    RegFile RegFile_inst (
        .clk(Clock),     
        .reset(Reset),
        .rg_wrt_en(Reg_Write),
        .rg_wrt_addr(Instruction[11:7]),   // rd
        .rg_rd_addr1(Instruction[19:15]),  // rs1
        .rg_rd_addr2(Instruction[24:20]),  // rs2
        .rg_wrt_data(Write_Back_Data),
        .rg_rd_data1(Reg1),
        .rg_rd_data2(Reg2)
    );

    /** Expose Instruction Fields for Control Logic **/
    assign Datapath_Result = ALU_Result;
    assign Opcode          = Instruction[6:0];
    assign Funct3          = Instruction[14:12];
    assign Funct7          = Instruction[31:25];

endmodule // Datapath
