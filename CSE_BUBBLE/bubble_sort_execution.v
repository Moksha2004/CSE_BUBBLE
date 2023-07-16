//Assignment-7
//Team Members: Kruthi Akkinepally (210088)
//              Mokshagna Prattipati (210761)


module Decode_Instruction(clk,out);
input clk;
reg [9:0] pc;
reg [5:0] Opcode;
reg [5:0] Funct;
reg [4:0] rs;
reg [4:0] rd;
reg [4:0] rt;
reg [15:0] addr_const;
reg [4:0] Shamt;
reg [25:0] jump_inst;
integer i;
reg [31:0] Curr_Instruction;
reg [31:0] stor_ie [31:0];
reg [31:0] veda_Memor_iy [1023:0];
wire [31:0] c_sum;
wire [31:0] c_sub;
wire [31:0] c_and_i;
wire [31:0] c_or_i;
wire [31:0] c_sll;
wire [31:0] c_srl;
initial begin
    veda_Memor_iy[0] = 32'd12; 
    veda_Memor_iy[1] = 32'd44; 
    veda_Memor_iy[2] = 32'd60; 
    veda_Memor_iy[3] = 32'd30;
    veda_Memor_iy[4] = 32'd32;
    veda_Memor_iy[5] = 32'd10;
    veda_Memor_iy[6] = 32'd14;
    veda_Memor_iy[7] =32'd27;
    veda_Memor_iy[8] =32'd9;
    veda_Memor_iy[9] =32'd19;
    veda_Memor_iy[10] = {6'b000000,5'd0,5'd0,5'd1,5'd0,6'b100000};//s0=0
    veda_Memor_iy[11] = {6'b000000,5'd0,5'd0,5'd2,5'd0,6'b100000};//s1=0
    veda_Memor_iy[12] = {6'b000000,5'd0,5'd0,5'd7,5'd0,6'b100000};
    veda_Memor_iy[13] = {6'b001000,5'd7,5'd7,16'd9};//s6=9
    veda_Memor_iy[14] = {6'b000000,5'd2,5'd8,5'd16,5'd0,6'b100000};//add t7,s7,s1 //loop start
    veda_Memor_iy[15] = {6'b100011,5'd16,5'd9,16'd0};//lw t0,0(t7)
    veda_Memor_iy[16] = {6'b100011,5'd16,5'd10,16'd1};//lw t1,1(t7)
    veda_Memor_iy[17] = {6'b000000,5'd9,5'd10,5'd11,5'd0,6'b101010};//slt t2,t0,t1
    veda_Memor_iy[18] = {6'b000101,5'd0,5'd11,16'd21};//bne t2,zero,increment //kkkkkllllllllllll
    veda_Memor_iy[19] = {6'b101011,5'd16,5'd10,16'd0};//sw t1,0(t7)
    veda_Memor_iy[20] = {6'b101011,5'd16,5'd9,16'd1};// sw t0,1(t7)
    veda_Memor_iy[21] = {6'b001000,5'd2,5'd2,16'd1};//increment start , addi s1,s1,1
    veda_Memor_iy[22] = {6'b000000,5'd7,5'd1,5'd6,5'd0,6'b100010};//sub s5,s6,s0
    veda_Memor_iy[23] = {6'b000101,5'd2,5'd6,16'd14};// bne s1,s5,loop
    veda_Memor_iy[24] = {6'b001000,5'd1,5'd1,16'd1};// addi s0,s0,1
    veda_Memor_iy[25] = {6'b000000,5'd0,5'd0,5'd2,5'd0,6'b100000};// reset s1=0
    veda_Memor_iy[26] = {6'b000101,5'd1,5'd7,16'd14};// bne s0,s6,loop
    veda_Memor_iy[27] = {6'b111111,26'd0};//print
end 

initial begin
    pc = 10;
    stor_ie[0] = 32'd0; //zero_regester
    stor_ie[1] = 32'd5; //s0
    stor_ie[2] = 32'd0; //s1
    stor_ie[3] = 32'd7; //s2
    stor_ie[4] = 32'd0; //s3
    stor_ie[5] = 32'd10;//s4
    stor_ie[6] = 32'd0;//s5
    stor_ie[7] = 32'd5;//s6
    stor_ie[8] = 32'd0;//s7  as adress of the first element of the array is 0 in vedamemor_iy;
    stor_ie[9] = 32'd0;//t0
    stor_ie[10] = 32'd0;//t1
    stor_ie[11] = 32'd0;//t2
    stor_ie[12] = 32'd0;//t3
    stor_ie[13] = 32'd0;//t4
    stor_ie[14] = 32'd0;//t5
    stor_ie[15] = 32'd0;//t6
    stor_ie[16] = 32'd0;//t7
    stor_ie[17] = 32'd0;
    stor_ie[18] = 32'd0;
    stor_ie[19] = 32'd0;
    stor_ie[20] = 32'd0;
end

output reg [31:0] out;

addition v1(stor_ie[rs],stor_ie[rt],c_sum);
subtraction v2(stor_ie[rs],stor_ie[rt],c_sub);
and_i v3(stor_ie[rs],stor_ie[rt],c_and_i);
or_i v4(stor_ie[rs],stor_ie[rt],c_or_i);
sll v5(stor_ie[rt],Shamt,c_sll);
srl v6(stor_ie[rt],Shamt,c_srl);


