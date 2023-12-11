`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 01:07:25 PM
// Design Name: 
// Module Name: sevenSegmentEncoder
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


module sevenSegmentEncoder(q, d);

input [3:0] d;
output [6:0] q;

reg [6:0] q;

// 7-segment encoding
//      0
//     ---
//  5 |   | 1
//     --- <--6
//  4 |   | 2
//     ---
//      3

   always @(d)
      case (d)
          4'b0001 : q = 7'b1111001;   // 1
          4'b0010 : q = 7'b0100100;   // 2
          4'b0011 : q = 7'b0110000;   // 3
          4'b0100 : q = 7'b0011001;   // 4
          4'b0101 : q = 7'b0010010;   // 5
          4'b0110 : q = 7'b0000010;   // 6
          4'b0111 : q = 7'b1111000;   // 7
          4'b1000 : q = 7'b0000000;   // 8
          4'b1001 : q = 7'b0010000;   // 9
          4'b1010 : q = 7'b0001000;   // A
          4'b1011 : q = 7'b0000011;   // b
          4'b1100 : q = 7'b1000110;   // C
          4'b1101 : q = 7'b0100001;   // d
          4'b1110 : q = 7'b0000110;   // E
          4'b1111 : q = 7'b0111111;   // -
          default : q = 7'b1000000;   // 0
      endcase
				
	

endmodule
