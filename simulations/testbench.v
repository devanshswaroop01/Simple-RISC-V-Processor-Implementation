//------------------------------------------------------------------------------
// Testbench for Single-Cycle RISC-V Processor
// This testbench verifies the correct functional execution of a fixed
// instruction sequence stored in Instruction Memory.
// It compares the ALU result after each instruction against
// precomputed expected values and reports pass/fail status.
//------------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_Processor;

    // ---------------- SIGNAL DECLARATIONS ----------------
    reg clk;                 // Clock signal
    reg rst;                 // Reset signal

    wire [31:0] result_tb;   // Output result from Processor (ALU result)

    integer point;           // Counter for passed test cases
    integer i;               // Loop variable for instruction index

    // ---------------- DEVICE UNDER TEST (DUT) ----------------
    // Instantiates the top-level Processor module
    Processor dut (
        .clock(clk),
        .reset(rst),
        .result(result_tb)
    );

    // ---------------- CLOCK GENERATION ----------------
    // Generates a 20ns clock period (50 MHz)
    always #10 clk = ~clk;

    // ---------------- EXPECTED RESULTS ----------------
    // Expected ALU results for each instruction in Instruction Memory
    // These values are derived from manual instruction execution
    reg [31:0] expected [0:19];

    initial begin
        expected[0]  = 32'h00000000;
        expected[1]  = 32'h00000001;
        expected[2]  = 32'h00000002;
        expected[3]  = 32'h00000004;
        expected[4]  = 32'h00000005;
        expected[5]  = 32'h00000007;
        expected[6]  = 32'h00000008;
        expected[7]  = 32'h0000000b;
        expected[8]  = 32'h00000003;
        expected[9]  = 32'hfffffffe;
        expected[10] = 32'h00000000;
        expected[11] = 32'h00000005;
        expected[12] = 32'h00000001;
        expected[13] = 32'hfffffff4;
        expected[14] = 32'h000004d2;
        expected[15] = 32'hfffff8d7;
        expected[16] = 32'h00000001;
        expected[17] = 32'hfffffb2c;
        expected[18] = 32'h00000030;
        expected[19] = 32'h00000030;
    end

    // ---------------- TEST SEQUENCE ----------------
    initial begin
        // Initialize signals
        clk   = 0;
        rst   = 1;
        point = 0;

        // Apply reset for a clean processor start
        #25;
        rst = 0;

        // Execute each instruction and verify output
        for (i = 0; i < 20; i = i + 1) begin
            @(posedge clk);   // Instruction completes in one clock cycle
            #1;               // Small delay for signal stabilization

            // Compare actual result with expected value
            if (result_tb === expected[i+1]) begin
                point = point + 1;
            end else begin
                $display(
                    "FAIL @ instr %0d : expected=%h got=%h",
                    i, expected[i], result_tb
                );
            end
        end

        // ---------------- SUMMARY ----------------
        $display("=================================");
        $display("Passed %0d / 20 test cases", point);
        $display("=================================");

        $finish;
    end

    // ---------------- WAVEFORM DUMP ----------------
    // Enables waveform viewing for debugging and analysis
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_Processor);
    end

endmodule
 
