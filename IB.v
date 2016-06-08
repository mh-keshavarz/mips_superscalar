//this will be our instruction buffer
module IF(
input clk,
input reset,
input flush,

input [31:0]Iin1,
input Iin1Valid,
input [31:0]Iin2,
input Iin2Valid,
input [31:0]Iin3,
input Iin3Valid,
input [31:0]Iin4,
input Iin4Valid,

input [2:0]out_read_count,

output  [31:0]Iout1,
output  Iout1Valid,
output  [31:0]Iout2,
output  Iout2Valid,
output  [31:0]Iout3,
output  Iout3Valid,
output  [31:0]Iout4,
output  Iout4Valid,

output  [2:0]in_count,
output  [2:0]empty_count
);
	//integer logfd;
	//initial logfd = $fopen("LOGIB.txt","w");
	
	parameter BUFF_DEPTH = 4;
	reg [BUFF_DEPTH-1:0]VALID;
	reg [31:0]INSTR[BUFF_DEPTH-1:0];
	integer i;
	
	always@(posedge clk)
	begin
		//$fwrite(logfd,"Iin1=%x,Iin2=%x,Iin3=%x,Iin4=%x\n",Iin1,Iin2,Iin3,Iin4);
		//$fwrite(logfd,"Ins1=%x,Ins2=%x,Ins3=%x,Ins4=%x\n",INSTR[0],INSTR[1],INSTR[2],INSTR[3]);
		//$fwrite(logfd,"val0=%x,val1=%x,val2=%x,val3=%x\n",VALID[0],VALID[1],VALID[2],VALID[3]);
		//$fwrite(logfd,"out_read_count=%b\n\n",out_read_count);
		if(!reset)
		begin
			VALID[BUFF_DEPTH-1:0] <= 0;
			for(i=0;i<BUFF_DEPTH;i=i+1)
				INSTR[i] <= 0;
		end
		else
		begin
			if(flush)
			begin
				VALID[BUFF_DEPTH-1:0] <= 0;
				for(i=0;i<BUFF_DEPTH;i=i+1)
					INSTR[i] <= 0;
			end
			else if(out_read_count==4)
			begin
				INSTR[0] <= Iin1;
				INSTR[1] <= Iin2;
				INSTR[2] <= Iin3;
				INSTR[3] <= Iin4;
				VALID[0] <= Iin1Valid;
				VALID[1] <= Iin2Valid;
				VALID[2] <= Iin3Valid;
				VALID[3] <= Iin4Valid;
			end
			else if(out_read_count==3)
			begin
				if(VALID[3]==1'b1)
				begin
					INSTR[0] <= INSTR[3];
					INSTR[1] <= Iin1;
					INSTR[2] <= Iin2;
					INSTR[3] <= Iin3;
					VALID[0] <= 1'b1;
					VALID[1] <= Iin1Valid;
					VALID[2] <= Iin2Valid;
					VALID[3] <= Iin3Valid;					
				end
				else
				begin
					INSTR[0] <= Iin1;
					INSTR[1] <= Iin2;
					INSTR[2] <= Iin3;
					INSTR[3] <= Iin4;
					VALID[0] <= Iin1Valid;
					VALID[1] <= Iin2Valid;
					VALID[2] <= Iin3Valid;
					VALID[3] <= Iin4Valid;					
				end
			end
			else if(out_read_count==2)
			begin
				if(VALID[3]==1'b1 && VALID[2]==1'b1)
				begin
					INSTR[0] <= INSTR[2];
					INSTR[1] <= INSTR[3];
					INSTR[2] <= Iin1;
					INSTR[3] <= Iin2;
					VALID[0] <= 1'b1;
					VALID[1] <= 1'b1;
					VALID[2] <= Iin1Valid;
					VALID[3] <= Iin2Valid;					
				end
				else if(VALID[3]==1'b0 && VALID[2]==1'b1)
				begin
					INSTR[0] <= INSTR[2];
					INSTR[1] <= Iin1;
					INSTR[2] <= Iin2;
					INSTR[3] <= Iin3;
					VALID[0] <= 1'b1;
					VALID[1] <= Iin1Valid;
					VALID[2] <= Iin2Valid;
					VALID[3] <= Iin3Valid;					
				end
				else
				begin
					INSTR[0] <= Iin1;
					INSTR[1] <= Iin2;
					INSTR[2] <= Iin3;
					INSTR[3] <= Iin4;
					VALID[0] <= Iin1Valid;
					VALID[1] <= Iin2Valid;
					VALID[2] <= Iin3Valid;
					VALID[3] <= Iin4Valid;					
				end
			end		
			else if(out_read_count==1)
			begin
				if(VALID[3]==1'b1 && VALID[2]==1'b1 && VALID[1]==1'b1)
				begin
					INSTR[0] <= INSTR[1];
					INSTR[1] <= INSTR[2];
					INSTR[2] <= INSTR[3];
					INSTR[3] <= Iin1;
					VALID[0] <= 1'b1;
					VALID[1] <= 1'b1;
					VALID[2] <= 1'b1;
					VALID[3] <= Iin1Valid;					
				end	
				else if(VALID[3]==1'b0 && VALID[2]==1'b1 && VALID[1]==1'b1)
				begin
					INSTR[0] <= INSTR[1];
					INSTR[1] <= INSTR[2];
					INSTR[2] <= Iin1;
					INSTR[3] <= Iin2;
					VALID[0] <= 1'b1;
					VALID[1] <= 1'b1;
					VALID[2] <= Iin1Valid;
					VALID[3] <= Iin2Valid;					
				end	
				else if(VALID[3]==1'b0 && VALID[2]==1'b0 && VALID[1]==1'b1)
				begin
					INSTR[0] <= INSTR[1];
					INSTR[1] <= Iin1;
					INSTR[2] <= Iin2;
					INSTR[3] <= Iin3;
					VALID[0] <= 1'b1;
					VALID[1] <= Iin1Valid;
					VALID[2] <= Iin2Valid;
					VALID[3] <= Iin3Valid;					
				end	
				else
				begin
					INSTR[0] <= INSTR[1];
					INSTR[1] <= Iin1;
					INSTR[2] <= Iin2;
					INSTR[3] <= Iin3;
					VALID[0] <= 1'b1;
					VALID[1] <= Iin1Valid;
					VALID[2] <= Iin2Valid;
					VALID[3] <= Iin3Valid;					
				end	
			end		
			else if(out_read_count==0)
			begin
				//$fwrite(logfd,"Hello\n");
				if(VALID[3]==1'b1 && VALID[2]==1'b1 && VALID[1]==1'b1 && VALID[0]==1'b1)
				begin
					//$fwrite(logfd,"Hello1\n");
					INSTR[0] <= INSTR[0];
					INSTR[1] <= INSTR[1];
					INSTR[2] <= INSTR[2];
					INSTR[3] <= INSTR[3];
					VALID[0] <= 1'b1;
					VALID[1] <= 1'b1;
					VALID[2] <= 1'b1;
					VALID[3] <= 1'b1;
				end	
				else if(VALID[3]==1'b0 && VALID[2]==1'b1 && VALID[1]==1'b1 && VALID[0]==1'b1)
				begin
					//$fwrite(logfd,"Hello2\n");
					INSTR[0] <= INSTR[0];
					INSTR[1] <= INSTR[1];
					INSTR[2] <= INSTR[2];
					INSTR[3] <= Iin1;
					VALID[0] <= 1'b1;
					VALID[1] <= 1'b1;
					VALID[2] <= 1'b1;
					VALID[3] <= Iin1Valid;					
				end	
				else if(VALID[3]==1'b0 && VALID[2]==1'b0 && VALID[1]==1'b1 && VALID[0]==1'b1)
				begin
					INSTR[0] <= INSTR[0];
					INSTR[1] <= INSTR[1];
					INSTR[2] <= Iin1;
					INSTR[3] <= Iin2;
					VALID[0] <= 1'b1;
					VALID[1] <= 1'b1;
					VALID[2] <= Iin1Valid;
					VALID[3] <= Iin2Valid;					
				end	
				else if(VALID[3]==1'b0 && VALID[2]==1'b0 && VALID[1]==1'b0 && VALID[0]==1'b1)
				begin
					//$fwrite(logfd,"Hello4\n");
					INSTR[0] <= INSTR[0];
					INSTR[1] <= Iin1;
					INSTR[2] <= Iin2;
					INSTR[3] <= Iin3;
					VALID[0] <= 1'b1;
					VALID[1] <= Iin1Valid;
					VALID[2] <= Iin2Valid;
					VALID[3] <= Iin3Valid;					
				end					
				else
				begin
					INSTR[0] <= Iin1;
					INSTR[1] <= Iin2;
					INSTR[2] <= Iin3;
					INSTR[3] <= Iin4;
					VALID[0] <= Iin1Valid;
					VALID[1] <= Iin2Valid;
					VALID[2] <= Iin3Valid;
					VALID[3] <= Iin4Valid;					
				end				
			end
			else if(VALID== 4'b0000)
			begin
					INSTR[0] <= Iin1;
					INSTR[1] <= Iin2;
					INSTR[2] <= Iin3;
					INSTR[3] <= Iin4;
					VALID[0] <= Iin1Valid;
					VALID[1] <= Iin2Valid;
					VALID[2] <= Iin3Valid;
					VALID[3] <= Iin4Valid;	
			end
		end
	end
	
	assign Iout1 = INSTR[0];
	assign Iout2 = INSTR[1];
	assign Iout3 = INSTR[2];
	assign Iout4 = INSTR[3];

	assign Iout1Valid = VALID[0];
	assign Iout2Valid = VALID[1];
	assign Iout3Valid = VALID[2];
	assign Iout4Valid = VALID[3];
	
	assign empty_count = !VALID[0]+!VALID[1]+!VALID[2]+!VALID[3];
	assign in_count = ((out_read_count + empty_count)<5)? (out_read_count + empty_count):4;
	
endmodule 
