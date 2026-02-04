`timescale 1ns/1ps

//------------------------------------------------------------------------------
// Processor
// Top-level module that integrates the control path and datapath to form
// a complete single-cycle RISC-V processor.
//
// This module connects:
// - Main Controller
// - ALU Controller
// - Datapath
//------------------------------------------------------------------------------
module Processor(clock, reset, result);

    /** I/O Signals **/
    input         clock;   // System clock
    input         reset;   // Global reset
    output [31:0] result;  // Exposed ALU result (for verification)

    /** Internal Control Signals **/
    wire [1:0] alu_op;     // ALU operation category
    wire       alu_src;    // ALU operand source select
    wire [2:0] funct3;     // Instruction funct3
    wire [6:0] funct7;     // Instruction funct7
    wire       mem_read;   // Memory read enable
    wire       mem_to_reg; // Write-back select
    wire       mem_write;  // Memory write enable
    wire [6:0] opcode;     // Instruction opcode
    wire [3:0] operation; // Final ALU control signal
    wire       reg_write;  // Register write enable

    /** ALU Control Unit **/
    ALUController ALUController_inst(
        .ALU_Op(alu_op),
        .Funct3(funct3),
        .Funct7(funct7),
        .Operation(operation)
    );

    /** Main Control Unit **/
    Controller Controller_inst(
        .Opcode(opcode),
        .ALU_Op(alu_op),
        .Reg_Write(reg_write),
        .ALU_Src(alu_src),
        .Mem_Read(mem_read),
        .Mem_Write(mem_write),
        .Mem_to_Reg(mem_to_reg)
    );

    /** Datapath **/
    Datapath Datapath_inst(
        .Clock(clock),
        .Reset(reset),    
        .Reg_Write(reg_write),
        .Mem_to_Reg(mem_to_reg),
        .ALU_Src(alu_src),
        .Mem_Write(mem_write),
        .Mem_Read(mem_read),       
        .ALU_CC(operation),
        .Opcode(opcode),
        .Funct7(funct7),
        .Funct3(funct3),
        .Datapath_Result(result)
    );

endmodule // Processor

