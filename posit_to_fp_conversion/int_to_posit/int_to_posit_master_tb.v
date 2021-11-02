`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2021 07:49:16 AM
// Design Name: 
// Module Name: int_to_posit_master_tb
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


module int_to_posit_master_tb();

parameter N = 8;
    parameter PS = 16;
    parameter ES = 0;
    parameter D = 8;
    parameter D_S = 3;
    

reg clk;
reg reset;
reg rx_axis_tvalid; //
reg [N-1 : 0] rx_axis_tdata; //
wire rx_axis_tready;

wire [PS-1:0]pipe_write_data;
wire pipe_write_req;
reg pipe_write_ack; //

int_to_posit_master dut (clk,
reset,
rx_axis_tvalid,
rx_axis_tdata,
rx_axis_tready,

pipe_write_data,
pipe_write_req,
pipe_write_ack);


always
begin
    clk = 0; #5;
    clk = ~clk; #5;

end


initial
begin
rx_axis_tvalid = 0;
reset = 0;
pipe_write_ack = 0;

#15;

rx_axis_tvalid = 1;
rx_axis_tdata = 10;

pipe_write_ack = 1;

#10;

rx_axis_tdata = 99;

#10;

rx_axis_tdata = 230;

#10;

rx_axis_tdata = 12;
#10;

rx_axis_tdata = 114;
#10;

rx_axis_tdata = 163;
#10;

rx_axis_tdata = 131;
#10;

rx_axis_tdata = 0;
#10;

rx_axis_tdata = 255;
#10;

rx_axis_tdata = 111;
#10;

rx_axis_tdata = 7;



end

endmodule
