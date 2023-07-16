//Assignment-7
//Team Members: Kruthi Akkinepally (210088)
//              Mokshagna Prattipati (210761)



module Instruction_fetch(clk,out,pc_final);
input clk;
input [31:0] instruction;
reg [5:0] opcode,opcode1;
reg [4:0] rs,rt,rd,shamt,rs1,rt1,rd1,shamt1;
reg [5:0] funct,funct1;
reg [4:0] pc=5'd0,pc_alu,pc_alu1,address1;
wire [4:0]pc_star,pc_star1;
reg clk_v,rst_v,write_enable_v,mode;
reg [4:0] addr_v;
reg [31:0] data_in;
wire [31:0] data_out; 
reg [31:0] instruction_memory [25:0];
reg [31:0] data_memory[6:0];
reg [31:0] fetch_instruction;
output reg [31:0]out;
output reg [4:0] pc_final;
integer i;
wire [31:0] out1,out2;
reg [31:0]fetch_instruction_alu;
reg [1:0] state;
reg rtype,jtype,itype;
reg [15:0] immediatei,immediatei1;wire [31:0] result;wire [4:0]pc_out;
reg [25:0] immediatej,immediatej1;
always @(posedge clk) begin
    
    rst_v<=1'd0;
    write_enable_v<=1'd1;
    data_in<=instruction;
    fetch_instruction<=data_out;
    addr_v<=pc;
    mode<=1'd0;
    rs1<=rs;
  rt1<=rt;
  rd1<=rd;
  shamt1<=shamt;
  funct1<=funct;
  immediatei1<=immediatei;
  immediatej1<=immediatej;
  address1<=pc;
  opcode1<=opcode;
end
veda v1 (clk,rst_v,write_enable_v,addr_v,data_in,mode,data_out);
// always @(posedge clk) begin
//     $display("%b kruti",data_out);
//     //pc<=pc+1;
// end
// always @(posedge clk) begin
// fetch_instruction_alu<=fetch_instruction;
// pc_alu<=pc;
// pc_alu1<=pc;
// out<=out1;
// addr_v<=pc_star;
// pc_final<=pc_star;
// // pc<=pc_final;
// end
// ALU a1 (fetch_instruction_alu,pc_alu,out1,pc_star);
// always @(posedge clk) begin
//   $display("%b %b moksha",addr_v,pc_final);
    //pc<=pc+1;
    // fetch_instruction_alu<=instruction_memory[pc_final];
    // out<=out1;
//end   

