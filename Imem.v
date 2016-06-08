
`timescale 1ns/1ns

module instr_mem(
   input [31:0] Raddress,
   output [31:0] read_data1,
   output [31:0] read_data2,
   output [31:0] read_data3,
   output [31:0] read_data4,
   output d1Valid,
   output d2Valid,
   output d3Valid,
   output d4Valid
);


   reg [31:0] mem_data [0:1023];

   assign #7 read_data1 = mem_data[ Raddress[31:2] ];
   assign #7 read_data2 = mem_data[ Raddress[31:2] +1];
   assign #7 read_data3 = mem_data[ Raddress[31:2] +2];
   assign #7 read_data4 = mem_data[ Raddress[31:2] +3];
   assign d1Valid = 1'b1;
   assign d2Valid = 1'b1;
   assign d3Valid = 1'b1;
   assign d4Valid = 1'b1;
   
   
endmodule

