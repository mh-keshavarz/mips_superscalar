//this is mips!!!

module mips(
input clk,
input reset,
output reg [31:0]PCF
);

	/*integer logfd;
	initial logfd = $fopen("LOGMAIN.txt","w");
	integer logfdcdb;
	initial logfdcdb = $fopen("LOGCDB.txt","w");	*/
//__________________________________________________________________________MODULE SIGNALS
//1.1 RSI1
	wire [31:0]rsi1Vj;
	wire [5:0]rsi1Qj;
	wire [31:0]rsi1Vk;
	wire [5:0]rsi1Qk;	
	wire [4:0]rsi1Op;	
	wire [15:0]rsi1A;	
	wire [5:0]rsi1DestTag;	
	wire rsi1InBusy;
	wire RSI1BUSY;
	wire rsi1Flush;
//1.1 RSI2
	wire [31:0]rsi2Vj;
	wire [5:0]rsi2Qj;
	wire [31:0]rsi2Vk;
	wire [5:0]rsi2Qk;	
	wire [4:0]rsi2Op;	
	wire [15:0]rsi2A;	
	wire [5:0]rsi2DestTag;	
	wire rsi2InBusy;
	wire RSI2BUSY;	
	wire rsi2Flush;
//1.1 RSL
	wire [31:0]rslVj;
	wire [5:0]rslQj;
	wire [31:0]rslVk;
	wire [5:0]rslQk;	
	wire [4:0]rslOp;	
	wire [15:0]rslA;	
	wire [5:0]rslDestTag;	
	wire rslInBusy;
	wire RSLBUSY;	
	wire rslFlush;
//1.1 RSS
	wire [31:0]rssVj;
	wire [5:0]rssQj;
	wire [31:0]rssVk;
	wire [5:0]rssQk;	
	wire [4:0]rssOp;	
	wire [15:0]rssA;	
	wire [5:0]rssDestTag;	
	wire rssInBusy;
	wire RSSBUSY;	
	wire rssFlush;
//2 MRF
	wire mrfFlush;
	wire mrfWrite1;
	wire [4:0] mrfWR1;
	wire [31:0]mrfWD1;
	wire mrfWrite2;
	wire [4:0]mrfWR2;
	wire [31:0]mrfWD2; 
	wire [4:0]mrfRR1;
	wire [4:0]mrfRR2;
	wire [31:0]mrfRD1;
	wire [5:0]mrfRD1Tag;
	wire [31:0]mrfRD2;
	wire [5:0]mrfRD2Tag;
	wire [4:0]mrfRR3;
	wire [4:0]mrfRR4;
	wire [31:0]mrfRD3;
	wire [5:0]mrfRD3Tag;
	wire [31:0]mrfRD4;
	wire [5:0]mrfRD4Tag;
	wire [4:0]mrfRR5;
	wire [31:0]mrfRD5;
	wire [5:0]mrfRD5Tag;
	wire [4:0]mrfRR6;
	wire [31:0]mrfRD6;
	wire [5:0]mrfRD6Tag;   
	wire [4:0]mrfRR7;
	wire [31:0]mrfRD7;
	wire [5:0]mrfRD7Tag;
	wire [4:0]mrfRR8;
	wire [31:0]mrfRD8;
	wire [5:0]mrfRD8Tag;
	wire [4:0]mrfRT1;
	wire mrfTag1;
	wire [5:0]mrfT1;
	wire [4:0]mrfRT2;
	wire mrfTag2;
	wire [5:0]mrfT2;
	wire [4:0]mrfRT3;
	wire mrfTag3;
	wire [5:0]mrfT3;
	wire [4:0]mrfRT4;
	wire mrfTag4;
	wire [5:0]mrfT4;
	wire [2:0]reader1Address;
	wire [2:0]reader2Address;
	wire [2:0]reader3Address;
	wire [2:0]reader4Address;
