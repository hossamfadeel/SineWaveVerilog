`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2019 05:40:15 PM
// Design Name: 
// Module Name: SineGen
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


module SineGen
# (parameter div_factor_freq0 =32'd3,
                     div_factor_freq1 =32'd1,
                     depth_p  = 10'd11,  // the number of samples in one period of the signal               
                     width_p  = 10'd16  // the number of bits used to represent amplitude value
             
  ) 
(input clk,                       //input clock signal
input reset,
input Start0, Start1,
output reg Done,
output reg[width_p-1:0] sine_out0, sine_out1
);  
 
reg [(width_p-1):0] memory [(2**depth_p-1):0];  //vector for amplitude value
integer freq_cnt0, freq_cnt1;                     // clock counter
integer SamplesCnt;
localparam integer SIZE = (2**depth_p-1); //2^10= 1024
// 2 ^ 11 =  2048

initial
begin
    $readmemh("sine2048.mem", memory); //read memory
    freq_cnt0 = 0;   freq_cnt1 = 0;   
    SamplesCnt = 0;
end
// Defines a sequential process
// Fetches amplitude values and frequency -> generates sine
always @(posedge clk or negedge reset)
begin
 if (!reset)
   begin
       sine_out0 <= 0; sine_out1 <= 0;
         freq_cnt0 = 0;   freq_cnt1 = 0;   
       Done <= 1'b0;  
   end
   else
   begin         
    Done <= 1'b0;  
    SamplesCnt =  SamplesCnt + 1;
     if(SamplesCnt == SIZE)
           begin
           SamplesCnt <= 0;
           Done <= 1'b1; 
           end
    //First frequency
    if (freq_cnt0 >= SIZE-1)
       begin
           freq_cnt0 <= 'd0;       
        end
    else
        begin
             sine_out0 <= memory[freq_cnt0];
             freq_cnt0 <= freq_cnt0 + div_factor_freq0;       
        end        
     //Second frequency
    if (freq_cnt1 >= SIZE-1)
        begin
            freq_cnt1 <= 'd0;       
         end
     else
         begin
              sine_out1 <= memory[freq_cnt1];
              freq_cnt1 <= freq_cnt1 + div_factor_freq1;       
         end
    end
end




//always @(posedge clk)
//begin
// if (!reset)
//   begin
//       sine_out0 <= 0; sine_out1 <= 0;
//       freq_trig0 <= 1'b0; freq_trig1 <= 1'b0;     
//       i0 <= 0; i1 <= 0;
//       Done0 <= 1'b0; Done1 <= 1'b0; 
//   end
//   else
//   begin
//    // default assignment
//    freq_trig0 <= 1'b0;  freq_trig1 <= 1'b0;                 
//    Done0 <= 1'b0;  Done1 <= 1'b0;
//    freq_cnt0 <= freq_cnt0 + 1;        //increment
//    freq_cnt1 <= freq_cnt1 + 1;        //increment
//    //First frequency
//    if (freq_cnt0 >= div_factor_freq0 -1)
//       begin
//           freq_trig0 <= 1'b1;
//           freq_cnt0 <= 'd0;        //reset
//        end
    
//    if (freq_trig0 & Start0)
//       begin
//           sine_out0 <= memory[i0];
//           i0 <= i0+ 1;
//           if(i0 == SIZE)
//                begin
//                i0 <= 0;
//                Done0 <= 1'b1; 
//                end
//        end
//     //Second frequency
//      if (freq_cnt1 >= div_factor_freq1 -1)
//           begin
//               freq_trig1 <= 1'b1;
//               freq_cnt1 <= 'd0;        //reset
//            end
        
//        if (freq_trig1 & Start1)
//           begin
//               sine_out1 <= memory[i1];
//               i1 <= i1+ 1;
//               if(i1 == SIZE)
//                    begin
//                    i1 <= 0;
//                    Done1 <= 1'b1; 
//                    end
//            end
           
//    end
//end

endmodule