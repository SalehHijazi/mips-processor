module inst_mem (
    input [31:0] pc,
    output [31:0] instruction
);
    reg [31:0] memory [0:255];

    initial begin
        // 1. addi $1, $0, 10  (0x2001000A)
        memory[0] = 32'h2001000A;
        // 2. addi $2, $0, 20  (0x20020014)
        memory[1] = 32'h20020014;
        // 3. add $3, $1, $2   (0x00221820) -> Result should be 30
        memory[2] = 32'h00221820;
        // 4. sw $3, 4($0)     (0xAC030004) -> Write 30 to Mem Addr 4
        memory[3] = 32'hAC030004;
        // 5. lw $4, 4($0)     (0x8C040004) -> Read 30 from Mem into $4
        memory[4] = 32'h8C040004;
        // 6. beq $1, $1, -1   (0x1021FFFF) -> Infinite Loop here
        memory[5] = 32'h1021FFFF;
    end

    assign instruction = memory[pc[9:2]];
endmodule