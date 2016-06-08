
`timescale 1ns/1ns

module multi_cycle_mips__tb(output reg clk,output reg reset,output wire [31:0]PCF,output wire PCSrcF,output wire [31:0]PCPlus4F);

   initial clk = 1;
   always @(clk)
      clk <= #5 ~clk;

   //reg reset;
   initial begin
      reset = 0;
      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
      #1;
      reset = 1;
   end

   initial
      $readmemh("isort32m.hex", uut.Imem.mem_data);

	  reg [15:0]clcounter;
   parameter end_pc = 32'h7C;
// parameter end_pc = 32'h30;
initial clcounter = 0;
   integer i;
   /*always @(uut.PCF)
   begin
	clcounter =clcounter + 1;
		$display("%x\n", uut.MRF.rf_data[8]);
      //if(uut.dec.END == 1'b1) begin
	  if(uut.MRF.rf_data[8]>=32'h00000180) begin
			//$display("salaaaaaaaam");
         for(i=0; i<96; i=i+1) begin
            $display("%x ", uut.Dmem.mem_data[32+i]); // 32+ for iosort32
            if(((i+1) % 16) == 0)
               $write("\n");
         end
         $stop;
      end
	end*/
   mips uut(
    .clk(clk),
    .reset(reset),
	.PCF(PCF)
   );


endmodule

