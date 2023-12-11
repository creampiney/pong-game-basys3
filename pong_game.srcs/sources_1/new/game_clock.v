`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2023 01:21:17 PM
// Design Name: 
// Module Name: game_clock
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


module game_clock (
  input wire clk_50MHz,    // Input clock assumed to be 50 MHz
  output reg clk_20Hz     // Output clock with a period of 0.05 seconds (20 Hz)
);

  reg [25:0] counter;       // 26-bit counter for dividing the clock frequency

  always @(posedge clk_50MHz) begin
    // Divide the input clock frequency by (50,000,000 cycles/second * 0.05 seconds)
    if (counter == 1_000_000) begin
      counter <= 0;
      clk_20Hz <= ~clk_20Hz;  // Toggle the output clock every 500,000 cycles
    end else begin
      counter <= counter + 1;
    end
  end

endmodule
