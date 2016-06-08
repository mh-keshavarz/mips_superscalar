module CU(
input [5:0] op,
input [5:0] funct,
output reg[4:0]RSOP
);

    always@(*)
    begin        
       case (op)
		6'b000000: 
		begin  //R_format
			case(funct)
				6'b100000:begin //ADD
						RSOP=5'b00010;
				end
				6'b100001:begin //ADDU
						RSOP=5'b00010;                                   
				end
				6'b100010:begin //SUB
						RSOP=5'b00111;                               
				end
				6'b100011:begin //SUBU
						RSOP=5'b00111;                                  
				end
				6'b100100:begin //AND
						RSOP=5'b00000;                                      
				end
				6'b100101:begin //OR
						RSOP=5'b00001;                                    
				end
				6'b100110:begin //XOR
					RSOP=5'b00011;
				end
				6'b100111:begin //NOR
					RSOP=5'b00101;                                  
				end
				6'b101010:begin //SLT
					RSOP=5'b00111;                                  
				end
				6'b101011:begin //SLTU
					RSOP=5'b00100;      
					//$display("SLTU");
				end
				default: begin  //regWrite and memWrite ==0 and Branch
					RSOP=5'b01000;                              
				end
			endcase
		end
			
		6'b001000: begin  //ADDI
			RSOP=5'b10010;             
		end      
		6'b001001: begin  //ADDIU
			RSOP=5'b11010;                
		end
		6'b001010: begin  //SLTI
			RSOP=5'b10111;                   
		end     
		6'b001011: begin  //SLTIU
			RSOP=5'b11011;
		end     
		6'b001100: begin  //ANDI
			RSOP=5'b11001;
		end     
		6'b001101: begin  //ORI
			RSOP=5'b11100;
		end      
		6'b001110: begin  //XORI
			RSOP=5'b11101;
		end     
		6'b001111: begin  //LUI??????????????????????????????
			RSOP=5'b11000;
		end         
		6'b000100: begin  //BEQ		
			RSOP=5'b11110;		//--CHANGED FROM -
		end
		6'b000101: begin  //BNE
			RSOP=5'b11111;    //--CHANGED FROM -	
		//$display("BNE");
		end      
		6'b100011: begin  //LW????????????????
			RSOP=5'b10010;
		end
		6'b101011: begin  //SW?????????????????????
			RSOP=5'b10010;
		end                                                                                                                                                       
		default  : begin  //regWrite and memWrite ==0 and Branch
			RSOP=5'b11000;     
		end	
	
	
	
	endcase
	end
endmodule 
