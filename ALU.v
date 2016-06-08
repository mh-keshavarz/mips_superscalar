`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2015 08:38:51 PM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



/*
ALU Control:
    000 = A & B
    001 = A | B
    010 = A + B
    011 = A ^ B
    //100 = A &~ B
    100 = SLTU
    101 = A | ~B
    111 = SLT := (rs<rt)? 1:0;
*/

module ALU(
    input [3:0] ALUControlE,
    input [31:0] SrcAE,
    input [31:0] SrcBE,
    output reg ZeroM,
    output reg [31:0] ALUOut
    );
    
    
    always @(ALUControlE,SrcAE,SrcBE)
    begin
        case(ALUControlE[3:0])
            4'b0000:
            begin
                ALUOut = SrcAE[31:0] & SrcBE[31:0]; 
            end
            4'b0001:
            begin
                ALUOut = SrcAE[31:0] | SrcBE[31:0]; 
            end 
            4'b0010:
            begin
                ALUOut = SrcAE[31:0] + SrcBE[31:0]; 
            end            
            4'b0011:
            begin
                ALUOut = SrcAE[31:0] ^ SrcBE[31:0]; 
            end            
            4'b0100:
            begin   //sltu
                ALUOut = ({1'b0,SrcAE[31:0]}<{1'b0,SrcBE[31:0]})? 32'h00000001:32'h00000000;
				//$display("slt %x .. %x = %x ", SrcAE[31:0], SrcBE[31:0],ALUOut);				
            end            
            4'b0101:
            begin
                ALUOut = ~(SrcAE[31:0] | SrcBE[31:0]); 
            end            
            4'b0110:
            begin
                ALUOut = (SrcAE[31:0] - SrcBE[31:0]); 
				//$display("sub %x + %x = %x ", SrcAE[31:0], {16'h0000,SrcBE[15:0]},ALUOut);
            end            
            4'b0111:
            begin
                ALUOut = ($signed(SrcAE[31:0])<$signed(SrcBE[31:0]))? 32'h00000001:32'h00000000; 
				//$display("slt %x .. %x = %x ", SrcAE[31:0], SrcBE[31:0],ALUOut);
            end
            4'b1000:    //for lui
            begin
                ALUOut[31:16] = SrcBE[15:0];
                ALUOut[15:0] = 16'h0000; 
            end
            4'b1010:    //for addiu
            begin
                ALUOut = SrcAE[31:0] + {16'h0000,SrcBE[15:0]}; 
				//$display("addiu %x + %x = %x ", SrcAE[31:0], {16'h0000,SrcBE[15:0]},ALUOut);
            end			
            4'b1011:    //sltiu
            begin
				ALUOut = (SrcAE[31:0]<{16'h0000,SrcBE[15:0]})? 32'h11111111:32'h00000000; 
				//$display("addiu %x + %x = %x ", SrcAE[31:0], {16'h0000,SrcBE[15:0]},ALUOut);
            end		

            4'b1001:    //andi
            begin
				ALUOut = (SrcAE[31:0]&{16'h0000,SrcBE[15:0]}); 
				//$display("addiu %x + %x = %x ", SrcAE[31:0], {16'h0000,SrcBE[15:0]},ALUOut);
            end				
            4'b1100:    //ori
            begin
				ALUOut = (SrcAE[31:0]|{16'h0000,SrcBE[15:0]}); 
				//$display("addiu %x + %x = %x ", SrcAE[31:0], {16'h0000,SrcBE[15:0]},ALUOut);
            end				
            4'b1101:    //xori
            begin
				ALUOut = (SrcAE[31:0]^{16'h0000,SrcBE[15:0]}); 
				//$display("addiu %x + %x = %x ", SrcAE[31:0], {16'h0000,SrcBE[15:0]},ALUOut);
            end				
            
			4'b1110:    //beq
            begin
				ALUOut = (SrcAE[31:0]==SrcBE[31:0])? 0:1; 
				//$display("addiu %x + %x = %x ", SrcAE[31:0], {16'h0000,SrcBE[15:0]},ALUOut);
            end	
            4'b1111:    //bne
            begin
				ALUOut = (SrcAE[31:0]==SrcBE[31:0])? 1:0; 
				//$display("addiu %x + %x = %x ", SrcAE[31:0], {16'h0000,SrcBE[15:0]},ALUOut);
            end				
            default:
                ALUOut = 32'h00000000;            
        endcase
        ZeroM = |(ALUOut[31:0]);
    end

endmodule
