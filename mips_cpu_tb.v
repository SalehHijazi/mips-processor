`timescale 1ns/1ns

module mips_cpu_tb;
    reg clk;
    reg reset;
    wire [31:0] pc_out;
    wire [31:0] alu_result;

    mips_cpu uut (
        .clk(clk), .reset(reset),
        .pc_out(pc_out), .alu_result(alu_result)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("mips_cpu_test.vcd");
        $dumpvars(0, mips_cpu_tb);
        
        clk = 0; reset = 1;
        #10;
        reset = 0;
        
        // Run long enough for the program to finish
        #200;
        $finish;
    end
endmodule