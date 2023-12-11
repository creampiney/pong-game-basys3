`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 01:05:52 PM
// Design Name: 
// Module Name: clockDivider
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


// Divide clock by 2
module clockDivider(
    output clkDiv,
    input clk
    );
    
reg clkDiv;

initial
begin
    clkDiv = 0;
end

always @(posedge clk)
begin
    clkDiv = ~clkDiv;
end    

endmodule
