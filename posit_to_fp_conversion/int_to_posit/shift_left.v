`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2021 07:26:26 PM
// Design Name: 
// Module Name: shift_right
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


module shift_left(
in_data,
shift_amt,
out_data
    );
    
parameter N = 16;
parameter S = 4;

input  [N-1:0] in_data;
input  [S-1:0] shift_amt;
output [N-1:0] out_data;



wire [N-1:0] tmp [S-1:0];

assign tmp[0] = shift_amt[0] ? in_data << 7'd1 : in_data;
genvar i;


generate
    for (i =1 ;i<S ; i = i+1)
    begin
    
    assign tmp[i] = shift_amt[i] ? tmp[i-1] << 2**i : tmp[i-1];
    
    end

endgenerate

assign out_data = tmp[S-1];


endmodule