ALU g1(clk,rs1,rt1,rd1,shamt1,funct1,immediatei1,immediatej1,address1,opcode1,result,pc_out);
always @(posedge clk)begin
opcode=fetch_instruction[31:26];
state<=1;
if(state==1) begin
  $display("%b instr",fetch_instruction);
  if(opcode<6'd10)begin
            rtype=1'd1; 
            jtype=1'd0;
            itype=1'd0;
            rs <= fetch_instruction[25:21];
            rt <= fetch_instruction[20:16];
            rd <= fetch_instruction[15:11];
            shamt <= fetch_instruction[10:6];
            funct <= fetch_instruction[5:0];
            state<=2;
  end
  else if(opcode<17)begin 
            rtype=1'd0; 
            jtype=1'd0;
            itype=1'd1;
            rs <= fetch_instruction[25:21];
            rt <= fetch_instruction[20:16];
            immediatei<=fetch_instruction[15:0];
            state<=2;
    
  end
  else begin
            rtype=1'd0; 
            jtype=1'd1;
            itype=1'd0; 
            immediatej<=fetch_instruction[25:0];
            state<=2;
  end
end
if(state==2) begin
  if(rtype==1)begin 
    $display("%d rs %d rt\n",rs,rt);
     out<=result;pc<=pc+1;pc_final<=pc+1; end
  else if(jtype==1) begin
    out<=result;
    pc<=pc+1;
    //pc<=result;
    //pc_final<=pc_out;
  end
  else begin
    out<=result;
  pc<=pc+1;
 //pc_final<=pc+1;
  end
end    
end

//ALU a2(instruction_memory[pc_final],pc_alu1,out2,pc_star1);
//ALU a3 (instruction_memory[pc_final],pc_alu,out1,pc_star);
// always @(posedge clk) begin
//     $display("%b %b ",pc_alu,pc_final);
// end
endmodule
module ALU(clk,rs,rt,rd,shamt,funct,immediatei,immediatej,address,opcode,result,pc_out);
input clk;
input [4:0] rs,rt,rd,shamt,address;
input [5:0] opcode,funct;
input [15:0] immediatei;
input [25:0] immediatej;
output reg [31:0]result;
output reg [4:0] pc_out;
reg [31:0]u[31:0];
wire [32:0]sum;
wire [31:0]diff;
integer i;
initial begin
    for(i=0;i<32;i=i+1) begin
        u[i]=i+1;
    end
 end
bit_adder b1 (u[rs],u[rt],sum);
full_Subtractor b2(u[rs],u[rt],diff);
always @(posedge clk) begin
  case(opcode) 
  6'd0:
  if(funct==6'd32) begin
       result <= sum;//addu
      end 
      else if(funct==6'd34) begin
          result <= diff;//subu
      end
    else if(funct==6'd30) begin
         u[rs]<=$signed(u[rs]);
         u[rt]<=$signed(u[rt]);
         #10
         result=sum;
      end
      6'd1|6'd2: result <= u[rs]&u[rt];// and,andi
      6'd3|6'd4: result <=  u[rs]|u[rt];//  or,ori
      6'd5|6'd6: result <=  u[rs]^u[rt];//  xor,xori
      6'd7: result <=  u[rs]<<u[rt];// shift left
      6'd8: result <=  u[rs]>>u[rt];// shift right 
      6'd9: result <= ($signed(u[rs]))< $signed(u[rt])? 1 : 0; //slt
      6'd10:begin 
        result<=0;
         if(u[rs]==u[rt]) begin 
          pc_out<= address + 5'd1+immediatei;
          result=1;
         end 
         end
      6'd11:begin if(u[rs]!=u[rt]) begin 
      pc_out<=address+5'd1+immediatej;
      result=0;
      end end
      6'd17:begin  
        pc_out=immediatej;
      end
      6'd15:begin
        result<=u[rs]+immediatei[4:0];
      end
      default: begin result = 0; pc_out=0; end
  endcase
  end
endmodule
module veda(clk,rst,wrt_enb,add,data_in,mode,data_out);
    input clk,rst,wrt_enb,mode;
    input [31:0]data_in;
    input [4:0]add;
    output reg [31:0]data_out;
    reg [31:0] data;
    reg [31:0] instruction_memory [31:0];
    integer i;
    initial begin
    for(i=0;i<32;i=i+1) begin
instruction_memory[0] <= 32'b001111_00100_00000_00000_00000_000011;// beq 0
    instruction_memory[1] <= 32'd34;//{16'b0001000000000001,16'd10}; // 
    instruction_memory[2] <= 32'b00101000001000100000000000000100; // 
    instruction_memory[3] <= 32'b00000000001000100000000000100100;
    instruction_memory[4] <= 32'b00000000001000100000000000000110;
    instruction_memory[5] <= 32'b00000000001000100000000000100100;
    instruction_memory[6] <= 32'b00100000001000000000001111101000;
    instruction_memory[7] <= 32'b00101100001000000000001111101000;
    instruction_memory[8] <= 32'b00000000001000100000000000100100;
    instruction_memory[9] <= 32'b00000000001000100000000000100100;
    // instruction_memory[10] <= 32'b00000000000000010000001010000000;
    // instruction_memory[11] <= 32'b00000000000000010000001010000010;
    // instruction_memory[12] <= 32'b10001100001000000000000000001010;
    // instruction_memory[13] <= 32'b10101100001000000000000000001010;
    // instruction_memory[14] <= 32'b00010000000000010000000000001010;
    // instruction_memory[15] <= 32'b00010100000000010000000000001010;
    // instruction_memory[16] <= 32'b00011100001000100000000000001010;
    // instruction_memory[17] <= 32'b00111100001000100000000000001010;
    // instruction_memory[18] <= 32'b00011000001000100000000000001010;
    // instruction_memory[19] <= 32'b01111100001000100000000000001010;
    // instruction_memory[20] <= 32'b00001000000000000000000000000010;
    // instruction_memory[21] <= 32'b00000000000000000000000000001000;
    // instruction_memory[22] <= 32'b00001100000000000000000000001010;
    // instruction_memory[23] <= 32'b00000000001000100000000000101010;
    // instruction_memory[24] <= 32'b00101000010000010000000001100100;    
    end
end
    always @(posedge clk )
     begin if(wrt_enb) begin
        if(!mode)
         begin
        //     $display("kruthi data_out=%b",data_out);
             data_out = instruction_memory[add];
          // memory[add]=data_in;
           
        end 
        else 
         begin
            //  data_out = data_in; 
            //  memory[add] = data_in;
            //  data=data_in;
            data= instruction_memory[add];
            data_out=data;
          //   $display("kruthi data_out=%b",data_out);
        end
                   
     end
    
   //  $display("kruthi data_out=%b",data_out);
     end
 endmodule
// module ALU(instruction,pc_alu,out,pc_star);

// input [31:0] instruction;
// input [4:0]pc_alu;
// output reg [4:0]pc_star;
// output reg [31:0] out;
// reg [5:0] opcode;
// reg [5:0] funct;
// reg [4:0] rs,rt,rd;
// reg [31:0]u[31:0];
// wire [32:0] sum;
// wire [31:0] diff;
// reg [25:0] address;
// integer i;
// initial begin
//     for(i=0;i<32;i=i+1) begin
//         u[i]=i;
//     end
// end 
//    bit_adder b1 (u[rs],u[rt],sum);
//  full_Subtractor b2(u[rs],u[rt],diff);
// always @* begin
//     opcode<=instruction[31:26];
//     address<=instruction[25:0];
//     funct<=instruction[5:0];
//     rs<=instruction[25:21];
//     rt<=instruction[20:16];
// //$display("%b",opcode);
//     if(opcode==6'd32 &&funct==6'd0) begin //add unsigned
//         out<=sum;
//       // $display("%b",u[rs]);
//     end 
//     if(opcode==6'd34 &&funct==6'd0) begin //sub unsigned
//         out<=diff;
//       // $display("%b",u[rs]);
//     end
//     if(opcode==6'd35 &&funct==6'd0) begin
//         out<=u[rs]&u[rt]; //and i or and
//       // $display("%b",u[rs]);
//     end
//     if(opcode==6'd38 &&funct==6'd0) begin
//         out<=u[rs]|u[rt]; //ori or or
       
//       // $display("%b",u[rs]);
//     end
//     if(opcode==6'd16) begin
        
//         pc_star<=pc_alu+address;
//     end
    
// end
// endmodule
//  module tb;
// reg clk;
// reg [31:0] instruction;
// wire [31:0]out;
// Instruction_fetch uut(.clk(clk),.instruction(instruction),.out(out));
// always #10 clk=~clk;
// initial begin
//     clk=1;
//    instruction=32'b010000_01001_00010_00000_00000_001011;
//     // instruction=32'd15;
//   #500 $display("%b",out);
// #1000 $finish;
// end

// endmodule
module bit_adder(a,b,s);
input [31:0] a,b;
//reg [31:0] b;
// wire [31:0] a;
// wire [31:0] b;
//wire c_in;
output [32:0] s;
wire [31:0]c_out;
//assign c_in=1'b0;
genvar i;
xor g1(s[0],a[0],b[0]);
and g2 (c_out[0],a[0],b[0]);
for(i=1;i<33;i=i+1)
  begin
    if(i==32) assign s[i]=c_out[i-1];
  else fullAdder_tb f(a[i],b[i],c_out[i-1],s[i],c_out[i]);
  //assign c_in=c_out;
  end 

//assign s[31]= 
endmodule
module fullAdder_tb(a,b,c_in,s,c_out);
input a,b,c_in;
output s,c_out;
wire s1,s2,c1;
xor g1 (s1,a,b);
and g2 (s2,s1,c_in);
and g3 (c1,a,b);
or g4 (c_out,c1,s2);
xor g5 (s,s1,c_in);
endmodule

//sub
module full_Subtractor(a,b,d);
input [31:0] a,b;
//input [31:0] b;
output [31:0] d;
wire [31:0] b_in;
wire a12,b12,d12;
not g1(a12,a[0]);
not g2(b12,b[0]);
and g4(d12,a[0],b12);
and g3(b_in[0],a12,b[0]);
or g5(d[0],b_in[0],d12);

genvar i;
for(i=1;i<32;i=i+1)
begin
    if(i>0) full f(a[i],b[i],b_in[i-1],d[i],b_in[i]);
end

endmodule

module full(a,b,b_in,d,b_out);
input a,b,b_in;
output d,b_out;
wire d1,d2,b1,a1,a2,a3;
xor g1(d1,a,b);
xor g2(d,d1,b_in);
xor g3(a1,1,a);
and g4(a2,a1,b);
xor g5(d2,d1,1);
and g6(a3,d2,b_in);
or g7(b_out,a2,a3);
endmodule

 module tb;      
 reg clk;
 wire [4:0]pc_final;
 wire [31:0] out;
 Instruction_fetch uut(.clk(clk),.pc_final(pc_final),.out(out));
 always #2 clk=~clk;
  initial begin
    clk=1;
    #90 $finish;
 end
 
  initial begin
     $monitor("time=%g,output=%b,pc=%b",$time,out,pc_final); 
  
  end
 endmodule