It is a verilog implementation for a subset of MIPS instruction set done as course project for advanced computer architecture course. this implementation is dynamic scheduling and multiple issue.
this implementation is based on the method described in chap.3 of course book (using reservation stations, and reorder buffer) plus multiple issue capability,


module list:
1. MIPS.v : main module
2. decode.v : decoder module(issue logic)
3. RS_*.v : different kinds of reservation stations
4. ROB : reorder buffer
5. RF : register file (8 read ports,2 write ports, 4 tagging ports)
6. multi_cycle_mips_tb.v : provided testbench
7. Imem.v : instruction memory (fully combinational)
8. DMem.v : data memory (1 read port and 1 separate write port)
9. CU.v : opcode translation used by decode.v
10. ALU.v : alu used by integer reservation stations
11. IB.v : instruction buffer used for fetch  and stores waiting instructions.
12. isort32m.hex : code used for testing


mohammad hossein keshhavarz