//3 MROB	
	wire [2:0]robInst1Type;
	wire [31:0]robInst1Dest;
	wire [31:0]robInst1Val;
	wire robInst1Ready;
	wire robInst1Dval;
	wire [2:0]robInst2Type;
	wire [31:0]robInst2Dest;
	wire [31:0]robInst2Val;
	wire robInst2Ready;
	wire robInst2Dval;
	wire [2:0]robInst3Type;
	wire [31:0]robInst3Dest;
	wire [31:0]robInst3Val;
	wire robInst3Ready;
	wire robInst3Dval;
	wire [2:0]robInst4Type;
	wire [31:0]robInst4Dest;	
	wire [31:0]robInst4Val;
	wire robInst4Ready;
	wire robInst4Dval;
	wire [5:0]RF1WriterTag;
	wire [5:0]RF2WriterTag;
	
	wire robCheckSame;
	wire robCheckNSame;
	wire [4:0]robEmptyCounter;
	wire [2:0]robEmptyHead;
	wire [31:0]robRFData1;
	wire [4:0]robRFData1Address;
	wire robRFData1Valid;
	wire [31:0]robRFData2;
	wire [4:0]robRFData2Address;
	wire robRFData2Valid;
	wire robMemWe;
	wire [31:0]robMemAddress;
	wire [31:0]robMemData;
	wire robFlush;
	wire [31:0]LAddress;
//4 IB
	wire ibFlush;
	wire [31:0]ibIin1;
	wire ibIin1Valid;
	wire [31:0]ibIin2;
	wire ibIin2Valid;
	wire [31:0]ibIin3;
	wire ibIin3Valid;
	wire [31:0]ibIin4;
	wire ibIin4Valid;
	wire [2:0]ibOutCount;
	wire [31:0]ibOut1;
	wire ibOut1Valid;
	wire [31:0]ibOut2;
	wire ibOut2Valid;
	wire [31:0]ibOut3;
	wire ibOut3Valid;
	wire [31:0]ibOut4;
	wire ibOut4Valid;
	wire [2:0]ibInCount;
	wire [2:0]ibEmptyCount;
	
	wire DmemWrite;
	wire [31:0]DmemRAddress;
	wire [31:0]DmemWAddress;
	wire [31:0]DmemWData;
	wire [31:0]DmemRData;
	
	
	wire [31:0]decPCNext;
	wire [31:0]BTarget;
	
//5 CDB BUSES	
	wire [31:0]CDB1_data;
	wire [5:0] CDB1_tag;
	wire CDB1_ready;
	wire [31:0]CDB2_data;
	wire [5:0] CDB2_tag;
	wire CDB2_ready;	
	wire [31:0]CDB3_data;
	wire [5:0] CDB3_tag;
	wire CDB3_ready;	
	wire [31:0]CDB4_data;
	wire [31:0]CDB4_address;
	wire [5:0] CDB4_tag;
	wire CDB4_ready;		
// CDB CHECK FOR LOADS	
	wire address_neq_stores;
	wire address_check;
	
	wire RSreset;
	integer i;
//__________________________________________________________________________MODULE SIGNALS

//__________________________________________________________________________SIGNAL WIRINGS
//CDB CONNECTIONS MADE...
// connectiong ROB outputs to RF and Memory
	assign mrfWD1 = robRFData1;
	assign mrfWR1 = robRFData1Address;
	assign mrfWrite1 = robRFData1Valid;

	assign mrfWD2 = robRFData2;
	assign mrfWR2 = robRFData2Address;
	assign mrfWrite2 = robRFData2Valid;

	assign DmemWrite = robMemWe;
	assign DmemWData = robMemData;
	assign DmemWAddress = robMemAddress;
//connecting rfile outputs to RSs inputs
	//rsi1
	assign rsi1Qj = mrfRD1Tag;
	assign rsi1Qk = mrfRD2Tag;
	assign rsi1Vj = mrfRD1;
	assign rsi1Vk = mrfRD2;	
	//rsi2
	assign rsi2Qj = mrfRD3Tag;
	assign rsi2Qk = mrfRD4Tag;
	assign rsi2Vj = mrfRD3;
	assign rsi2Vk = mrfRD4;
	//rsl
	assign rslQj = mrfRD5Tag;
	assign rslQk = mrfRD6Tag;
	assign rslVj = mrfRD5;
	assign rslVk = mrfRD6;	
	//rss
	assign rssQj = mrfRD7Tag;
	assign rssQk = mrfRD8Tag;
	assign rssVj = mrfRD7;
	assign rssVk = mrfRD8;
