`timescale 1ns / 1ps


module register_reader_interface_module(
clk,
in_data,
final_output,
addr,
proc_done,
rvalid,
rvalid_in,
output_valid);

parameter NUM_ADDRESS = 5;
parameter NUM_BITS = 32;
parameter NUM_REGISTERS = 2**NUM_ADDRESS;


input clk;
input [NUM_BITS-1 : 0] in_data;
input rvalid_in;
output reg [NUM_ADDRESS-1:0] addr;
output   [NUM_BITS-1 : 0] final_output;
input proc_done;
output reg rvalid;
output reg output_valid;


reg data_recv = 0;

reg [NUM_BITS-1:0] out_data;

wire [NUM_BITS-1:0] intm_output;

Posit_to_FP p1(out_data, intm_output);

assign final_output = intm_output;


always@(posedge clk)

begin

    if(proc_done == 1'b1)
        begin
            addr <= 0; //Read from Accumulator
            rvalid <= 1;
            
                   
        end
        
    if(data_recv == 1)
        begin
        rvalid <= 0;
        
        
        end
    

end


always@(posedge clk)
begin

    if(rvalid_in == 1'b1)
        begin
        
            out_data <= in_data;
            data_recv <= 1'b1;
            output_valid <= 1;       
        end
    else
        begin
        data_recv  <= 0;
         output_valid <= 0;
        end
end






endmodule
