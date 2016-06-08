
`timescale 1ns/1ns

module async_mem(
   input clk,
   input write,
   input [31:0] Raddress,
   input [31:0] Waddress,
   input [31:0] write_data,
   output [31:0] read_data
);


   reg [31:0] mem_data [0:1023];

   assign #7 read_data = mem_data[ Raddress[31:2] ];

   always @(posedge clk)
      if(write)
	  begin
         mem_data[ Waddress[31:2] ] <= #2 write_data;
		 //$display("Dmemwrite $%x = %x ", address, write_data);
	end
endmodule

