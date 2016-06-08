
`timescale 1ns/100ps

`define DEBUG   // comment this line to disable register content writing below
				//needs adding tag bits and adding logic for writing reading and writing and reading tags!

module RF(
   input clk,
   input reset,
   input flush,
   
   input write1,
   input [4:0] WR1,
   input [5:0]Writer1Tag,
   input [31:0] WD1,
   input write2,
   input [4:0] WR2,
   input [5:0]Writer2Tag,
   input [31:0] WD2,  
   
   input [2:0]reader1Address,
   input [2:0]reader2Address,
   input [2:0]reader3Address,
   input [2:0]reader4Address,
   
   input [4:0] RR1,
   input [4:0] RR2,
   output  reg[31:0] RD1,
   output reg[5:0] RD1Tag,
   output reg[31:0] RD2,
   output reg[5:0] RD2Tag,   
   input [4:0] RR3,
   input [4:0] RR4,
   output reg[31:0] RD3,
   output reg[5:0] RD3Tag,
   output reg[31:0] RD4,
   output reg[5:0] RD4Tag,
   input [4:0] RR5,
   output reg[31:0] RD5,
   output reg[5:0] RD5Tag,   
   input [4:0] RR6,
   output reg[31:0] RD6,
   output reg[5:0] RD6Tag,   
   input [4:0] RR7,
   output reg[31:0] RD7,
   output reg[5:0] RD7Tag,   
   input [4:0] RR8,
   output reg[31:0] RD8,
   output reg[5:0] RD8Tag,   
   
   input [4:0]RT1,
   input tag1,
   input [5:0]T1,
   input [4:0]RT2,
   input tag2,
   input [5:0]T2,   
   input [4:0]RT3,
   input tag3,
   input [5:0]T3,
   input [4:0]RT4,
   input tag4,
   input [5:0]T4
);
	//integer logfd;
	//initial logfd = $fopen("LOGRF.txt","w");
	reg [31:0] rf_data [0:31];
	reg [5:0] rf_tags [0:31];
	
	wire [31:0]RB_data1;
	wire [31:0]RB_data2;    
	wire [31:0]RB_data3;
	wire [31:0]RB_data4;
	wire [31:0]RB_data5;
	wire [31:0]RB_data6;    
	wire [31:0]RB_data7;
	wire [31:0]RB_data8;
	
	assign RB_data1 = rf_data[ RR1 ];
	assign RB_data2 = rf_data[ RR2 ];
	assign RB_data3 = rf_data[ RR3 ];
	assign RB_data4 = rf_data[ RR4 ];
	assign RB_data5 = rf_data[ RR5 ];
	assign RB_data6 = rf_data[ RR6 ];
	assign RB_data7 = rf_data[ RR7 ];
	assign RB_data8 = rf_data[ RR8 ];		


	
	always@(*)
	begin
		RD1 = (rf_tags[ RR1 ]==0)? rf_data[ RR1 ]:
					(write1==1'b1 && RR1==WR1)? WD1:
					(write2==1'b1 && RR1==WR2)? WD2:rf_data[ RR1 ];
		RD2 = (rf_tags[ RR2 ]==0)? rf_data[ RR2 ]:
					(write1==1'b1 && RR2==WR1)? WD1:
					(write2==1'b1 && RR2==WR2)? WD2:rf_data[ RR2 ];
		RD3 = (rf_tags[ RR3 ]==0)? rf_data[ RR3 ]:
					(write1==1'b1 && RR3==WR1)? WD1:
					(write2==1'b1 && RR3==WR2)? WD2:rf_data[ RR3 ];
		RD4 = (rf_tags[ RR4 ]==0)? rf_data[ RR4 ]:
					(write1==1'b1 && RR4==WR1)? WD1:
					(write2==1'b1 && RR4==WR2)? WD2:rf_data[ RR4 ];
		RD5 = (rf_tags[ RR5 ]==0)? rf_data[ RR5 ]:
					(write1==1'b1 && RR5==WR1)? WD1:
					(write2==1'b1 && RR5==WR2)? WD2:rf_data[ RR5 ];
		RD6 = (rf_tags[ RR6 ]==0)? rf_data[ RR6 ]:
					(write1==1'b1 && RR6==WR1)? WD1:
					(write2==1'b1 && RR6==WR2)? WD2:rf_data[ RR6 ];
		RD7 = (rf_tags[ RR7 ]==0)? rf_data[ RR7 ]:
					(write1==1'b1 && RR7==WR1)? WD1:
					(write2==1'b1 && RR7==WR2)? WD2:rf_data[ RR7 ];
		RD8 = (rf_tags[ RR8 ]==0)? rf_data[ RR8 ]:
					(write1==1'b1 && RR8==WR1)? WD1:
					(write2==1'b1 && RR8==WR2)? WD2:rf_data[ RR8 ];

					//tagzani felmajles ro bayad lahaz kard alave bar write felmajles!
					//tagzani felmajles faqat baraye anha ke balatar az khanande hastand dar tartib barname bayad anjam shavad
		/*RD1Tag =( rf_tags[ RR1 ]==0)? rf_tags[ RR1 ]:
					(write1==1'b1 && RR1==WR1)? 0:
					(write2==1'b1 && RR1==WR2)? 0:rf_tags[ RR1 ];
		RD2Tag = (rf_tags[ RR2 ]==0)? rf_tags[ RR2 ]:
					(write1==1'b1 && RR2==WR1)? 0:
					(write2==1'b1 && RR2==WR2)? 0:rf_tags[ RR2 ];
		RD3Tag = (rf_tags[ RR3 ]==0)? rf_tags[ RR3 ]:
					(write1==1'b1 && RR3==WR1)? 0:
					(write2==1'b1 && RR3==WR2)? 0:rf_tags[ RR3 ];
		RD4Tag = (rf_tags[ RR4 ]==0)? rf_tags[ RR4 ]:
					(write1==1'b1 && RR4==WR1)? 0:
					(write2==1'b1 && RR4==WR2)? 0:rf_tags[ RR4 ];
		RD5Tag = (rf_tags[ RR5 ]==0)? rf_tags[ RR5 ]:
					(write1==1'b1 && RR5==WR1)? 0:
					(write2==1'b1 && RR5==WR2)? 0:rf_tags[ RR5 ];
		RD6Tag = (rf_tags[ RR6 ]==0)? rf_tags[ RR6 ]:
					(write1==1'b1 && RR6==WR1)? 0:
					(write2==1'b1 && RR6==WR2)? 0:rf_tags[ RR6 ];
		RD7Tag = (rf_tags[ RR7 ]==0)? rf_tags[ RR7 ]:
					(write1==1'b1 && RR7==WR1)? 0:
					(write2==1'b1 && RR7==WR2)? 0:rf_tags[ RR7 ];
		RD8Tag = (rf_tags[ RR8 ]==0)? rf_tags[ RR8 ]:
					(write1==1'b1 && RR8==WR1)? 0:
					(write2==1'b1 && RR8==WR2)? 0:rf_tags[ RR8 ];*/
		// RD1Tag
		if(tag3&&RT3==RR1&&reader1Address>3'b011)
			RD1Tag = T3;
		else if(tag2&&RT2==RR1&&reader1Address>3'b010)
			RD1Tag = T2;
		else if(tag1&&RT1==RR1&&reader1Address>3'b001)
			RD1Tag = T1;
		else
			RD1Tag =( rf_tags[ RR1 ]==0)? rf_tags[ RR1 ]:
					(write1==1'b1 && RR1==WR1)? 0:
					(write2==1'b1 && RR1==WR2)? 0:rf_tags[ RR1 ];
		// RD2Tag
		if(tag3&&RT3==RR2&&reader1Address>3'b011)
			RD2Tag = T3;
		else if(tag2&&RT2==RR2&&reader1Address>3'b010)
			RD2Tag = T2;
		else if(tag1&&RT1==RR2&&reader1Address>3'b001)
			RD2Tag = T1;
		else
			RD2Tag = (rf_tags[ RR2 ]==0)? rf_tags[ RR2 ]:
					(write1==1'b1 && RR2==WR1)? 0:
					(write2==1'b1 && RR2==WR2)? 0:rf_tags[ RR2 ];		
		// RD3Tag
		if(tag3&&RT3==RR3&&reader2Address>3'b011)
			RD3Tag = T3;
		else if(tag2&&RT2==RR3&&reader2Address>3'b010)
			RD3Tag = T2;
		else if(tag1&&RT1==RR3&&reader2Address>3'b001)
			RD3Tag = T1;
		else
			RD3Tag = (rf_tags[ RR3 ]==0)? rf_tags[ RR3 ]:
					(write1==1'b1 && RR3==WR1)? 0:
					(write2==1'b1 && RR3==WR2)? 0:rf_tags[ RR3 ];	
		// RD4Tag
		if(tag3&&RT3==RR4&&reader2Address>3'b011)
			RD4Tag = T3;
		else if(tag2&&RT2==RR4&&reader2Address>3'b010)
			RD4Tag = T2;
		else if(tag1&&RT1==RR4&&reader2Address>3'b001)
			RD4Tag = T1;
		else
			RD4Tag = (rf_tags[ RR4 ]==0)? rf_tags[ RR4 ]:
					(write1==1'b1 && RR4==WR1)? 0:
					(write2==1'b1 && RR4==WR2)? 0:rf_tags[ RR4 ];		

		// RD5Tag
		if(tag3&&RT3==RR5&&reader3Address>3'b011)
			RD5Tag = T3;
		else if(tag2&&RT2==RR5&&reader3Address>3'b010)
			RD5Tag = T2;
		else if(tag1&&RT1==RR5&&reader3Address>3'b001)
			RD5Tag = T1;
		else
			RD5Tag = (rf_tags[ RR5 ]==0)? rf_tags[ RR5 ]:
					(write1==1'b1 && RR5==WR1)? 0:
					(write2==1'b1 && RR5==WR2)? 0:rf_tags[ RR5 ];	
		// RD6Tag
		if(tag3&&RT3==RR6&&reader3Address>3'b011)
			RD6Tag = T3;
		else if(tag2&&RT2==RR6&&reader3Address>3'b010)
			RD6Tag = T2;
		else if(tag1&&RT1==RR6&&reader3Address>3'b001)
			RD6Tag = T1;
		else
			RD6Tag = (rf_tags[ RR6 ]==0)? rf_tags[ RR6 ]:
					(write1==1'b1 && RR6==WR1)? 0:
					(write2==1'b1 && RR6==WR2)? 0:rf_tags[ RR6 ];	

		// RD7Tags
		if(tag3&&RT3==RR7&&reader4Address>3'b011)
			RD7Tag = T3;
		else if(tag2&&RT2==RR7&&reader4Address>3'b010)
			RD7Tag = T2;
		else if(tag1&&RT1==RR7&&reader4Address>3'b001)
			RD7Tag = T1;
		else
			RD7Tag = (rf_tags[ RR7 ]==0)? rf_tags[ RR7 ]:
					(write1==1'b1 && RR7==WR1)? 0:
					(write2==1'b1 && RR7==WR2)? 0:rf_tags[ RR7 ];					
		// RD8Tags
		if(tag3&&RT3==RR8&&reader4Address>3'b011)
			RD8Tag = T3;
		else if(tag2&&RT2==RR8&&reader4Address>3'b010)
			RD8Tag = T2;
		else if(tag1&&RT1==RR8&&reader4Address>3'b001)
			RD8Tag = T1;
		else
			RD8Tag = (rf_tags[ RR8 ]==0)? rf_tags[ RR8 ]:
					(write1==1'b1 && RR8==WR1)? 0:
					(write2==1'b1 && RR8==WR2)? 0:rf_tags[ RR8 ];					
					
	end
				 
   integer i;
   always @(posedge clk) begin
	  if(!reset) begin
		for(i=0;i<32;i=i+1)
		begin
			rf_data[ i ] <= 0;
			rf_tags[ i ] <= 0;
		end
	  end
	  else begin 

		if(write1) begin
			//$fwrite(logfd,"write1,WR=%x,WD=%xWriter1Tag=%x\n",WR1,WD1,Writer1Tag);
			rf_data[ WR1 ] <= #0.1 WD1;
			if(Writer1Tag == rf_tags[WR1])
				rf_tags[ WR1 ] <= 0;	//moshkel dare---> bayad check she ke un ke minevise tagesh hamin bashe ta 0 she! + bayad check she kasi tu hamun cycle in ro tag nazane
		  end
		  if(write2) begin
			//$fwrite(logfd,"write2,WR=%x,WD=%x,Writer2Tag=%x\n",WR2,WD2,Writer2Tag);
			rf_data[ WR2 ] <= #0.1 WD2;
			if(Writer2Tag==rf_tags[WR2])
				rf_tags[ WR2 ] <= 0;	//moshkel dare---> bayad check she ke un ke minevise tagesh hamin bashe ta 0 she! + bayad check she kasi tu hamun cycle in ro tag nazane
		  end
		  
		  if(flush)
		  begin
			for(i=0;i<32;i=i+1)
			begin
				rf_tags[ i ] <= 0;
			end
		  end
		  else begin
						  //tagging IS IT TRUE?
		  //it is OK overwriting tagging of write if another on is issuing!
				  if(tag1) begin
					//$fwrite(logfd,"tag1,RT=%x,T=%b\n",RT1,T1);
					rf_tags [RT1] <= T1;
				  end
				  if(tag2) begin
					//$fwrite(logfd,"tag2,RT=%x,T=%b\n",RT2,T2);
					rf_tags [RT2] <= T2;
				  end
				  if(tag3) begin
					//$fwrite(logfd,"tag3,RT=%x,T=%b\n",RT3,T3);
					rf_tags [RT3] <= T3;
				  end
				  if(tag4) begin
					//$fwrite(logfd,"tag4,RT=%x,T=%b\n",RT4,T4);
					rf_tags [RT4] <= T4;
				  end
		  end


	  end
      rf_data[0] <= #0.1 32'h00000000;
		/*for(i=0;i<32;i=i+1)
		begin
			if(rf_data[i]!=0)
				//$fwrite(logfd,"rf_data[%d]=%x,rf_tags[%d]=%x\n",i,rf_data[i],i,rf_tags[i]);
		end
		//$fwrite(logfd,"\n");*/
   end

endmodule