always @(posedge clk)
begin
    Curr_Instruction = veda_Memor_iy[pc];
    Opcode =  Curr_Instruction[31:26];
    Funct = Curr_Instruction[5:0];
    rs = Curr_Instruction[25:21];
    rt = Curr_Instruction[20:16];
    rd = Curr_Instruction[15:11];
    addr_const =  Curr_Instruction[15:0];
    Shamt = Curr_Instruction[10:6];
    jump_inst = Curr_Instruction[25:0];
    case(Opcode)
        6'b000000: case(Funct)

                     6'b100000: begin
                                stor_ie[rd] = c_sum;
                                out = c_sum;
                                pc = pc + 1;
                                end

                    6'b100010: begin
                               stor_ie[rd] = c_sub;
                               out = c_sub;
                               pc = pc + 1;
                               end

                    6'b100001: begin
    
                                stor_ie[rd] = c_sum;
                                pc = pc + 1;
                                end

                    6'b100011: begin
                               stor_ie[rd] = c_sub;
                               pc = pc + 1;
                               end

                    6'b100100: begin
                               stor_ie[rd] = c_and_i;
                               pc = pc + 1;
                               out = c_and_i;

                               end

                    6'b100101: begin
                               stor_ie[rd] = c_or_i;
                               pc = pc + 1;
                               end

                    6'b000000: begin
                               stor_ie[rd] = c_sll;
                               pc = pc + 1;
                               end

                    6'b000010: begin
                               stor_ie[rd] = c_srl;
                               pc = pc + 1;
                               end

                    6'b001000: pc = stor_ie[rs];

                    6'b101010: begin
                               if(stor_ie[rs] < stor_ie[rt]) begin
                                stor_ie[rd] = 32'd1;
                               end
                               else begin
                                stor_ie[rd] = 32'd0;
                               end
                               pc = pc + 1;

                               end
                   endcase
        6'b001000 :     begin
                       
                        stor_ie[rt] = stor_ie[rs] + addr_const[15:0];
                        pc = pc + 1;
                        end
        6'b001001 :     begin  
                        stor_ie[rt] = stor_ie[rs] + addr_const[15:0];
                        pc = pc + 1;
                        end
        6'b001100 :     begin
                        stor_ie[rt] = stor_ie[rs] & addr_const[15:0];
                        pc = pc + 1;
                        end
        6'b001101 :     begin
                        stor_ie[rt] = stor_ie[rs] | addr_const[15:0];
                        pc = pc + 1;
                        end
        6'b100011 :     begin
                        stor_ie[rt] = veda_Memor_iy[stor_ie[rs] +  addr_const];
                        out = stor_ie[rt];
                        pc = pc + 1;
                        end
        6'b101011 :     begin
                        veda_Memor_iy[stor_ie[rs] +  addr_const] = stor_ie[rt];
                        pc = pc + 1;
                        end
        6'b000100 :     if(stor_ie[rt] == stor_ie[rs]) begin
                        pc = pc + 1 + addr_const[5:0]; 
                        end
        6'b000101 :     begin
                        if(stor_ie[rt] != stor_ie[rs]) begin
                            pc = addr_const[9:0];
                        end
                        else begin
                            pc = pc + 1;
                        end
                        end
        6'b000111 :     begin
                        if(stor_ie[rs] > stor_ie[rt]) pc = pc + 1 + addr_const[9:0];
                        end

        6'b001111 :     begin
                        if(stor_ie[rs] >= stor_ie[rt]) pc = pc + 1 + addr_const[9:0];
                        end

        6'b000110 :     begin
                        if(stor_ie[rs] < stor_ie[rt]) pc = pc + 1 + addr_const[9:0];
                        end

        6'b011111 :     begin
                        if(stor_ie[rs] <= stor_ie[rt]) pc = pc + 1 + addr_const[9:0];
                        end


        6'b000010 :     pc = jump_inst[9:0];

        6'b000011 :     begin  
                        stor_ie[5'b11111] = pc + 1;
                        pc = jump_inst[9:0];
                        end

        6'b001010 :     begin
                        if(stor_ie[rt] < addr_const) stor_ie[rs] = 1;
                        else stor_ie[rs] = 0;
                        pc = pc + 1;
                        end

        6'b111111 : begin
                    $display("%d",veda_Memor_iy[0]);
                    $display("%d",veda_Memor_iy[1]);
                    $display("%d",veda_Memor_iy[2]);
                    $display("%d",veda_Memor_iy[3]);
                    $display("%d",veda_Memor_iy[4]);
                    $display("%d",veda_Memor_iy[5]);
                    $display("%d",veda_Memor_iy[6]);
                    $display("%d",veda_Memor_iy[7]);
                    $display("%d",veda_Memor_iy[8]);
                    $display("%d",veda_Memor_iy[9]);
                    end
    endcase

end



endmodule

module addition(a,b,c);
input [31:0] a,b;
output [31:0] c;
assign c = a + b;
endmodule

module subtraction(a,b,c);
input [31:0] a,b;
output [31:0] c;
assign c = a - b;
endmodule


module and_i(a,b,c);
input [31:0] a,b;
output [31:0] c;
assign c = a & b;
endmodule

module or_i(a,b,c);
input [31:0] a,b;
output [31:0] c;
assign c = a | b;
endmodule

module sll(a,b,c);
input [31:0] a;
output [31:0]c;
input [4:0] b;
assign c = a >> b;
endmodule

module srl(a,b,c);
input [31:0] a;
input [4:0] b;
output [31:0]c;
assign c = a << b;
endmodule

module tb;
reg clk;
wire [31:0] out;
Decode_Instruction uut (clk,out);
initial begin
clk = 0;
forever #10 clk = ~clk;
end
initial begin
#10
//$monitor_i("output= %d", out);
#9039 $finish;
end
endmodule









