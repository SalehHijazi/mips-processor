`timescale 1ns/1ns

module inst_mem_tb;
    reg [31:0] pc;
    wire [31:0] instruction;

    // Connect the Memory
    inst_mem uut (
        .pc(pc),
        .instruction(instruction)
    );

    initial begin
        $dumpfile("inst_mem_test.vcd");
        $dumpvars(0, inst_mem_tb);

        // Test 1: Fetch Address 0 (Should be add $1, $0, $0)
        pc = 32'd0;
        #10;

        // Test 2: Fetch Address 4 (Should be addi $1, $0, 10)
        pc = 32'd4;
        #10;

        // Test 3: Fetch Address 8 (Should be addi $2, $0, 20)
        pc = 32'd8;
        #10;
        
        // Test 4: Fetch Address 12 (Should be add $3, $1, $2)
        pc = 32'd12;
        #10;

        $finish;
    end
endmodule