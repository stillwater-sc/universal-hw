`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2021 09:02:32 AM
// Design Name: 
// Module Name: lod_master
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
/*


If input is 0 output is 0;

If output is all 1s like 16'd65535 then output is also 0;

The consumer module must be able to overcome this discrepancy.

Output contains position of Leading bit from MSB.
To fid position from MSB do ->   [[N-1 - out]]

*/

module lod_master(in,out);

function [31:0] log2;
    input reg [31:0] value;
       begin
       value = value -1 ;
       for(log2 = 0; value > 0 ; log2 = log2 + 1)
        value = value >> 1;
        end
    endfunction
    

parameter N = 64;
parameter S = log2(N);

input [N-1 : 0] in;
output [S-1 : 0] out;

wire vld;

lod_sub #(.N(N) ) l_1 (in,out,vld);

endmodule
