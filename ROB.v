//this is reorder buffer


module ROB(
	input clk,
	input reset,		//active low
	//supports Up to 4 Instructions per clock
	input [2:0]InInst1Type,
	input [31:0]InInst1Dest,	//if no store
	input [31:0]InInst1Val,	//from RF if available
	input InInst1Ready,
	input InInst1DataValid,
	
	input [2:0]InInst2Type,
	input [31:0]InInst2Dest,	//if no store
	input [31:0]InInst2Val,	//from RF if available
	input InInst2Ready,
	input InInst2DataValid,
	
	input [2:0]InInst3Type,
	input [31:0]InInst3Dest,	//if no store
	input [31:0]InInst3Val,	//from RF if available
	input InInst3Ready,
	input InInst3DataValid,
	
	input [2:0]InInst4Type,
	input [31:0]InInst4Dest,	//if no store
	input [31:0]InInst4Val,	//from RF if available
	input InInst4Ready,
	input InInst4DataValid,
	//supports Upto 4 CDB inputs
	input [31:0]CDB1_data,
	input CDB1_ready,
	input [5:0]CDB1_tag,
	input [31:0]CDB2_data,
	input CDB2_ready,
	input [5:0]CDB2_tag,	
	input [31:0]CDB3_data,
	input CDB3_ready,
	input [5:0]CDB3_tag,
	input [31:0]LAddress,
	//store CDB
	input [31:0]CDB4_data,
	input [31:0]CDB4_address,
	input CDB4_ready,
	input [5:0]CDB4_tag,
	
	//for load RS that needs cheking store address
	input check_same,
	output reg check_not_same,
	//OUTPUTS
	output reg [31:0] BTarget,
	output reg [4:0]empty_counter,	//for fetch unit
	output reg [2:0]empty_head,	//for fetch unit
	output reg [31:0] RFData1,		//for writing results RF write port1
	output reg [4:0] RFData1Address,
	output reg RFData1Valid,		//for writing results RF write port1
	output reg [5:0]RF1WriterTag,
	output reg [31:0] RFData2,		//for writing results RF write port2
	output reg [4:0] RFData2Address,
	output reg RFData2Valid,		//for writing results RF write port2
	output reg [5:0]RF2WriterTag,
	output reg MemWe,				//for writing results Mem write port
	output reg [31:0]MemAddress,	//for writing results Mem write port
	output reg [31:0]MemData,		//for writing results Mem write port
	output reg flush,
	output reg END
);
	/*integer log_fd;
	initial log_fd=$fopen("ROBLog.txt","w");
	integer log_fd2;
	initial log_fd2=$fopen("ROBInfo.txt","w");
*/
	parameter ROB_DEPTH = 8;
	parameter ITYPE_ARITHMETIC = 0;
	parameter ITYPE_BRANCH = 1;
	parameter ITYPE_STORE = 2;
	//parameter ITYPE_LOAD = 8;
	
	reg [ROB_DEPTH-1:0]READY;
	reg [ROB_DEPTH-1:0]VALID;
	reg [31:0]DEST[ROB_DEPTH-1:0];
	reg [31:0]VAL[ROB_DEPTH-1:0];
	reg [2:0]ITYPE[ROB_DEPTH-1:0];	
	
	reg [3:0]instruction_read;
	reg [3:0]instruction_write;
	reg [2:0]head_pointer;
	reg [2:0]regwrite;
	reg [2:0]memwrite;
	reg [2:0]regwrite_enable;
	reg [2:0]memwrite_enable;	
	integer i;

	wire [2:0]empty_head_p1;
	wire [2:0]empty_head_p2;
	wire [2:0]empty_head_p3;
	wire [2:0]empty_head_p4;
	assign empty_head_p1 = (empty_head<7)? (empty_head+1):(empty_head-7);
	assign empty_head_p2 = (empty_head<6)? (empty_head+2):(empty_head-6);
	assign empty_head_p3 = (empty_head<5)? (empty_head+3):(empty_head-5);
	assign empty_head_p4 = (empty_head<4)? (empty_head+4):(empty_head-4);

	wire [2:0]head_pointer_p1;
	wire [2:0]head_pointer_p2;
	wire [2:0]head_pointer_p3;
	wire [2:0]head_pointer_p4;
	assign head_pointer_p1 = (head_pointer<7)? (head_pointer+1):(head_pointer-7);
	assign head_pointer_p2 = (head_pointer<6)? (head_pointer+2):(head_pointer-6);
	assign head_pointer_p3 = (head_pointer<5)? (head_pointer+3):(head_pointer-5);
	assign head_pointer_p4 = (head_pointer<4)? (head_pointer+4):(head_pointer-4);	
	
	wire [3:0]head_pointer_p1_tag;
	wire [3:0]head_pointer_p2_tag;
	wire [3:0]head_pointer_p3_tag;
	wire [3:0]head_pointer_p4_tag;
	assign head_pointer_p1_tag = head_pointer + 1;
	assign head_pointer_p2_tag = (head_pointer<7)? (head_pointer+2):(head_pointer-6);
	assign head_pointer_p3_tag = (head_pointer<6)? (head_pointer+3):(head_pointer-5);
	assign head_pointer_p4_tag = (head_pointer<5)? (head_pointer+4):(head_pointer-4);		
	
	always@(posedge clk)
	begin
		if(!reset || flush)
		begin
			READY<= 0;
			VALID<=0;
			for(i=0;i<ROB_DEPTH;i=i+1)
			begin
				DEST[i] <= 0;
				VAL[i] <= 0;
				ITYPE[i] <=0;
			end
			head_pointer <= 0;
			empty_head <= 0;
			RFData1Valid <= 0;
			RFData2Valid <= 0;
			MemWe <= 0;
			flush <= 0;
		end
		else
		begin
			//for(i=0;i<8;i=i+1)
				////$fwrite(log_fd2," %d: VALID=%b ITYPE=%x, VAL=%x, DEST=%x, READY=%b\n",i,VALID[i],ITYPE[i],VAL[i],DEST[i],READY[i]);
			//=====================================================================================
			//adding rows from inputs
			//quite compilicated!!!!
			/*instruction_read[0]=0;
			instruction_read[1]=0;
			instruction_read[2]=0;
			instruction_read[3]=0;
			instruction_write[0]=0;
			instruction_write[1]=0;
			instruction_write[2]=0;
			instruction_write[3]=0;
			*/
			if(empty_counter>0 && InInst1DataValid)
			begin
				//$fwrite(log_fd,"INSTRUCTION1:head_pointer=%x TAG=%x,TYPE=%x,DEST=%x \n",head_pointer, empty_head_p1,InInst1Type,InInst1Dest);
				READY[empty_head] <= InInst1Ready;	//set by decoder controller by checking if every thing is supplied
				VALID[empty_head] <= 1'b1;
				ITYPE[empty_head][2:0] <= InInst1Type[2:0];
				DEST[empty_head] <= InInst1Dest;
				VAL[empty_head] <= InInst1Val;
				empty_head <= empty_head_p1;	//suppose circular if overflow!
				//instruction_read[0]=1;
				if(empty_counter>1 && InInst2DataValid)
				begin
					//$fwrite(log_fd,"INSTRUCTION2: TAG=%x,TYPE=%x,DEST=%x \n",empty_head_p2,InInst2Type,InInst2Dest);
					READY[empty_head_p1] <= InInst2Ready;	//set by decoder controller by checking if every thing is supplied
					VALID[empty_head_p1] <= 1'b1;
					ITYPE[empty_head_p1] <= InInst2Type;
					DEST[empty_head_p1] <= InInst2Dest;
					VAL[empty_head_p1] <= InInst2Val;
					empty_head <= empty_head_p2;	//suppose circular if overflow!
					//instruction_read[1]=1;
					if(empty_counter>2 && InInst3DataValid)
					begin
						//$fwrite(log_fd,"INSTRUCTION3: TAG=%x,TYPE=%x,DEST=%x \n",empty_head_p3,InInst3Type,InInst3Dest);
						READY[empty_head_p2] <= InInst3Ready;	//set by decoder controller by checking if every thing is supplied
						VALID[empty_head_p2] <= 1'b1;
						ITYPE[empty_head_p2] <= InInst3Type;
						DEST[empty_head_p2] <= InInst3Dest;
						VAL[empty_head_p2] <= InInst3Val;
						empty_head <= empty_head_p3;	//suppose circular if overflow!
						//instruction_read[2]=1;
						if(empty_counter>3 && InInst4DataValid)
						begin
							//$fwrite(log_fd,"INSTRUCTION4: TAG=%x,TYPE=%x,DEST=%x \n",empty_head_p4,InInst4Type,InInst4Dest);
							READY[empty_head_p3] <= InInst4Ready;	//set by decoder controller by checking if every thing is supplied
							VALID[empty_head_p3] <= 1'b1;
							ITYPE[empty_head_p3] <= InInst4Type;
							DEST[empty_head_p3] <= InInst4Dest;
							VAL[empty_head_p3] <= InInst4Val;
							empty_head <= empty_head_p4;	//suppose circular if overflow!					
							//instruction_read[3]=1;
						end
					end
				end
			end
			//=====================================================================================
			//adding data from CDBs
			for(i=0;i<ROB_DEPTH;i=i+1)
			begin
				if(CDB1_tag==i+1 && CDB1_ready==1'b1)
				begin
					if(ITYPE[i]==ITYPE_ARITHMETIC || ITYPE[i]==ITYPE_BRANCH)
					begin
						//$fwrite(log_fd,"READINGDATA:CDB1,tag=%x,CDB_data=%x\n",CDB1_tag,CDB1_data);
						READY[i] <= 1'b1;
						VAL[i] <= CDB1_data;
					end
				end
				if(CDB2_tag==i+1 && CDB2_ready==1'b1)
				begin
					if(ITYPE[i]==ITYPE_ARITHMETIC || ITYPE[i]==ITYPE_BRANCH)
					begin
						//$fwrite(log_fd,"READINGDATA:CDB2,tag=%x,CDB_data=%x\n",CDB2_tag,CDB2_data);
						READY[i] <= 1'b1;
						VAL[i] <= CDB2_data;
					end
				end
				if(CDB3_tag==i+1 && CDB3_ready==1'b1)
				begin
					if(ITYPE[i]==ITYPE_ARITHMETIC || ITYPE[i]==ITYPE_BRANCH)
					begin
						//$fwrite(log_fd,"READINGDATA:CDB3,tag=%x,CDB_data=%x\n",CDB3_tag,CDB3_data);
						READY[i] <= 1'b1;
						VAL[i] <= CDB3_data;
					end
				end				
				if(CDB4_tag==i+1 && CDB4_ready==1'b1)
				begin
					if(ITYPE[i]==ITYPE_STORE)
					begin
						//$fwrite(log_fd,"READINGDATA:CDB4,tag=%x,CDB_data=%x,CDB4_address=%x\n",CDB4_tag,CDB4_data,CDB4_address);
						//$fwrite(log_fd2,"READINGDATA:CDB4,tag=%x,CDB_data=%x,CDB4_address=%x\n",CDB4_tag,CDB4_data,CDB4_address);
						READY[i] <= 1'b1;
						VAL[i] <= CDB4_data;
						DEST[i] <= CDB4_address;
					end
				end				
			end
			//=====================================================================================
			//commiting if available	---something compilicated
			RFData1Valid <= 1'b0;
			RFData2Valid <= 1'b0;
			MemWe <= 1'b0;
			flush <= 1'b0;	
			//$fwrite(log_fd2,"INFORMATION:ITYPE[%d]=%x, VAL[%d]=%x, empty_head=%d , empty_counter=%d\n",
				//		head_pointer,ITYPE[head_pointer],head_pointer,VAL[head_pointer],empty_head,empty_counter);
			if(READY[head_pointer]==1'b1 && VALID[head_pointer]==1'b1)
			begin
				if(ITYPE[head_pointer]==ITYPE_BRANCH && VAL[head_pointer]==0)	//we should take the branch but ... now flush!
				begin
					READY<= 0;
					VALID<=0;
					//$fwrite(log_fd,"FLUSH dest=%x\n",DEST[head_pointer]);
					//$fwrite(log_fd2,"FLUSH dest=%x\n",DEST[head_pointer]);
					for(i=0;i<ROB_DEPTH;i=i+1)
					begin
						DEST[i] <= 0;
						VAL[i] <= 0;
						ITYPE[i] <=0;
						READY <= 0;
						VALID <= 0;
					end
					head_pointer <= 0;
					empty_head <= 0;
					flush <= 1'b1;
					BTarget <= DEST[head_pointer];
				end
				else	//not a flush for head_pointer
				begin
					head_pointer <= head_pointer_p1;
					if(ITYPE[head_pointer]==ITYPE_BRANCH)	//right speculation branch
					begin
						//$fwrite(log_fd,"BRANCH TAKEN,val=%x,dest=%x\n",VAL[head_pointer],DEST[head_pointer]);
						VALID[head_pointer]<=1'b0;
						READY[head_pointer] <= 1'b0;
					end
					else if(ITYPE[head_pointer]==ITYPE_STORE)
					begin
						//$fwrite(log_fd,"STORING:\n");	
						VALID[head_pointer]<=1'b0;
						MemData <= VAL[head_pointer];
						MemWe <= 1'b1;
						MemAddress <= DEST[head_pointer];
						READY[head_pointer] <= 1'b0;
					end
					else if(ITYPE[head_pointer]==ITYPE_ARITHMETIC)
					begin
						//$fwrite(log_fd,"ARWRITING: tag=%b,value=%x,dest=%b\n",head_pointer_p1_tag,VAL[head_pointer],DEST[head_pointer][4:0]);
						VALID[head_pointer]<=1'b0;
						RFData1 <= VAL[head_pointer];
						RFData1Valid <= 1'b1;
						RF1WriterTag <= head_pointer_p1_tag;
						RFData1Address <= DEST[head_pointer][4:0];
						READY[head_pointer] <= 1'b0;
					end
					//first commit now second if possible
					if(READY[head_pointer_p1]==1'b1 && VALID[head_pointer_p1]==1'b1)
					begin
						if(ITYPE[head_pointer_p1]==ITYPE_BRANCH && VAL[head_pointer_p1]==0)//false speculation branch... now flush!
						begin
							READY<= 0;
							VALID<=0;
							//$fwrite(log_fd,"FLUSH dest=%x\n",DEST[head_pointer_p1]);
							//$fwrite(log_fd2,"FLUSH dest=%x\n",DEST[head_pointer_p1]);
							for(i=0;i<ROB_DEPTH;i=i+1)
							begin
								DEST[i] <= 0;
								VAL[i] <= 0;
								ITYPE[i] <=0;
							end
							head_pointer <= 0;
							empty_head <= 0;
							flush <= 1'b1;
							BTarget <= DEST[head_pointer_p1];
						end
						else 
						begin
							head_pointer <= head_pointer_p2;
							if(ITYPE[head_pointer_p1]==ITYPE_BRANCH)	//right speculation branch
							begin
								//$fwrite(log_fd,"BRANCH TAKEN,val=%x,dest=%x\n",VAL[head_pointer_p1],DEST[head_pointer_p1]);
								VALID[head_pointer_p1]<=1'b0;
								READY[head_pointer_p1] <= 1'b0;
							end
							else if(ITYPE[head_pointer_p1]==ITYPE_STORE && memwrite_enable[1])
							begin
								//$fwrite(log_fd,"STORING:\n");	
								VALID[head_pointer_p1]<=1'b0;
								MemData <= VAL[head_pointer_p1];
								MemWe <= 1'b1;
								MemAddress <= DEST[head_pointer_p1];
								READY[head_pointer_p1] <= 1'b0;
							end
							else if(ITYPE[head_pointer_p1]==ITYPE_ARITHMETIC && regwrite_enable[1])
							begin
								if(regwrite[0])
								begin
									//$fwrite(log_fd,"ARWRITING: tag=%b,value=%x,dest=%b\n",head_pointer_p2_tag,VAL[head_pointer_p1],DEST[head_pointer_p1][4:0]);
									VALID[head_pointer_p1]<=1'b0;
									RFData2 <= VAL[head_pointer_p1];
									RFData2Valid <= 1'b1;
									RFData2Address <= DEST[head_pointer_p1][4:0];
									READY[head_pointer_p1] <= 1'b0;
									RF2WriterTag <= head_pointer_p2_tag;
								end
								else
								begin
									//$fwrite(log_fd,"ARWRITING: tag=%b,value=%x,dest=%b\n",head_pointer_p2_tag,VAL[head_pointer_p1],DEST[head_pointer_p1][4:0]);
									VALID[head_pointer_p1]<=1'b0;
									RFData1 <= VAL[head_pointer_p1];
									RFData1Valid <= 1'b1;
									RFData1Address <= DEST[head_pointer_p1][4:0];
									READY[head_pointer_p1] <= 1'b0;
									RF1WriterTag <= head_pointer_p2_tag;
								end
							end
							//second commit successful now third commit
							if(READY[head_pointer_p2]==1'b1 && VALID[head_pointer_p2]==1'b1)
							begin
								if(ITYPE[head_pointer_p2]==ITYPE_BRANCH && VAL[head_pointer_p2]==0) //false speculation branch... now flush!
								begin
									READY<= 0;
									VALID<=0;
									//$fwrite(log_fd,"FLUSH dest=%x\n",DEST[head_pointer_p2]);
									//$fwrite(log_fd2,"FLUSH dest=%x\n",DEST[head_pointer_p2]);
									for(i=0;i<ROB_DEPTH;i=i+1)
									begin
										DEST[i] <= 0;
										VAL[i] <= 0;
										ITYPE[i] <=0;
									end
									head_pointer <= 0;
									empty_head <= 0;
									BTarget <= DEST[head_pointer_p2];
									flush <= 1'b1;
								end
								else
								begin
									head_pointer <= head_pointer_p3;
									if(ITYPE[head_pointer_p2]==ITYPE_BRANCH)	//right speculation branch
									begin
										//$fwrite(log_fd,"BRANCH TAKEN,val=%x,dest=%x\n",VAL[head_pointer_p2],DEST[head_pointer_p2]);
										VALID[head_pointer_p2]<=1'b0;
										READY[head_pointer_p2] <= 1'b0;
									end
									else if(ITYPE[head_pointer_p2]==ITYPE_STORE && memwrite_enable[2])
									begin
										//$fwrite(log_fd,"STORING:\n");	
										VALID[head_pointer_p2]<=1'b0;
										MemData <= VAL[head_pointer_p2];
										MemWe <= 1'b1;
										MemAddress <= DEST[head_pointer_p2];
										READY[head_pointer_p2] <= 1'b0;
									end
									else if(ITYPE[head_pointer_p2]==ITYPE_ARITHMETIC && regwrite_enable[2])
									begin
										if(regwrite[0] || regwrite[1])
										begin
											//$fwrite(log_fd,"ARWRITING: tag=%b,value=%x,dest=%b\n",head_pointer_p3_tag,VAL[head_pointer_p2],DEST[head_pointer_p2][4:0]);
											VALID[head_pointer_p2]<=1'b0;
											RFData2 <= VAL[head_pointer_p2];
											RFData2Valid <= 1'b1;
											RFData2Address <= DEST[head_pointer_p2][4:0];
											READY[head_pointer_p2] <= 1'b0;
											RF2WriterTag <= head_pointer_p3_tag;
										end
										else
										begin
											//$fwrite(log_fd,"ARWRITING: tag=%b,value=%x,dest=%b\n",head_pointer_p3_tag,VAL[head_pointer_p2],DEST[head_pointer_p2][4:0]);
											VALID[head_pointer_p2]<=1'b0;
											RFData1 <= VAL[head_pointer_p2];
											RFData1Valid <= 1'b1;
											RFData1Address <= DEST[head_pointer_p2][4:0];
											READY[head_pointer_p2] <= 1'b0;
											RF1WriterTag <= head_pointer_p3_tag;
										end
									end
									//third commit successful
								end
							end
						end 
					end
				end
				
			end

			
			
			
		end
	end
	
	//COMBINATIONAL
	always@(*)
	begin
		check_not_same = 1;
		for(i=0;i<ROB_DEPTH;i=i+1)
		begin
			if(ITYPE[i]==ITYPE_STORE && DEST[i]==LAddress && i+1<CDB3_tag && VALID[i]==1'b1)	//&&check_same
				check_not_same = 0;
		end
		
		empty_counter = !VALID[0]+!VALID[1]+!VALID[2]+!VALID[3]+!VALID[4]+!VALID[5]+!VALID[6]+!VALID[7];
		//who is going to write to RF
		regwrite[0] = (ITYPE[head_pointer]==ITYPE_ARITHMETIC)&&(VALID[head_pointer]==1'b1)&&(READY[head_pointer]==1'b1);
		regwrite[1] = (ITYPE[head_pointer_p1]==ITYPE_ARITHMETIC)&&(VALID[head_pointer_p1]==1'b1)&&(READY[head_pointer_p1]==1'b1);
		regwrite[2] = (ITYPE[head_pointer_p2]==ITYPE_ARITHMETIC)&&(VALID[head_pointer_p2]==1'b1)&&(READY[head_pointer_p2]==1'b1);
		//who is going to write to Mem
		memwrite[0] = (ITYPE[head_pointer]==ITYPE_STORE)&&(VALID[head_pointer]==1'b1)&&(READY[head_pointer]==1'b1);
		memwrite[1] = (ITYPE[head_pointer_p1]==ITYPE_STORE)&&(VALID[head_pointer_p1]==1'b1)&&(READY[head_pointer_p1]==1'b1);
		memwrite[2] = (ITYPE[head_pointer_p2]==ITYPE_STORE)&&(VALID[head_pointer_p2]==1'b1)&&(READY[head_pointer_p2]==1'b1);
		//who is allowed to write to RF
		regwrite_enable[0] = 1'b1;
		regwrite_enable[1] = 1'b1;
		regwrite_enable[2] = !(regwrite[0] & regwrite[1]);
		//who is allowed to write to Mem
		memwrite_enable[0] = 1'b1;
		memwrite_enable[1] = !(regwrite[0]);
		memwrite_enable[2] = !(regwrite[0] | regwrite[1]);
		
	end
endmodule 