//connectiong store address checking signals
	assign robCheckSame = address_check;
	assign address_neq_stores = robCheckNSame;
	
	
	assign ibFlush = robFlush;
	assign mrfFlush = robFlush;
	//assign RSreset = reset & !(robFlush); //robFlush==1 or reset==0
	assign RSreset = reset;
	assign rsi1Flush = robFlush;
	assign rsi2Flush = robFlush;
	assign rslFlush = robFlush;
	assign rssFlush = robFlush;
	
	assign robInst1Ready = 1'b0;
	assign robInst2Ready = 1'b0;
	assign robInst3Ready = 1'b0;
	assign robInst4Ready = 1'b0;
	
	assign robInst1Val = 0;
	assign robInst2Val = 0;
	assign robInst3Val = 0;
	assign robInst4Val = 0;
//__________________________________________________________________________SIGNAL WIRINGS 
	always@(posedge clk)
	begin
		if(!reset)
			PCF <= 0;
		else if(robFlush)
			PCF <= BTarget;
		else
			//PCF <= decPCNext;
			PCF <= PCF+(ibInCount<<2);
		//$fwrite(logfd,"Instr0=%x, Instr1=%x, Instr2=%x, Instr3=%x,ibInCount=%x,robEmptyCounter=%x,robFlush=%x,PCNxt=%x\n",ibOut1,ibOut2,ibOut3,ibOut4,ibInCount,robEmptyCounter,robFlush,decPCNext);	
		//$//fwrite(logfd,"rssINBusy=%b,rssQj=%b,rssQk=%b,rssVj=%x,rssVk=%x,rssDestTag=%x,mrfRD7Tag=%x,mrfRD7=%x,mrfRR7=%x,mrfRD8Tag=%x,mrfRD8=%x,mrfRR8=%x\n",
		//				rssInBusy,rssQj,rssQk,rssVj,rssVk,rssDestTag,mrfRD7Tag,mrfRD7,mrfRR7,mrfRD8Tag,mrfRD8,mrfRR8);
		
		//if(CDB1_ready==1'b1)
			//fwrite(logfdcdb,"CDB1_data=%x,CDB1_tag=%x\n",CDB1_data,CDB1_tag);
		//if(CDB2_ready==1'b1)
			//fwrite(logfdcdb,"CDB2_data=%x,CDB2_tag=%x\n",CDB2_data,CDB2_tag);			
		//if(CDB3_ready==1'b1)
			//fwrite(logfdcdb,"CDB3_data=%x,CDB3_tag=%x,LAddress=%x\n",CDB3_data,CDB3_tag,LAddress);		
		//if(CDB4_ready==1'b1)
			//fwrite(logfdcdb,"CDB4_data=%x,CDB4_tag=%b,CDB4_address=%x\n",CDB4_data,CDB4_tag,CDB4_address);	
		if(robFlush && BTarget==32'h78)
		begin
			 for(i=0; i<96; i=i+1) begin
            $display("%x ", uut.Dmem.mem_data[32+i]); // 32+ for iosort32
            if(((i+1) % 16) == 0)
               $write("\n");
			end
			$stop;
		end
	end
	/*always@(rsi2A)
	begin
		$fwrite(logfd,"rsi2A=%x,rsi2Vj=%x,rsi2Vk=%x,mrfRR3=%x,mrfRR4=%x\n",rsi2A,rsi2Vj,rsi2Vk,mrfRR3,mrfRR4);				
	end
	always@(rsi1A)
	begin
		$fwrite(logfd,"rsi1A=%x,rsi1Vj=%x,rsi1Vk=%x,mrfRR1=%x,mrfRR1=%x\n",rsi1A,rsi1Vj,rsi1Vk,mrfRR1,mrfRR2);			
	end*/
//__________________________________________________________________________MODULES
//1. RESERVATION STATIONS:
//1.1 INTEGER RS1

RS RSI1(
	.clk(clk),
	.reset(RSreset),	//active low synchronous
	.flush(rsi1Flush),
	.Vj(rsi1Vj),
	.Qj(rsi1Qj),
	.Vk(rsi1Vk),
	.Qk(rsi1Qk),
	.op(rsi1Op),
	.A(rsi1A),
	.in_tag(rsi1DestTag),
	.in_busy(rsi1InBusy),
					
	.CDB1_data(CDB2_data),
	.CDB1_ready(CDB2_ready),
	.CDB1_tag(CDB2_tag),
	.CDB2_data(CDB3_data),
	.CDB2_ready(CDB3_ready),
	.CDB2_tag(CDB3_tag),	
	.CDB3_data(CDB1_data),
	.CDB3_ready(CDB1_ready),
	.CDB3_tag(CDB1_tag),
	
	.READY(CDB1_ready),
	.out_TAG(CDB1_tag),
	.out_DATA(CDB1_data),	
	.busy(RSI1BUSY)
);
//1.2 INTEGER RS2
RS RSI2(
	.clk(clk),
	.reset(RSreset),	//active low synchronous
	.flush(rsi2Flush),
	.Vj(rsi2Vj),
	.Qj(rsi2Qj),
	.Vk(rsi2Vk),
	.Qk(rsi2Qk),
	.op(rsi2Op),
	.A(rsi2A),
	.in_tag(rsi2DestTag),
	.in_busy(rsi2InBusy),	
					
	.CDB1_data(CDB1_data),
	.CDB1_ready(CDB1_ready),
	.CDB1_tag(CDB1_tag),
	.CDB2_data(CDB3_data),
	.CDB2_ready(CDB3_ready),
	.CDB2_tag(CDB3_tag),	
	.CDB3_data(CDB2_data),
	.CDB3_ready(CDB2_ready),
	.CDB3_tag(CDB2_tag),
	
	.READY(CDB2_ready),
	.out_TAG(CDB2_tag),
	.out_DATA(CDB2_data),	
	.busy(RSI2BUSY)
);
//1.3 LOAD RS
RS_load RSL(
	.clk(clk),
	.reset(RSreset),	//active low synchronous
	.flush(rslFlush),
	.Vj(rslVj),
	.Qj(rslQj),
	.Vk(rslVk),
	.Qk(rslQk),
	.op(rslOp),
	.A(rslA),
	.in_tag(rslDestTag),
	.address_neq_stores(address_neq_stores),
	.in_busy(rslInBusy),	
					
	.CDB1_data(CDB1_data),
	.CDB1_ready(CDB1_ready),
	.CDB1_tag(CDB1_tag),
	.CDB2_data(CDB2_data),
	.CDB2_ready(CDB2_ready),
	.CDB2_tag(CDB2_tag),	
	
	.READY(CDB3_ready),
	.address_check(address_check),
	.out_TAG(CDB3_tag),
	.out_DATA(LAddress),	//or load address
	.busy(RSLBUSY)
);

//1.4 STORE RS
RS_store RSS(
	.clk(clk),
	.reset(RSreset),	//active low synchronous
	.flush(rssFlush),
	.Vj(rssVj),
	.Qj(rssQj),
	.Vk(rssVk),
	.Qk(rssQk),
	.op(rssOp),
	.A(rssA),
	.in_tag(rssDestTag),
	.in_busy(rssInBusy),	
					
	.CDB1_data(CDB1_data),
	.CDB1_ready(CDB1_ready),
	.CDB1_tag(CDB1_tag),
	.CDB2_data(CDB2_data),
	.CDB2_ready(CDB2_ready),
	.CDB2_tag(CDB2_tag),	
	.CDB3_data(CDB3_data),
	.CDB3_ready(CDB3_ready),
	.CDB3_tag(CDB3_tag),
	
	.READY(CDB4_ready),
	.out_TAG(CDB4_tag),
	.out_DATA(CDB4_data),	
	.out_ADDRESS(CDB4_address),
	.busy(RSSBUSY)
);

//2. RF
RF  MRF(
   .clk(clk),
   .reset(reset),
   .flush(mrfFlush),
   
   .write1(mrfWrite1),
   .WR1(mrfWR1),
   .Writer1Tag(RF1WriterTag),
   .WD1(mrfWD1),
   .write2(mrfWrite2),
   .WR2(mrfWR2),
   .Writer2Tag(RF2WriterTag),
   .WD2(mrfWD2),  
   
   
   
   .reader1Address(reader1Address),
   .reader2Address(reader2Address),
   .reader3Address(reader3Address),
   .reader4Address(reader4Address),
   .RR1(mrfRR1),
   .RR2(mrfRR2),
   .RD1(mrfRD1),
   .RD1Tag(mrfRD1Tag),
   .RD2(mrfRD2),
   .RD2Tag(mrfRD2Tag),   
   .RR3(mrfRR3),
   .RR4(mrfRR4),
   .RD3(mrfRD3),
   .RD3Tag(mrfRD3Tag),
   .RD4(mrfRD4),
   .RD4Tag(mrfRD4Tag),
   .RR5(mrfRR5),
   .RD5(mrfRD5),
   .RD5Tag(mrfRD5Tag),   
   .RR6(mrfRR6),
   .RD6(mrfRD6),
   .RD6Tag(mrfRD6Tag),   
   .RR7(mrfRR7),
   .RD7(mrfRD7),
   .RD7Tag(mrfRD7Tag),   
   .RR8(mrfRR8),
   .RD8(mrfRD8),
   .RD8Tag(mrfRD8Tag),   
   
   .RT1(mrfRT1),
   .tag1(mrfTag1),
   .T1(mrfT1),
   .RT2(mrfRT2),
   .tag2(mrfTag2),
   .T2(mrfT2),   
   .RT3(mrfRT3),
   .tag3(mrfTag3),
   .T3(mrfT3),
   .RT4(mrfRT4),
   .tag4(mrfTag4),
   .T4(mrfT4)
);

ROB MROB(
	.clk(clk),
	.reset(reset),	
	.InInst1Type(robInst1Type),
	.InInst1Dest(robInst1Dest),
	.InInst1Val(robInst1Val),
	.InInst1Ready(robInst1Ready),
	.InInst1DataValid(robInst1Dval),
	.InInst2Type(robInst2Type),
	.InInst2Dest(robInst2Dest),
	.InInst2Val(robInst2Val),
	.InInst2Ready(robInst2Ready),
	.InInst2DataValid(robInst2Dval),
	.InInst3Type(robInst3Type),
	.InInst3Dest(robInst3Dest),
	.InInst3Val(robInst3Val),
	.InInst3Ready(robInst3Ready),
	.InInst3DataValid(robInst3Dval),
	.InInst4Type(robInst4Type),
	.InInst4Dest(robInst4Dest),	
	.InInst4Val(robInst4Val),	
	.InInst4Ready(robInst4Ready),
	.InInst4DataValid(robInst4Dval),
	.CDB1_data(CDB1_data),
	.CDB1_ready(CDB1_ready),
	.CDB1_tag(CDB1_tag),
	.CDB2_data(CDB2_data),
	.CDB2_ready(CDB2_ready),
	.CDB2_tag(CDB2_tag),
	.CDB3_data(CDB3_data),
	.CDB3_ready(CDB3_ready),
	.CDB3_tag(CDB3_tag),
	.LAddress(LAddress),	
	.CDB4_data(CDB4_data),
	.CDB4_address(CDB4_address),
	.CDB4_ready(CDB4_ready),
	.CDB4_tag(CDB4_tag),
	.check_same(robCheckSame),
	.check_not_same(robCheckNSame),
	.empty_counter(robEmptyCounter),	
	.empty_head(robEmptyHead),
	.RFData1(robRFData1),
	.RFData1Address(robRFData1Address),
	.RFData1Valid(robRFData1Valid),
	.RF1WriterTag(RF1WriterTag),
	.RFData2(robRFData2),
	.RFData2Address(robRFData2Address),
	.RFData2Valid(robRFData2Valid),
	.RF2WriterTag(RF2WriterTag),
	.MemWe(robMemWe),	
	.MemAddress(robMemAddress),
	.MemData(robMemData),
	.flush(robFlush),
	.BTarget(BTarget)
);

//4 INSTRUCTION BUFFER
IF IB(
	.clk(clk),
	.reset(reset),
	.flush(ibFlush),
	.Iin1(ibIin1),
	.Iin1Valid(ibIin1Valid),
	.Iin2(ibIin2),
	.Iin2Valid(ibIin2Valid),
	.Iin3(ibIin3),
	.Iin3Valid(ibIin3Valid),
	.Iin4(ibIin4),
	.Iin4Valid(ibIin4Valid),
	
	.out_read_count(ibOutCount),
	.Iout1(ibOut1),
	.Iout1Valid(ibOut1Valid),
	.Iout2(ibOut2),
	.Iout2Valid(ibOut2Valid),
	.Iout3(ibOut3),
	.Iout3Valid(ibOut3Valid),
	.Iout4(ibOut4),
	.Iout4Valid(ibOut4Valid),
	.in_count(ibInCount),
	.empty_count(ibEmptyCount)
);

async_mem Dmem(
   .clk(clk),
   .write(DmemWrite),
   .Raddress(LAddress),
   .Waddress(DmemWAddress),
   .write_data(DmemWData),
   .read_data(CDB3_data)
);

instr_mem Imem(
   .Raddress(PCF),
   .read_data1(ibIin1),
   .read_data2(ibIin2),
   .read_data3(ibIin3),
   .read_data4(ibIin4),
   .d1Valid(ibIin1Valid),
   .d2Valid(ibIin2Valid),
   .d3Valid(ibIin3Valid),
   .d4Valid(ibIin4Valid)
);

decode dec(

.I1ib(ibOut1),
.I2ib(ibOut2),
.I3ib(ibOut3),
.I4ib(ibOut4),
.I1ibValid(ibOut1Valid),
.I2ibValid(ibOut2Valid),
.I3ibValid(ibOut3Valid),
.I4ibValid(ibOut4Valid),
.in_countib(ibInCount),
.empty_countib(ibEmptyCount),
.empty_counterrob(robEmptyCounter),
.empty_head(robEmptyHead),
.rsi1Busy(RSI1BUSY),
.rsi2Busy(RSI2BUSY),
.rslBusy(RSLBUSY),
.rssBusy(RSSBUSY),
.PC(PCF),

.rsi1INBusy(rsi1InBusy),
.rsi2INBusy(rsi2InBusy),
.rslINBusy(rslInBusy),
.rssINBusy(rssInBusy),
.rsi1A(rsi1A),
.rsi2A(rsi2A),
.rslA(rslA),
.rssA(rssA),
.rsi1OP(rsi1Op),
.rsi2OP(rsi2Op),
.rsi1TAG(rsi1DestTag),
.rsi2TAG(rsi2DestTag),
.rslTAG(rslDestTag),
.rssTAG(rssDestTag),
.opType1rob(robInst1Type),
.opType2rob(robInst2Type),
.opType3rob(robInst3Type),
.opType4rob(robInst4Type),
.dest1rob(robInst1Dest),
.dest2rob(robInst2Dest),
.dest3rob(robInst3Dest),
.dest4rob(robInst4Dest),
.instVal1rob(robInst1Dval),
.instVal2rob(robInst2Dval),
.instVal3rob(robInst3Dval),
.instVal4rob(robInst4Dval),

.out_read_countib(ibOutCount),//IMORTANT
.PCNext(decPCNext),		//IMORTANT
.reader1Address(reader1Address),
.reader2Address(reader2Address),
.reader3Address(reader3Address),
.reader4Address(reader4Address),
.RR1(mrfRR1),
.RR2(mrfRR2),
.RR3(mrfRR3),
.RR4(mrfRR4),
.RR5(mrfRR5),
.RR6(mrfRR6),
.RR7(mrfRR7),
.RR8(mrfRR8),
.RT1(mrfRT1),
.RT2(mrfRT2),
.RT3(mrfRT3),
.RT4(mrfRT4),
.tag1(mrfTag1),
.tag2(mrfTag2),
.tag3(mrfTag3),
.tag4(mrfTag4),
.T1(mrfT1),
.T2(mrfT2),
.T3(mrfT3),
.T4(mrfT4)
);

//__________________________________________________________________________MODULES
endmodule 