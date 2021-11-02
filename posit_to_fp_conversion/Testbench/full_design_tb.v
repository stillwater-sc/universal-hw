`timescale 1ns / 1ps


module full_design_tb();

  reg clk; //
  wire [31:0]final_output;
  wire output_valid;
  reg proc_done; // 
  reg [4:0]ra2;
  wire [31:0]rd2;
  reg reset;
  wire rout2;
  reg rvalid2; //Not used here.
  reg w_en;    //
  reg [4:0]  wa3; //
  reg [31:0] wd3; // 
  
  
  top_level_integration dut (clk,
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
  wd3);
      
      
always
begin
    clk = 0; #5;
    clk = ~clk; #5;

end


initial begin

reset = 0;
proc_done = 0;
rvalid2 = 0;
w_en = 0; #5;

w_en = 1;
wa3 = 0;
wd3 = 32'b01110001100011110000000000000000	; 
#10;
proc_done = 1;
w_en = 0;

#10;
proc_done = 0;
#40
w_en = 1;
wa3 = 0;
wd3 = 32'b01111011111111111111111010101001	; 
#10;
proc_done = 1;
w_en = 0;
#10;
proc_done = 0;





end
endmodule
