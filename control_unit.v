module control_unit (
    input [5:0] opcode,
    input [5:0] funct,
    output reg reg_dst, branch, mem_read, mem_to_reg, 
    output reg [3:0] alu_op, 
    output reg mem_write, alu_src, reg_write
);
    always @(*) begin
        // Reset defaults
        reg_dst=0; branch=0; mem_read=0; mem_to_reg=0; 
        alu_op=0; mem_write=0; alu_src=0; reg_write=0;

        case (opcode)
            6'b000000: begin // R-Type
                reg_dst=1; reg_write=1;
                case(funct)
                    6'b100000: alu_op=4'b0010; // ADD
                    6'b100010: alu_op=4'b0110; // SUB
                    6'b100100: alu_op=4'b0000; // AND
                    6'b100101: alu_op=4'b0001; // OR
                    6'b101010: alu_op=4'b0111; // SLT
                endcase
            end
            6'b100011: begin // LW
                alu_src=1; mem_to_reg=1; reg_write=1; mem_read=1; alu_op=4'b0010;
            end
            6'b101011: begin // SW
                alu_src=1; mem_write=1; alu_op=4'b0010;
            end
            6'b000100: begin // BEQ
                branch=1; alu_op=4'b0110;
            end
            6'b001000: begin // ADDI
                alu_src=1; reg_write=1; alu_op=4'b0010;
            end
        endcase
    end
endmodule