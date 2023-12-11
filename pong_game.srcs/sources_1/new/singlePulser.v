`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2023 03:59:57 PM
// Design Name: 
// Module Name: singlePulser
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


module singlePulser(
    output out,
    input in,
    input clk
    );
    
reg [1:0] state;
reg out;

initial state = 0;

always @(posedge clk)
begin
    case (state)
        0:  if (in == 1)
                state = 1;
        1:  if (in == 0)
                state = 0;
            else
                state = 2;
        2:  if (in == 0)
                state = 0;
    endcase
end

always @(state)
begin
    case (state)
        0: out = 0;
        1: out = 1;
        2: out = 0;
    endcase
end
    
endmodule