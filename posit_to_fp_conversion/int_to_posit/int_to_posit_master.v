`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*

    About : Module Takes input on AXI-S 8-bit inputs and outputs 16-bit posits,
    with es=0
    
    Input : AXI-S Interface
    Output :  ReQ_AcK -> Pipe Protocol

*/
//////////////////////////////////////////////////////////////////////////////////


module int_to_posit_master(

clk,
reset,
rx_axis_tvalid,
rx_axis_tdata,
rx_axis_tready,

pipe_write_data,
pipe_write_req,
pipe_write_ack

    );
    
    
    parameter N = 8;
    parameter PS = 16;
    parameter ES = 0;
    parameter D = 8;
    parameter D_S = 3; //log2(D)
    
    
    input clk;
    input reset;
    input rx_axis_tvalid;
    input [N-1:0] rx_axis_tdata;
    output rx_axis_tready;
    
    output reg [PS-1 : 0] pipe_write_data;
    output reg pipe_write_req;
    input  pipe_write_ack;
    
    //Create a FIFO
    
    assign rx_axis_tready = 1;
    reg [PS-1 : 0] fifo [D - 1 : 0];
    reg [D_S-1:0] fifo_pos_front = 0;
    reg [D_S-1:0] fifo_pos_rear = 0;
    
    //Miscellaneous Signals
    reg data_valid = 0;
    reg reset_reg = 0;
    reg fifo_full = 0;
    
  
    wire [PS-1:0] final_data; 
    reg [N-1:0] convert_data;
    
    int_to_posit_converter ip1 (convert_data,final_data);
    
    
    
//////////////////////////////////////Reset Logic////////////////////////////////////////////
    
    always@(posedge clk)
    begin
        
        if (reset == 1'b1)
        begin
            reset_reg      <= 1;
        end
        
        else
        begin
        reset_reg      <= 0; 
    end
    
    end
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    
    ///////////////////////////////////////////AXI-S Data Loading/////////////////////////////////////////////////

always@(posedge clk)
begin
if (reset_reg == 1'b1)
        begin
            data_valid <= 1'b0;
        end

else
begin

if(rx_axis_tvalid == 1'b1)
begin
    convert_data <= rx_axis_tdata;
    data_valid <= 1'b1;
    
end

else
begin
    data_valid <= 1'b0;
end
end
end


    ///////////////////////////////////////////POSIT Encoder and FIFO Loading/////////////////////////////////////////////////
   
   
   always@(posedge clk)
   begin
        
   if (reset_reg == 1'b1)
           begin
               pipe_write_req <= 1'b0; //No Data to send to Pipe now since reset has been asserted
               fifo_pos_front <= 1'b0; // Reset Position to 0
               fifo_pos_rear  <= 1'b0;
               fifo_full      <= 1'b0;
            
           end
   
   else
   
   
   if (fifo_pos_front == fifo_pos_rear) //Means Fifo is empty
                                          begin
                                              fifo_pos_front <= 1'b0;
                                              fifo_pos_rear  <= 1'b0;
                                              fifo_full      <= 1'b0;
                                              pipe_write_req <= 1'b0;
                                              
                                          end
                   begin
                   if (data_valid == 1'b1)
                   begin
                   if (fifo_full != 1'b1)  // If FIFO is full then the packets will be dropped
                   begin
                   if (((fifo_pos_rear + 1) % D) == fifo_pos_front)
                          fifo_full <= 1'b1;
                               else
                               begin
                                     
                                   fifo[fifo_pos_rear] <= final_data;//Posit Data will Come here;
                                   fifo_pos_rear       <= (fifo_pos_rear + 1) % D;
                               end
                   
                   
                   
                   end
                   end
                   if (fifo_pos_rear != fifo_pos_front)  //Indicates that Data is available to send
                               begin
                                   pipe_write_req  <= 1'b1;
                                   pipe_write_data <= fifo[fifo_pos_front];
                                   
                                   if (pipe_write_ack == 1'b1)
                                   begin
                                       fifo_pos_front <= (fifo_pos_front + 1) % D;
                                       
                                       if (fifo_full == 1'b1)
                                           fifo_full <= 1'b0;
                                       
                                       if (fifo_pos_front == fifo_pos_rear) //Means Fifo is empty
                                       begin
                                           fifo_pos_front <= 1'b0;
                                           fifo_pos_rear  <= 1'b0;
                                           fifo_full      <= 1'b0;
                                           pipe_write_req <= 1'b0;
                                           
                                       end
                                   end
                               end
                               
                   end
   
   end
   
   
   
   
   
   
    
endmodule
