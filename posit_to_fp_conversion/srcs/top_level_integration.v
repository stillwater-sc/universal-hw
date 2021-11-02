`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2021 07:22:02 PM
// Design Name: 
// Module Name: top_level_integration
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_level_integration
(
clk,
reset,
final_output,
output_valid,
proc_done,
ra2,
rd2,
rout2,
rvalid2,
w_en,
wa3,
wd3
    );
    
parameter NUM_ADDRESS = 5;
parameter NUM_BITS = 32;
parameter NUM_REGISTERS = 2**NUM_ADDRESS;


 
input clk;

input reset;

output   [NUM_BITS-1 : 0] final_output;

output  output_valid;

input proc_done;

input w_en;
input  rvalid2;
input [NUM_BITS -1:0] wd3;
input [NUM_ADDRESS-1:0] ra2,wa3;
output rout2;
output [NUM_BITS-1:0] rd2;



wire rvalid;
wire [NUM_ADDRESS-1:0] ra1;

wire [NUM_BITS -1:0] rd1;

wire rout1;

register_reader_interface_module r1 (

.clk(clk),
.in_data(rd1),
.rvalid_in (rout1),
.final_output (final_output),
.addr (ra1),
.proc_done(proc_done),
.rvalid(rvalid),
.output_valid (output_valid) 

);

regfile registers (

.clk(clk),
.reset(reset),
.w_en(w_en),
.rvalid1(rvalid),
.rvalid2(rvalid2),
.wd3(wd3),
.ra1 (ra1),
.ra2(ra2),
.wa3(wa3),
.rout1(rout1),
.rout2(rout2),
.rd1(rd1),
.rd2(rd2)

);






endmodule
