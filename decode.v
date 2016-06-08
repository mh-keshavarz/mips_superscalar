//decode module mostly combinational
module decode(

input [31:0] I1ib,
input [31:0] I2ib,
input [31:0] I3ib,
input [31:0] I4ib,
input I1ibValid,
input I2ibValid,
input I3ibValid,
input I4ibValid,
input [2:0]in_countib,
input [2:0]empty_countib,
input [4:0]empty_counterrob,
input [2:0]empty_head,
input rsi1Busy,
input rsi2Busy,
input rslBusy,
input rssBusy,
input [31:0]PC,

output reg rsi1INBusy,
output reg rsi2INBusy,
output reg rslINBusy,
output reg rssINBusy,
output reg [15:0]rsi1A,
output reg [15:0]rsi2A,
output reg [15:0]rslA,
output reg [15:0]rssA,
output reg [4:0]rsi1OP,
output reg [4:0]rsi2OP,
output reg [5:0]rsi1TAG,
output reg [5:0]rsi2TAG,
output reg [5:0]rslTAG,
output reg [5:0]rssTAG,
output reg [2:0]opType1rob,
output reg [2:0]opType2rob,
output reg [2:0]opType3rob,
output reg [2:0]opType4rob,
output reg [31:0]dest1rob,
output reg [31:0]dest2rob,
output reg [31:0]dest3rob,
output reg [31:0]dest4rob,
output reg instVal1rob,
output reg instVal2rob,
output reg instVal3rob,
output reg instVal4rob,

output reg [2:0]out_read_countib,//IMORTANT
output reg [31:0]PCNext,		//IMORTANT

output reg [2:0]reader1Address,
output reg [2:0]reader2Address,
output reg [2:0]reader3Address,
output reg [2:0]reader4Address,
output reg [4:0]RR1,
output reg [4:0]RR2,
output reg [4:0]RR3,
output reg [4:0]RR4,
output reg [4:0]RR5,
output reg [4:0]RR6,
output reg [4:0]RR7,
output reg [4:0]RR8,
output reg [4:0]RT1,
output reg [4:0]RT2,
output reg [4:0]RT3,
output reg [4:0]RT4,
output reg tag1,
output reg tag2,
output reg tag3,
output reg tag4,
output reg [5:0]T1,
output reg [5:0]T2,
output reg [5:0]T3,
output reg [5:0]T4,
output reg END
);
	//integer logfd;
	//initial logfd = $fopen("LOGDECODE.txt","w");
	parameter ITYPE_ARITHMETIC = 0;
	parameter ITYPE_BRANCH = 1;
	parameter ITYPE_STORE = 2;
	parameter ITYPE_LOAD = 3;
	
	wire [1:0]I1RSType;
	wire [2:0]I1Type;
	wire [1:0]I2RSType;
	wire [2:0]I2Type;
	wire [1:0]I3RSType;
	wire [2:0]I3Type;
	wire [1:0]I4RSType;
	wire [2:0]I4Type;
	reg [3:0]issue;
	reg [3:0]issuel;
	reg [3:0]issues;
	reg [3:0]issuei1;
	reg [3:0]issuei2;
	wire [4:0]RSI1OP;
	wire [4:0]RSI2OP;
	wire [4:0]RSI3OP;
	wire [4:0]RSI4OP;


	
	assign I1Type = (I1ib[31:26]==6'b000100 || I1ib[31:26]==6'b000101)? ITYPE_BRANCH:
					(I1ib[31:26]==6'b101011)? ITYPE_STORE:ITYPE_ARITHMETIC;
	assign I1RSType = 	(I1ib[31:26]==6'b101011)? ITYPE_STORE:
						(I1ib[31:26]==6'b100011)? ITYPE_LOAD:ITYPE_ARITHMETIC;
						
	assign I2Type = (I2ib[31:26]==6'b000100 || I2ib[31:26]==6'b000101)? ITYPE_BRANCH:
					(I2ib[31:26]==6'b101011)? ITYPE_STORE:ITYPE_ARITHMETIC;
	assign I2RSType = 	(I2ib[31:26]==6'b101011)? ITYPE_STORE:
						(I2ib[31:26]==6'b100011)? ITYPE_LOAD:ITYPE_ARITHMETIC;
						
	assign I3Type = (I3ib[31:26]==6'b000100 || I3ib[31:26]==6'b000101)? ITYPE_BRANCH:
					(I3ib[31:26]==6'b101011)? ITYPE_STORE:ITYPE_ARITHMETIC;
	assign I3RSType = 	(I3ib[31:26]==6'b101011)? ITYPE_STORE:
						(I3ib[31:26]==6'b100011)? ITYPE_LOAD:ITYPE_ARITHMETIC;
						
	assign I4Type = (I4ib[31:26]==6'b000100 || I4ib[31:26]==6'b000101)? ITYPE_BRANCH:
					(I4ib[31:26]==6'b101011)? ITYPE_STORE:ITYPE_ARITHMETIC;
	assign I4RSType = 	(I4ib[31:26]==6'b101011)? ITYPE_STORE:
						(I4ib[31:26]==6'b100011)? ITYPE_LOAD:ITYPE_ARITHMETIC;
	

	initial END = 1'b0;
	
	always@(*)
	begin
		//$fwrite(logfd,"rssTAG=%b,rssBusy=%b,empty_counterrob=%b,PC=%x\n",rssTAG,rssBusy,empty_counterrob,PC);
		//$fwrite(logfd,"rsi1Busy=%b,I1ibValid=%b,I1ib=%x,I1RSType=%b\n",rsi1Busy,I1ibValid,I1ib,I1RSType);
		//$fwrite(logfd,"rsi2Busy=%b,I2ibValid=%b,T1=%b\n\n",rsi2Busy,tag1,T1);
		issue = 4'b0000;
		issuel = 4'b0000;
		issues = 4'b0000;
		issuei1 = 4'b0000;
		issuei2 = 4'b0000;
		rslINBusy = 1'b0;
		rssINBusy = 1'b0;
		rsi1INBusy = 1'b0;
		rsi2INBusy = 1'b0;
		tag1 = 1'b0;
		tag2 = 1'b0;
		tag3 = 1'b0;
		tag4 = 1'b0;
		instVal1rob = 1'b0;
		instVal2rob = 1'b0;
		instVal3rob = 1'b0;
		instVal4rob = 1'b0;
		
		if(I1ibValid && empty_counterrob>0)
		begin
			if(I1RSType==ITYPE_LOAD && rslBusy==1'b0)
			begin
				//I1ib[20:16]==rt	dest
				//I1ib[15:0]==Imm
				//I1ib[25:21]==rs
				issue[0] = 1'b1;				
				issuel[0] = 1'b1;
				RR5 = I1ib[25:21];
				reader3Address = 3'b001;
				rslA = I1ib[15:0];
				rslINBusy = 1'b1;
				rslTAG = empty_head+1;
				tag1 = 1'b1;
				T1 = empty_head+1;
				RT1 = I1ib[20:16];
				instVal1rob = 1'b1;
				dest1rob = {27'b000000000000000000000000000,I1ib[20:16]};
				opType1rob = I1Type;
			end
			else if(I1RSType==ITYPE_STORE && rssBusy==1'b0 )
			begin
				//I1ib[20:16]==rt	dest
				//I1ib[15:0]==Imm
				//I1ib[25:21]==rs
				issue[0] = 1'b1;	
				issues[0] = 1'b1;				
				RR7 = I1ib[25:21]; //rs
				RR8 = I1ib[20:16]; //rt
				reader4Address = 3'b001;
				rssA = I1ib[15:0];
				rssINBusy = 1'b1;
				rssTAG = empty_head+1;
				tag1 = 1'b0;
				instVal1rob = 1'b1;
				opType1rob = I1Type;				
			end
			else if(I1RSType==ITYPE_ARITHMETIC && rsi1Busy==1'b0)
			begin
				//I1ib[20:16]==rt	dest
				//I1ib[25:21]==rs
				//I1ib[15:11]==rd dest
				//I1ib[5:0]==funct

				issue[0] = 1'b1;				
				issuei1[0] = 1'b1;
				RR1 = I1ib[25:21]; //rs
				RR2 = I1ib[20:16]; //rt
				reader1Address = 3'b001;
				rsi1A = I1ib[15:0];
				rsi1INBusy = 1'b1;
				rsi1TAG = empty_head+1;
				rsi1OP = RSI1OP;
				instVal1rob = 1'b1;
				if(I1Type!=ITYPE_BRANCH)
				begin
					dest1rob =(RSI1OP[4])? {27'b000000000000000000000000000,I1ib[20:16]}:{27'b000000000000000000000000000,I1ib[15:11]};
					tag1 = 1'b1;
					T1 = empty_head+1;
					RT1 =(RSI1OP[4])? I1ib[20:16]:I1ib[15:11];	
				end
				else
				begin
					dest1rob = PC -12 + {{14{I1ib[15]}},I1ib[15:0],{2'b00}};
					//$fwrite(logfd,"BARNCH DESTINATION: %x + %x = %x\n",PC-12,{{14{I1ib[15]}},I1ib[15:0],{2'b00}},dest1rob);					
					tag1 = 1'b0;					
				end
				opType1rob = I1Type;			
			end
			else if(I1RSType==ITYPE_ARITHMETIC && rsi2Busy==1'b0)
			begin
				//I1ib[20:16]==rt	dest
				//I1ib[25:21]==rs
				//I1ib[15:11]==rd dest
				//I1ib[5:0]==funct

				issue[0] = 1'b1;				
				issuei2[0] = 1'b1;
				RR3 = I1ib[25:21]; //rs
				RR4 = I1ib[20:16]; //rt
				reader2Address = 3'b001;
				rsi2A = I1ib[15:0];
				rsi2INBusy = 1'b1;
				rsi2TAG = empty_head+1;
				rsi2OP = RSI1OP;
				instVal1rob = 1'b1;
				if(I1Type!=ITYPE_BRANCH)
				begin
					dest1rob =(RSI1OP[4])? {27'b000000000000000000000000000,I1ib[20:16]}:{27'b000000000000000000000000000,I1ib[15:11]};
					tag1 = 1'b1;
					T1 = empty_head+1;
					RT1 =(RSI1OP[4])? I1ib[20:16]:I1ib[15:11];	
				end
				else
				begin
					dest1rob = PC-12+{{14{I1ib[15]}},I1ib[15:0],{2'b00}} ;
					//$fwrite(logfd,"BARNCH DESTINATION: %x + %x = %x\n",PC-12,{{14{I1ib[15]}},I1ib[15:0],{2'b00}},dest1rob);					
					tag1 = 1'b0;					
				end
				opType1rob = I1Type;
			end
		end
		//***********************************INST2
		
		
		
		if(I2ibValid && empty_counterrob>1 && issue[0]==1)
		begin
			if(I2RSType==ITYPE_LOAD && rslBusy==1'b0 && (!issuel[0]))
			begin
				//I1ib[20:16]==rt	dest
				//I1ib[15:0]==Imm
				//I1ib[25:21]==rs
				issue[1] = 1'b1;				
				issuel[1] = 1'b1;
				RR5 = I2ib[25:21];
				reader3Address = 3'b010;
				rslA = I2ib[15:0];
				rslINBusy = 1'b1;
				rslTAG = ((empty_head+1)<8)? (empty_head+2):(empty_head-6) ;		//IS TRUE?
				tag2 = 1'b1;
				T2 = ((empty_head+1)<8)? (empty_head+2):(empty_head-6) ;
				RT2 = I2ib[20:16];
				instVal2rob = 1'b1;
				dest2rob = {27'b000000000000000000000000000,I2ib[20:16]};
				opType2rob = I2Type;
			end
			else if(I2RSType==ITYPE_STORE && rssBusy==1'b0 && (!issues[0]))
			begin
				//I1ib[20:16]==rt	dest
				//I1ib[15:0]==Imm
				//I1ib[25:21]==rs
				issue[1] = 1'b1;	
				issues[1] = 1'b1;				
				RR7 = I2ib[25:21]; //rs
				RR8 = I2ib[20:16]; //rt
				reader4Address = 3'b010;
				rssA = I2ib[15:0];
				rssINBusy = 1'b1;
				rssTAG = ((empty_head+1)<8)? (empty_head+2):(empty_head-6);
				tag2 = 1'b0;
				instVal2rob = 1'b1;
				opType2rob = I2Type;				
				//$fwrite(logfd,"\nRR7=%x,RR8=%x,rssA=%x,rssINBusy=%x,rssTAG=%x\n",RR7,RR8,rssA,rssINBusy,rssTAG);
			end
			else if(I2RSType==ITYPE_ARITHMETIC && rsi1Busy==1'b0 && (!issuei1[0]))
			begin
				//I1ib[20:16]==rt	dest
				//I1ib[25:21]==rs
				//I1ib[15:11]==rd dest
				//I1ib[5:0]==funct
			
				issue[1] = 1'b1;				
				issuei1[1] = 1'b1;
				RR1 = I2ib[25:21]; //rs
				RR2 = I2ib[20:16]; //rt
				reader1Address = 3'b010;
				rsi1A = I2ib[15:0];
				rsi1INBusy = 1'b1;
				rsi1TAG = ((empty_head+1)<8)? (empty_head+2):(empty_head-6);
				rsi1OP = RSI2OP;
			
				instVal2rob = 1'b1;
				if(I2Type!=ITYPE_BRANCH)
				begin
					dest2rob =(RSI2OP[4])? {27'b000000000000000000000000000,I2ib[20:16]}:{27'b000000000000000000000000000,I2ib[15:11]};
					tag2 = 1'b1;
					T2 = ((empty_head+1)<8)? (empty_head+2):(empty_head-6);
					RT2 =(RSI2OP[4])? I2ib[20:16]:I2ib[15:11];		
				end
				else
				begin
					dest2rob = PC+4-12+{{14{I2ib[15]}},I2ib[15:0],{2'b00}};
					//$fwrite(logfd,"BARNCH DESTINATION: %x + %x = %x\n",PC+4-12,{{16{I2ib[15]}},I2ib[15:0]},dest2rob);
					tag2 = 1'b0;					
				end
				opType2rob = I2Type;			
			end
			else if(I2RSType==ITYPE_ARITHMETIC && rsi2Busy==1'b0 && (!issuei2[1:0]))
			begin
				//I1ib[20:16]==rt	dest
				//I1ib[25:21]==rs
				//I1ib[15:11]==rd dest
				//I1ib[5:0]==funct
		
				issue[1] = 1'b1;				
				issuei2[1] = 1'b1;
				RR3 = I2ib[25:21]; //rs
				RR4 = I2ib[20:16]; //rt
				reader2Address = 3'b010;
				rsi2A = I2ib[15:0];
				rsi2INBusy = 1'b1;
				rsi2TAG = ((empty_head+1)<8)? (empty_head+2):(empty_head-6);
				rsi2OP = RSI2OP;
				instVal2rob = 1'b1;
				if(I2Type!=ITYPE_BRANCH)
				begin
					dest2rob =(RSI2OP[4])? {27'b000000000000000000000000000,I2ib[20:16]}:{27'b000000000000000000000000000,I2ib[15:11]};
					tag2 = 1'b1;
					T2 = ((empty_head+1)<8)? (empty_head+2):(empty_head-6);
					RT2 =(RSI2OP[4])? I2ib[20:16]:I2ib[15:11];		
				end
				else
				begin
					dest2rob = PC+4-12+{{14{I2ib[15]}},I2ib[15:0],{2'b00}};
					//$fwrite(logfd,"BARNCH DESTINATION: %x + %x = %x\n",PC+4-12,{{16{I2ib[15]}},I2ib[15:0]},dest2rob);
					tag2 = 1'b0;					
				end
				opType2rob = I2Type;
			end
		end
		//*******************************************************INST3
		
		if(I3ibValid && empty_counterrob>2 && issue[1:0]==2'b11)
		begin
			if(I3RSType==ITYPE_LOAD && rslBusy==1'b0 && (!issuel[1:0]))
			begin
				//I1ib[20:16]==rt	dest
				//I1ib[15:0]==Imm
				//I1ib[25:21]==rs
				issue[2] = 1'b1;				
				issuel[2] = 1'b1;
				RR5 = I3ib[25:21];
				reader3Address = 3'b011;
				rslA = I3ib[15:0];
				rslINBusy = 1'b1;
				rslTAG = ((empty_head+2)<8)? (empty_head+3):(empty_head-5) ;		//IS TRUE?
				tag3 = 1'b1;
				T3 =  ((empty_head+2)<8)? (empty_head+3):(empty_head-5) ;		//IS TRUE?
				RT3 = I3ib[20:16];
				instVal3rob = 1'b1;
				dest3rob = {27'b000000000000000000000000000,I3ib[20:16]};
				opType3rob = I3Type;
			end
			else if(I3RSType==ITYPE_STORE && rssBusy==1'b0 && (!issues[1:0]))
			begin
				//I1ib[20:16]==rt	dest
				//I1ib[15:0]==Imm
				//I1ib[25:21]==rs
				issue[2] = 1'b1;	
				issues[2] = 1'b1;				
				RR7 = I3ib[25:21]; //rs
				RR8 = I3ib[20:16]; //rt
				reader4Address = 3'b011;
				rssA = I3ib[15:0];
				rssINBusy = 1'b1;
				rssTAG =  ((empty_head+2)<8)? (empty_head+3):(empty_head-5) ;		//IS TRUE?
				tag3 = 1'b0;
				instVal3rob = 1'b1;
				opType3rob = I3Type;				
			end
			else if(I3RSType==ITYPE_ARITHMETIC && rsi1Busy==1'b0 && (!issuei1[1:0]))
			begin
				//I1ib[20:16]==rt	dest
				//I1ib[25:21]==rs
				//I1ib[15:11]==rd dest
				//I1ib[5:0]==funct
			
				issue[2] = 1'b1;				
				issuei1[2] = 1'b1;
				RR1 = I3ib[25:21]; //rs
				RR2 = I3ib[20:16]; //rt
				reader1Address = 3'b011;
				rsi1A = I3ib[15:0];
				rsi1INBusy = 1'b1;
				rsi1TAG =  ((empty_head+2)<8)? (empty_head+3):(empty_head-5) ;		//IS TRUE?
				rsi1OP = RSI3OP;
			
				instVal3rob = 1'b1;
				if(I3Type!=ITYPE_BRANCH)
				begin
					dest3rob =(RSI3OP[4])? {27'b000000000000000000000000000,I3ib[20:16]}:{27'b000000000000000000000000000,I3ib[15:11]};
					tag3 = 1'b1;
					T3 =  ((empty_head+2)<8)? (empty_head+3):(empty_head-5) ;		//IS TRUE?
					RT3 =(RSI3OP[4])? I3ib[20:16]:I3ib[15:11];			
				end
				else
				begin
					dest3rob = PC+8-12+{{14{I3ib[15]}},I3ib[15:0],{2'b00}} ;
					//$fwrite(logfd,"BARNCH DESTINATION: %x + %x = %x\n",PC+8-12,{{16{I3ib[15]}},I3ib[15:0]},dest3rob);					
					tag3 = 1'b0;					
				end
				opType3rob = I3Type;			
			end
			else if(I3RSType==ITYPE_ARITHMETIC && rsi2Busy==1'b0 && (!issuei2[1:0]))
			begin
				//I1ib[20:16]==rt	dest
				//I1ib[25:21]==rs
				//I1ib[15:11]==rd dest
				//I1ib[5:0]==funct
		
				issue[2] = 1'b1;				
				issuei2[2] = 1'b1;
				RR3 = I3ib[25:21]; //rs
				RR4 = I3ib[20:16]; //rt
				reader2Address = 3'b011;
				rsi2A = I3ib[15:0];
				rsi2INBusy = 1'b1;
				rsi2TAG =  ((empty_head+2)<8)? (empty_head+3):(empty_head-5) ;		//IS TRUE?
				rsi2OP = RSI3OP;
				instVal3rob = 1'b1;
				if(I3Type!=ITYPE_BRANCH)
				begin
					dest3rob =(RSI3OP[4])? {27'b000000000000000000000000000,I3ib[20:16]}:{27'b000000000000000000000000000,I3ib[15:11]};
					tag3 = 1'b1;
					T3 =  ((empty_head+2)<8)? (empty_head+3):(empty_head-5) ;		//IS TRUE?
					RT3 =(RSI3OP[4])? I3ib[20:16]:I3ib[15:11];			
				end
				else
				begin
					dest3rob = PC+8-12+{{14{I3ib[15]}},I3ib[15:0],{2'b00}} ;
					//$fwrite(logfd,"BARNCH DESTINATION: %x + %x = %x\n",PC+8-12,{{16{I3ib[15]}},I3ib[15:0]},dest3rob);	
					tag3 = 1'b0;					
				end
				opType3rob = I3Type;
			end
		end		
		//*******************************************************INST4
		
		if(I4ibValid && empty_counterrob>3 && issue[2:0]==3'b111)
		begin
			if(I4RSType==ITYPE_LOAD && rslBusy==1'b0 && (!issuel[2:0]))
			begin
				//I1ib[20:16]==rt	dest
				//I1ib[15:0]==Imm
				//I1ib[25:21]==rs
		
				issue[3] = 1'b1;				
				issuel[3] = 1'b1;
				RR5 = I4ib[25:21];
				reader3Address = 3'b100;
				rslA = I4ib[15:0];
				rslINBusy = 1'b1;
				rslTAG = ((empty_head+3)<8)? (empty_head+4):(empty_head-4) ;		//IS TRUE?
				tag4 = 1'b1;
				T4 =  ((empty_head+3)<8)? (empty_head+4):(empty_head-4) ;			//IS TRUE?
				RT4 = I4ib[20:16];
				instVal4rob = 1'b1;
				dest4rob = {27'b000000000000000000000000000,I4ib[20:16]};
				opType4rob = I4Type;
			end
			else if(I4RSType==ITYPE_STORE && rssBusy==1'b0 && (!issues[2:0]))
			begin
				//I1ib[20:16]==rt	dest
				//I1ib[15:0]==Imm
				//I1ib[25:21]==rs
			
				issue[3] = 1'b1;	
				issues[3] = 1'b1;				
				RR7 = I4ib[25:21]; //rs
				RR8 = I4ib[20:16]; //rt
				reader4Address = 3'b100;
				rssA = I4ib[15:0];
				rssINBusy = 1'b1;
				rssTAG =  ((empty_head+3)<8)? (empty_head+4):(empty_head-4) ;			//IS TRUE?
				tag4 = 1'b0;
				instVal4rob = 1'b1;
				opType4rob = I4Type;				
			end
			else if(I4RSType==ITYPE_ARITHMETIC && rsi1Busy==1'b0 && (!issuei1[2:0]))
			begin
				//I1ib[20:16]==rt	dest
				//I1ib[25:21]==rs
				//I1ib[15:11]==rd dest
				//I1ib[5:0]==funct

				issue[3] = 1'b1;				
				issuei1[3] = 1'b1;
				RR1 = I4ib[25:21]; //rs
				RR2 = I4ib[20:16]; //rt
				reader1Address = 3'b100;
				rsi1A = I4ib[15:0];
				rsi1INBusy = 1'b1;
				rsi1TAG =  ((empty_head+3)<8)? (empty_head+4):(empty_head-4) ;			//IS TRUE?
				rsi1OP = RSI4OP;
			
				instVal4rob = 1'b1;
				if(I4Type!=ITYPE_BRANCH)
				begin
					dest4rob =(RSI4OP[4])? {27'b000000000000000000000000000,I4ib[20:16]}:{27'b000000000000000000000000000,I4ib[15:11]};
					tag4 = 1'b1;
					T4 =  ((empty_head+3)<8)? (empty_head+4):(empty_head-4) ;			//IS TRUE?
					RT4 =(RSI4OP[4])? I4ib[20:16]:I4ib[15:11];					
				end
				else
				begin
					dest4rob = PC+12-12+{{14{I4ib[15]}},I4ib[15:0],{2'b00}} ;
					//$fwrite(logfd,"BARNCH DESTINATION: %x + %x = %x\n",PC+12-12,{{14{I4ib[15]}},I4ib[15:0],{2'b00}},dest4rob);	
					tag4 = 1'b0;					
				end
				opType4rob = I4Type;			
			end
			else if(I4RSType==ITYPE_ARITHMETIC && rsi2Busy==1'b0 && (!issuei2[2:0]))
			begin
				//I1ib[20:16]==rt	dest
				//I1ib[25:21]==rs
				//I1ib[15:11]==rd dest
				//I1ib[5:0]==funct
				issue[3] = 1'b1;				
				issuei2[3] = 1'b1;
				RR3 = I4ib[25:21]; //rs
				RR4 = I4ib[20:16]; //rt
				reader2Address = 3'b100;
				rsi2A = I4ib[15:0];
				rsi2INBusy = 1'b1;
				rsi2TAG =  ((empty_head+3)<8)? (empty_head+4):(empty_head-4) ;		//IS TRUE?
				rsi2OP = RSI4OP;
				instVal4rob = 1'b1;
				if(I4Type!=ITYPE_BRANCH)
				begin
					dest4rob =(RSI4OP[4])? {27'b000000000000000000000000000,I4ib[20:16]}:{27'b000000000000000000000000000,I4ib[15:11]};
					tag4 = 1'b1;
					T4 =  ((empty_head+3)<8)? (empty_head+4):(empty_head-4) ;			//IS TRUE?
					RT4 =(RSI4OP[4])? I4ib[20:16]:I4ib[15:11];					
				end
				else
				begin
					dest4rob = PC+12-12+{{14{I4ib[15]}},I4ib[15:0],{2'b00}} ;
					//$fwrite(logfd,"BARNCH DESTINATION: %x + %x = %x \n",PC+12-12,{{14{I4ib[15]}},I4ib[15:0],{2'b00}},dest4rob);	
					tag4 = 1'b0;					
				end

				opType4rob = I4Type;
			end
		end				
		//_______________________________________________________________________________
		//$fwrite(logfd,"issue=%b,issuei1=%b,issuei2=%b,issuel=%b,issues=%b\n",issue,issuei1,issuei2,issuel,issues);
		out_read_countib <= issue[0]+issue[1]+issue[2]+issue[3];
		case(out_read_countib)
		3'b000:
			PCNext <= PC;
		3'b001:
			PCNext <= PC+4;
		3'b010:
			PCNext <= PC+8;
		3'b011:
			PCNext <= PC+12;
		3'b100:
			PCNext <= PC+16;
		default:
			PCNext <= PC;
		endcase
	end

	CU c1(
		.op(I1ib[31:26]),
		.funct(I1ib[5:0]),
		.RSOP(RSI1OP)
	);
	CU c2(
		.op(I2ib[31:26]),
		.funct(I2ib[5:0]),
		.RSOP(RSI2OP)	
	);
	CU c3(
		.op(I3ib[31:26]),
		.funct(I3ib[5:0]),
		.RSOP(RSI3OP)	
	);
	CU c4(
		.op(I4ib[31:26]),
		.funct(I4ib[5:0]),
		.RSOP(RSI4OP)	
	);	
endmodule 
