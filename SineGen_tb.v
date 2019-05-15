`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2019 02:50:49 PM
// Design Name: 
// Module Name: SineGen_tb
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


module SineGen_tb( );


reg clk;                     // input clock signal
reg reset;                     // input reset signal

// signal used for controlling the operation
reg Start0, Start1;
wire  Done0,Done1 ;
wire freq_trig0, freq_trig1;
reg freq_trig_mask0, freq_trig_mask1 ;

wire [15:0] sine_out0, sine_out1;

parameter div_factor_freq0 =32'd3;
parameter div_factor_freq1 =32'd1;

parameter depth_p  = 10'd11;  // the number of samples in one period of the signal               
parameter  width_p  = 10'd16;  // the number of bits used to represent amplitude value

reg [(width_p-1):0] sine_out_memory0 [(2**depth_p-1):0];  //vector for amplitude value
reg [(width_p-1):0] sine_out_memory1 [(2**depth_p-1):0];  //vector for amplitude value

// 2 ^ 11 =  2048
integer i0, i1;
// Digital Sine Top module instance
SineGen #(.div_factor_freq0(div_factor_freq0),.div_factor_freq1(div_factor_freq1),.depth_p(depth_p), .width_p(width_p) ) dut (clk, reset, Start0,Start1,Done0,Done1,freq_trig0, freq_trig1,sine_out0, sine_out1);

//LUT_sine #(.depth_p(depth_p), .width_p(width_p)) sine (clk_in, ampl_cnt_w, sine_ampl_w);

// Set up the clock to toggle every 10 time units
initial
begin
    clk = 1'b1;
    forever #10 clk = ~clk;
end
initial
begin
    reset = 1'b0;
    Start0 =1'b0;
    Start1 =1'b0;
    #1_01
     Start0 = 1'b1;
     Start1 = 1'b1;
     reset = 1'b1;
end

always @(posedge clk)
begin
 if (!reset)
   begin
       i0 <= 0;  i1 <= 0;
       freq_trig_mask0 <= 1'b0;  freq_trig_mask1 <= 1'b0;
   end
   else
   begin
   //1
    if (freq_trig0 & Start0)
    begin
      freq_trig_mask0 <= 1'b1;
      end
     if (freq_trig_mask0)
     begin
        sine_out_memory0[i0] = sine_out0;
        i0 <= i0+ 1;
        freq_trig_mask0 <= 1'b0;
        end
   //2
   if (freq_trig1 & Start1)
   begin
     freq_trig_mask1 <= 1'b1;
     end
    if (freq_trig_mask1)
    begin
       sine_out_memory1[i1] = sine_out1;
       i1 <= i1+ 1;
       freq_trig_mask1 <= 1'b0;
       end
    end
end
    
endmodule
