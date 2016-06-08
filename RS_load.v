//this is a reservation station!


module RS_load(
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
	input address_neq_stores,
	input in_busy,	//when you make this 1 all of above will load into RS
					//Up to 2 CDB inputs from arithmetics
	input [31:0]CDB1_data,
	input CDB1_ready,
	input [5:0]CDB1_tag,
	input [31:0]CDB2_data,
	input CDB2_ready,
	input [5:0]CDB2_tag,			
	
	output reg READY,
	output reg address_check,
	output reg [5:0]out_TAG,
	output reg [31:0]out_DATA,	//or load address
	output reg busy
);

	//integer logfd;
	//initial logfd = $fopen("RSLoadLog.txt","w");

	reg [31:0]Vj_reg;
	reg [5:0]Qj_reg;
	reg [31:0]Vk_reg;
	reg [5:0]Qk_reg;
	reg [5:0]op_reg;
	reg [31:0]A_reg;
	reg [5:0] TAG_reg;
	wire operands_fetched;
	wire [31:0]alu_out;
	reg load_s1_passed;
	assign operands_fetched = !(Qj_reg[5:0] | Qk_reg[5:0]);	//if 1 then we have all operands required
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
			address_check <= 0;
			out_TAG <= 0;
			busy <= 0;
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
				address_check <= 0;
				//$fwrite(logfd,"\nLOADING:Vj=%x,Qj=%x,Vk=%x,Qk=%x,op=%b,A=%x\n",Vj,Qj,Vk,Qk,op,A);
				
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
				
			end else 
			begin
				if(Qj_reg!=0 || Qk_reg!=0)	//fetching operands
				begin
					if(CDB1_tag == Qj_reg && CDB1_ready==1 && Qj_reg!=0)
					begin
						Qj_reg <= 0;
						Vj_reg <= CDB1_data;
					end
					if(CDB2_tag == Qj_reg && CDB2_ready==1 && Qj_reg!=0)
					begin
						Qj_reg <= 0;
						Vj_reg <= CDB2_data;
					end
					
					if(CDB1_tag == Qk_reg && CDB1_ready==1 && Qk_reg!=0)
					begin
						Qk_reg <= 0;
						Vk_reg <= CDB1_data;
					end
					if(CDB2_tag == Qk_reg && CDB2_ready==1 && Qk_reg!=0)
					begin
						Qk_reg <= 0;
						Vk_reg <= CDB2_data;
					end
				end
				//load logic
				address_check <= 0;
				if(load_s1_passed ==0 && Qj_reg == 0 && busy)
				begin	
					////$fwrite(logfd,"PASS1: Vj=%x,Qj=%x,Vk=%x,Qk=%x,A=%x,LAddress=%x\n",Vj_reg,Qj_reg,Vk_reg,Qk_reg,A_reg,Vj_reg + {{16{A_reg[15]}},A_reg});
					load_s1_passed <= 1'b1;
					out_DATA <= Vj_reg + {{16{A_reg[15]}},A_reg};
					A_reg <= Vj_reg + {{16{A_reg[15]}},A_reg};
					address_check <= 1;
					out_TAG <= TAG_reg;
				end
				if(load_s1_passed && address_neq_stores && address_check==1'b0 && busy)	//no store with the same address?
				begin
					////$fwrite(logfd,"PASS2: Vj=%x,Qj=%x,Vk=%x,Qk=%x,A=%x,LAddress=%x\n",Vj_reg,Qj_reg,Vk_reg,Qk_reg,A_reg,A_reg);
					out_TAG <= TAG_reg;
					out_DATA <= A_reg;
					READY <= 1'b1;
					busy <= 1'b0;
					address_check <= 0;
				end
				if(address_check)
					address_check <= 1'b0;
				if(!busy)
				begin
					out_TAG <= 0;
					READY <= 1'b0;	
					address_check <= 0;	
					load_s1_passed <= 1'b0;
				end
			end
		end
	end


endmodule 