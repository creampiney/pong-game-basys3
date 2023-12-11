`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 01:20:10 PM
// Design Name: 
// Module Name: binToBCD
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


module binToBCD(
   output reg [3:0] num1,
   output reg [3:0] num0,
   input [6:0] bin
   );
   	
always @(bin) begin
    num1 = bin/10;
    num0 = bin%10;
end
endmodule
