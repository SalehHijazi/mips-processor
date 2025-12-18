`timescale 1ns/1ns

module alu_tb;
    reg  [31:0] a, b;
    reg  [3:0]  alu_ctrl;
    wire [31:0] result;
    wire zero;

    // Connect the ALU
    alu uut (
        .a(a), .b(b), .alu_ctrl(alu_ctrl), .result(result), .zero(zero)
    );

    initial begin
        // Setup waveform file
        $dumpfile("alu_test.vcd");
        $dumpvars(0, alu_tb);

        // Test 1: ADD (10 + 20)
        a = 32'd10; b = 32'd20; alu_ctrl = 4'b0010;
        #10;
        
        // Test 2: SUB (50 - 20)
        a = 32'd50; b = 32'd20; alu_ctrl = 4'b0110;
        #10;

        // Test 3: Zero Flag (10 - 10)
        a = 32'd10; b = 32'd10; alu_ctrl = 4'b0110;
        #10;

        $finish;
    end
endmodule