`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 01:10:22 PM
// Design Name: 
// Module Name: sevenSegmentTDM
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


module sevenSegmentTDM(
    output [6:0] seg,
    output [3:0] an,
    input clk,
    input [3:0] num0,
    input [3:0] num1,
    input [3:0] num2,
    input [3:0] num3
    );

reg [3:0] an;


reg [1:0] state;
reg [3:0] num;

sevenSegmentEncoder sse(seg, num);

initial
begin
    state = 2'b00;
end

// Counter
always @(posedge clk)
begin
    state = state + 1;
end

// TDM
always @(state)
begin
    case(state)
        2'b00: an = 4'b0111;
        2'b01: an = 4'b1011;
        2'b10: an = 4'b1101;
        2'b11: an = 4'b1110;
    endcase
end

always @(state)
begin
    case(state)
        2'b00: num = num3;
        2'b01: num = num2;
        2'b10: num = num1;
        2'b11: num = num0;
    endcase
end
    
    
endmodule
