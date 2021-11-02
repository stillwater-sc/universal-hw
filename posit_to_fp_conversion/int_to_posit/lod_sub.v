`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2021 09:00:32 AM
// Design Name: 
// Module Name: lod_sub
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


module lod_sub(in,out,vld);

function [31:0] log2;
    input reg [31:0] value;
       begin
       value = value -1 ;
       for(log2 = 0; value > 0 ; log2 = log2 + 1)
        value = value >> 1;
        end
    endfunction


parameter N = 16;
parameter S = log2(N);

input [N-1:0] in;
output [S-1:0] out;
output vld;


generate 
if(N == 2)
    begin
        assign vld = |in;
        assign out = ~in[1] & in[0];
    end
//else if(N & (N-1))
//    lod_sub #(1<<S) LOD({1<<S {1'b0}}|in,out,vld);

else
begin

    wire [S-2 : 0] out_l,out_h;
    wire out_vl,out_vh;
    lod_sub #(N >> 1) l ( in[(N>>1)-1 : 0],out_l,out_vl);
    lod_sub #(N >>1)  h (in[N-1:N>>1],out_h,out_vh);
    assign vld = out_vl | out_vh;
    assign out = out_vh ? {1'b0,out_h} : {out_vl,out_l};
    
end
endgenerate
endmodule
