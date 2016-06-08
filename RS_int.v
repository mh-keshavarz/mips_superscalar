//this is a reservation station!


module RS(
	input clk,
	input reset,	//active low synchronous
	input flush,
	input [31:0]Vj,
	input [5:0]Qj,
	input [31:0]Vk,
	input [5:0]Qk,
	input [4:0]op,
	input [15:0]A,
	input [5:0] in_tag,
	input in_busy,	//when you make this 1 all of above will load into RS
					//Up to 2 CDB inputs	from other arithmetic and load
	input [31:0]CDB1_data,
	input CDB1_ready,
	input [5:0]CDB1_tag,
	input [31:0]CDB2_data,
	input CDB2_ready,
	input [5:0]CDB2_tag,	
	input [31:0]CDB3_data,
	input CDB3_ready,
	input [5:0]CDB3_tag,
	
	output reg READY,
	output reg [5:0]out_TAG,
	output reg [31:0]out_DATA,	//or load address
	output reg busy
);

	///integer logfd;
	//initial logfd = $fopen("RSIntLog.txt","w");

	reg [31:0]Vj_reg;
	reg [5:0]Qj_reg;
	reg [31:0]Vk_reg;
	reg [5:0]Qk_reg;
	reg [4:0]op_reg;
	reg [31:0]A_reg;
	reg [5:0] TAG_reg;
	wire operands_fetched;
	wire [31:0]alu_out;
	reg load_s1_passed;
	assign operands_fetched =(op_reg[4])? !(Qj_reg[5:0]):!(Qj_reg[5:0] | Qk_reg[5:0]);	//if 1 then we have all operands required
	always @(posedge clk)
	begin
		if(!reset || flush)
		begin
			Vj_reg <= 0;
			Qj_reg <= 0;
			Vk_reg <= 0;
			Qk_reg <= 0;
			op_reg <= 0;
			A_reg <= 0;
			READY <= 1'b0;
			TAG_reg <= 0;
			load_s1_passed <= 0;
			out_TAG <= 0;
		end else begin
			if(in_busy)
			begin
				busy <= in_busy;
				Vj_reg <= Vj;
				Qj_reg <= Qj;
				Vk_reg <= Vk;
				READY <= 1'b0;
				Qk_reg <= Qk;
				op_reg <= op;
				A_reg <= A;
				TAG_reg <= in_tag;
				load_s1_passed <= 0;
				out_TAG <= 0;
				//$fwrite(logfd,"LOADING:CDB1_ready=%x,CDB1_tag=%x,CDB1_data=%x\n",CDB1_ready,CDB1_tag,CDB1_data);
				//$fwrite(logfd,"LOADING:CDB2_ready=%x,CDB2_tag=%x,CDB2_data=%x\n",CDB2_ready,CDB2_tag,CDB2_data);
				//$fwrite(logfd,"\nLOADING:Vj=%x,Qj=%b,Vk=%x,Qk=%b,op=%b,A=%x\n",Vj,Qj,Vk,Qk,op,A);				
				if(CDB1_tag == Qj && CDB1_ready==1 && Qj!=0)
				begin
					Qj_reg <= 0;
					Vj_reg <= CDB1_data;
				end
				if(CDB2_tag == Qj && CDB2_ready==1 && Qj!=0)
				begin
					Qj_reg <= 0;
					Vj_reg <= CDB2_data;
				end
				if(CDB3_tag == Qj && CDB3_ready==1 && Qj!=0)
				begin
					Qj_reg <= 0;
					Vj_reg <= CDB3_data;
				end				
				if(CDB1_tag == Qk && CDB1_ready==1 && Qk!=0)
				begin
					Qk_reg <= 0;
					Vk_reg <= CDB1_data;
				end
				if(CDB2_tag == Qk && CDB2_ready==1 && Qk!=0)
				begin
					Qk_reg <= 0;
					Vk_reg <= CDB2_data;
				end		
				if(CDB3_tag == Qk && CDB3_ready==1 && Qk!=0)
				begin
					Qk_reg <= 0;
					Vk_reg <= CDB3_data;
				end					
				
			end else 
			begin
				if(Qj_reg!=0 || Qk_reg!=0)	//fetching operands
				begin
					//$fwrite(logfd,"CDB1_ready=%b,CDB1_tag=%b,CDB1_data=%x\n",CDB1_ready,CDB1_tag,CDB1_data);				
					if(CDB1_tag == Qj_reg && CDB1_ready==1)
					begin
						Qj_reg <= 0;
						Vj_reg <= CDB1_data;
					end
					if(CDB2_tag == Qj_reg && CDB2_ready==1)
					begin
						Qj_reg <= 0;
						Vj_reg <= CDB2_data;
					end
					if(CDB3_tag == Qj_reg && CDB3_ready==1)
					begin
						Qj_reg <= 0;
						Vj_reg <= CDB3_data;
					end					
					if(CDB1_tag == Qk_reg && CDB1_ready==1)
					begin
						Qk_reg <= 0;
						Vk_reg <= CDB1_data;
					end
					if(CDB2_tag == Qk_reg && CDB2_ready==1)
					begin
						Qk_reg <= 0;
						Vk_reg <= CDB2_data;
					end
					if(CDB3_tag == Qk_reg && CDB3_ready==1)
					begin
						Qk_reg <= 0;
						Vk_reg <= CDB3_data;
					end					
				end
				//integer operations
				if(operands_fetched)
				begin
					//$fwrite(logfd,"operand fetched\n");
					READY <= 1'b1;
					busy  <= 1'b0;
					if(op_reg==5'b11110)	//beq
					begin
						out_DATA <=(Vk_reg[31:0]==Vj_reg[31:0])? 0:1; 
						//$display("BEQ,Vk=%x,Vj=%x,out=%x\n",Vk_reg,Vj_reg,(Vk_reg[31:0]==Vj_reg[31:0])? 0:1);
					end
					else if(op_reg==5'b11111)	//bne
					begin
						out_DATA <=(Vk_reg[31:0]==Vj_reg[31:0])? 1:0; 
						//$display("BNE,Vk=%x,Vj=%x,out=%x\n",Vk_reg,Vj_reg,(Vk_reg[31:0]==Vj_reg[31:0])? 1:0);
					end
					else
						out_DATA <= alu_out;
						
					/*case(op_reg)
						5'b00010: out_DATA <= Vk_reg + Vj_reg;	//add
						5'b00111: out_DATA <= Vj_reg - Vk_reg;	//sub
						5'b00000: out_DATA <= Vj_reg & Vk_reg;	//and
						5'b00001: out_DATA <= Vj_reg | Vk_reg;	//or
						5'b00011: out_DATA <= Vj_reg ^ Vk_reg;	//xor
						5'b00101: out_DATA <= ~(Vj_reg | Vk_reg);	//nor
						5'b00111: out_DATA <= ($signed(Vj_reg[31:0])<$signed(Vk_reg[31:0]))? 1:0; //slt
						5'b00100: out_DATA <= (Vj_reg[31:0]<Vk_reg[31:0])? 1:0; 					//sltu
						
						5'b10010: out_DATA <=  Vj_reg + {{16{A_reg[15]}},A_reg[15:0]};
						5'b11010: out_DATA <=  Vj_reg + {{16{1'b0}},A_reg[15:0]};
						5'b10111: out_DATA <= ($signed(Vj_reg[31:0])<$signed({{16{A_reg[15]}},A_reg[15:0]}))? 1:0; //slt
						5'b11011: out_DATA <= ($signed(Vj_reg[31:0])<$signed({{16{A_reg[15]}},A_reg[15:0]}))? 1:0; //slt
						5'b11001: out_DATA <=  Vj_reg & {{16{1'b0}},A_reg[15:0]};
						5'b11100: out_DATA <=  Vj_reg | {{16{1'b0}},A_reg[15:0]};
						5'b11101: out_DATA <=  Vj_reg ^ {{16{1'b0}},A_reg[15:0]};
						5'b11000: out_DATA <= {A_reg[15:0],{16{1'b0}}};
						5'b11110: out_DATA <=(Vk_reg[31:0]==Vj_reg[31:0])? 0:1; 
						5'b11111: out_DATA <=(Vk_reg[31:0]==Vj_reg[31:0])? 1:0; 
						default : out_DATA <= Vk_reg;
					endcase*/
					out_TAG  <= TAG_reg;
				end else
				begin
					if(busy)
						//$fwrite(logfd,"waiting for operands with tags=%b,%b\n",Qj_reg,Qk_reg);
					out_TAG <= 0;
					READY <= 1'b0;
				end
				
				if(!busy)
				begin
					out_TAG <= 0;
					READY <= 1'b0;					
				end
			end
		end
	end
	wire [31:0]srcBE;
	assign srcBE = (op_reg[4]==1'b1)?{{16{A_reg[15]}},A_reg[15:0]}:Vk_reg;
	ALU alu(
    .ALUControlE(op_reg[3:0]),
    .SrcAE(Vj_reg),
    .SrcBE(srcBE),
    .ALUOut(alu_out)
    );

endmodule 