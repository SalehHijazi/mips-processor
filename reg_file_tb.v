`timescale 1ns/1ns

module reg_file_tb;
    reg clk, reg_write_en;
    reg [4:0] read_reg1, read_reg2, write_reg;
    reg [31:0] write_data;
    wire [31:0] read_data1, read_data2;

    reg_file uut (
        .clk(clk), .reg_write_en(reg_write_en),
        .read_reg1(read_reg1), .read_reg2(read_reg2),
        .write_reg(write_reg), .write_data(write_data),
        .read_data1(read_data1), .read_data2(read_data2)
    );

    // Clock generation (Oscillates every 5ns)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("reg_file_test.vcd");
        $dumpvars(0, reg_file_tb);
        
        // Initialize
        clk = 0; reg_write_en = 0;
        read_reg1 = 0; read_reg2 = 0; write_reg = 0; write_data = 0;
        #10;

        // Test 1: Write Value 42 into Register $1
        write_reg = 5'd1; write_data = 32'd42; reg_write_en = 1;
        #10; // Wait for clock edge
        reg_write_en = 0; // Turn off write

        // Test 2: Read Register $1 (Should be 42)
        read_reg1 = 5'd1;
        #10;

        // Test 3: Try to write to Register $0 (Should fail/stay 0)
        write_reg = 5'd0; write_data = 32'd99; reg_write_en = 1;
        #10;
        reg_write_en = 0;

        // Test 4: Read Register $0 (Should be 0)
        read_reg1 = 5'd0;
        #10;

        $finish;
    end
endmodule