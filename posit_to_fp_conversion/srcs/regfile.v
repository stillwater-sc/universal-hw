`timescale 1ns / 1ps


module regfile
#(
parameter NUM_ADDRESS = 5,
parameter NUM_BITS = 32,
parameter NUM_REGISTERS = 2**NUM_ADDRESS
)
(

input clk,
input reset,
input w_en,
input  rvalid1,rvalid2,
input [NUM_BITS -1:0] wd3,
input [NUM_ADDRESS-1:0] ra1,ra2,wa3,
output reg  rout1,rout2,
output [NUM_BITS-1:0] rd1,rd2

);

reg r1_recv,r2_recv;
reg [NUM_BITS-1:0] registers[NUM_REGISTERS-1:0];

integer loop_count;

always@(posedge clk)
begin

    if(!reset)
        begin
            if(rvalid1 == 1)
            begin
                r1_recv = 1;
                rout1 = rvalid1;
            end
            else
                begin
                    r1_recv = 0;
                    rout1 = 0;
                        
                end
            if(rvalid2 == 1)
            begin
                r2_recv = 1;
                rout2 = rvalid2;
            end
            else
                begin
                r2_recv = 0;
                rout2 = 0;
            
            end
            
            if(w_en == 1)
            begin
                registers[wa3] <= wd3;
            end
        
        end
    
    else
    begin
        loop_count = 0;
        for (loop_count = 0;loop_count < 32 ; loop_count = loop_count + 1 )
        begin
            
            registers[loop_count] <= 0;
        end
    
    
    
    end


end


assign rd1 = r1_recv?registers[ra1]:32'b?;
assign rd2 = r2_recv?registers[ra2]:32'b?;





endmodule
