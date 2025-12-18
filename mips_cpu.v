module mips_cpu (
    input clk,
    input reset,
    output [31:0] pc_out,
    output [31:0] alu_result
);
    reg [31:0] pc;
    wire [31:0] pc_next, pc_plus4, pc_branch, instruction, sign_ext_imm;
    wire [31:0] read_data1, read_data2, src_b, result, mem_read_data, write_back_data;
    wire [4:0]  write_reg;
    wire reg_dst, branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write, zero;
    wire [3:0] alu_op;

    // PC Logic
    always @(posedge clk or posedge reset) begin
        if (reset) pc <= 0;
        else pc <= pc_next;
    end

    assign pc_plus4 = pc + 4;
    assign sign_ext_imm = {{16{instruction[15]}}, instruction[15:0]};
    assign pc_branch = pc_plus4 + (sign_ext_imm << 2);
    assign pc_next = (branch & zero) ? pc_branch : pc_plus4;

    // Instances
    inst_mem imem (.pc(pc), .instruction(instruction));

    control_unit ctrl (
        .opcode(instruction[31:26]), .funct(instruction[5:0]),
        .reg_dst(reg_dst), .branch(branch), .mem_read(mem_read),
        .mem_to_reg(mem_to_reg), .alu_op(alu_op), .mem_write(mem_write),
        .alu_src(alu_src), .reg_write(reg_write)
    );

    assign write_reg = (reg_dst) ? instruction[15:11] : instruction[20:16];

    reg_file rf (
        .clk(clk), .reg_write_en(reg_write),
        .read_reg1(instruction[25:21]), .read_reg2(instruction[20:16]),
        .write_reg(write_reg), .write_data(write_back_data),
        .read_data1(read_data1), .read_data2(read_data2)
    );

    assign src_b = (alu_src) ? sign_ext_imm : read_data2;

    alu main_alu (
        .a(read_data1), .b(src_b), .alu_ctrl(alu_op),
        .result(result), .zero(zero)
    );

    data_mem dmem (
        .clk(clk), .mem_write(mem_write), .mem_read(mem_read),
        .address(result), .write_data(read_data2), .read_data(mem_read_data)
    );

    assign write_back_data = (mem_to_reg) ? mem_read_data : result;
    
    // Debug Output
    assign pc_out = pc;
    assign alu_result = result;
endmodule