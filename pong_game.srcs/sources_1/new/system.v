`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2021 09:31:37 PM
// Design Name: 
// Module Name: system
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


module system(
    output [6:0] seg,
    output [3:0] an,
    output dp,
    input wire [11:0] sw,
    input btnC, btnU, btnL,
    output wire Hsync, Vsync,
    output wire [3:0] vgaRed, vgaGreen, vgaBlue,
    output wire RsTx,
    input wire RsRx,
    input clk
    );

// -----------------------------------------------
// UART

wire [7:0] keyboardOut;
wire keyboardEn;
uart uart(clk,RsRx,RsTx,keyboardOut,keyboardEn);


// -----------------------------------------------
// Game Controller

wire [6:0] player1_score;
wire [6:0] player2_score;

wire [8:0] player1_paddle_y_pos;
wire [8:0] player2_paddle_y_pos;

wire [9:0] ball_x_pos;
wire [8:0] ball_y_pos;

wire [6:0] paddle_length;

game_control game_control(
    .player1_score(player1_score), 
    .player2_score(player2_score), 
    .player1_paddle_y_pos(player1_paddle_y_pos),
    .player2_paddle_y_pos(player2_paddle_y_pos),
    .ball_x_pos(ball_x_pos),
    .ball_y_pos(ball_y_pos),
    .paddle_length(paddle_length),
    .clk(clk),
    .reset(btnC),
    .keyboard(keyboardOut),
    .ballBoost(sw[0]),
    .paddleMode(sw[1]));



// -----------------------------------------------
// Divide Clock for Seven Segment

wire [18:0] fclk;
wire targetClk;

assign fclk[0] = clk;

genvar i;
generate for(i = 0; i < 18; i = i+1)
begin
    clockDivider clkDiv(fclk[i+1], fclk[i]);
end
endgenerate
clockDivider targetClkDiv(targetClk, fclk[18]);





// -----------------------------------------------
// Seven Segment - Score
wire [3:0] num3, num2, num1, num0;
assign dp = 1;

//binToBCD btb1(num3, num2, keyboardOut);
binToBCD btb1(num3, num2, player1_score);
binToBCD btb2(num1, num0, player2_score);

sevenSegmentTDM sst(seg, an, targetClk, num0, num1, num2, num3);



// -----------------------------------------------
// Animation Generator

wire [15:0] score;
assign score = {num3, num2, num1, num0};

animation_gen animation_gen(
    .hsync(Hsync), .vsync(Vsync),
    .rgb({vgaRed, vgaGreen, vgaBlue}),
    .clk(clk),
    .score(score),
    .player1_paddle_y_pos(player1_paddle_y_pos),
    .player2_paddle_y_pos(player2_paddle_y_pos),
    .ball_x_pos(ball_x_pos),
    .ball_y_pos(ball_y_pos),
    .paddle_length(paddle_length),
    .ballBoost(sw[0]),
    .paddleMode(sw[1])
    );





    
endmodule