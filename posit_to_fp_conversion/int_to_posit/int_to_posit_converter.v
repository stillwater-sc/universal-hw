`timescale 1ns / 1ps

module int_to_posit_converter(
in,
out);

parameter N = 8;
parameter P = 16;
parameter INTM = P + 1;
parameter es = 0;
parameter S = 3;
parameter S_large = 5;


input [N-1:0] in;
output [P-1:0] out;


//Intermediate Variables


//Step 1;
wire [INTM-1 : 0] intm = 17'b11111111111111111;

wire [S-1:0] n ;

wire [N-1:0] shifted_in;
wire [N-1:0] shifted_intm;


wire [INTM-1:0] data;

//Step 2;
lod_master #(.N(N),.S(S)) l1 (in,n);

//Step 3
shift_left #(.N(N),.S(S)) ls1 (in,n,shifted_in);
assign shifted_intm = {1'b0, shifted_in[6:0]};

//Step 4
wire [N-1:0] and_1 = intm[7:0] & shifted_intm;
assign data = {intm[16:8],and_1};


//Step 5
wire [S_large-1:0] n_large  = n;
wire [INTM-1:0] shifted_data;
shift_left #(.N(INTM),.S(S_large)) ls2 (data,n_large,shifted_data);

//Step 6
wire [P-1:0] result_posit;
//Step 7
wire [P-1 : 0] result_posit_intm = 16'b0111111111111111;
//Step 8
wire [P-2:0] and_2 = result_posit_intm[14:0] & shifted_data[15:1];
assign out = (in != 0) ? {1'b0,and_2} : 0;

endmodule
