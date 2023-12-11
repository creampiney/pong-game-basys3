`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 12:04:43 PM
// Design Name: 
// Module Name: game_control
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


module game_control(
    output [6:0] player1_score,
    output [6:0] player2_score,
    output [8:0] player1_paddle_y_pos,
    output [8:0] player2_paddle_y_pos,
    output [9:0] ball_x_pos,
    output [8:0] ball_y_pos,
    output [6:0] paddle_length,
    input clk,
    input wire reset,
    input [7:0] keyboard,
    input keyboardEn,
    input ballBoost,
    input paddleMode
    );
    
    parameter WIDTH = 640;
	parameter HEIGHT = 480;
	
    parameter GAME_LEFTEDGE = 32;
	parameter GAME_RIGHTEDGE = 607;
	parameter GAME_TOPEDGE = 32;
	parameter GAME_BOTTOMEDGE = 447;
    
    parameter PADDLE_LENGTH = 96;
    parameter PADDLE_WIDTH = 8;
    
    parameter PLAYER1_PADDLE_X_POS = 80;
    parameter PLAYER2_PADDLE_X_POS = 552;
    
    parameter BALL_SIZE = 8;
    parameter BALL_SPEED = 2;
    
    parameter P1_SAVE_X_POS = 136;
    parameter P1_SAVE_Y_POS = 236;
    parameter P2_SAVE_X_POS = 496;
    parameter P2_SAVE_Y_POS = 236;
    
    
    
    reg [6:0] player1_score = 0;
    reg [6:0] player2_score = 0;
    
    // Ball velocity
    wire [2:0] ball_speed;
    assign ball_speed = (ballBoost == 1) ? 4 : 2;
    
    // Paddle Length
    wire [6:0] paddle_length;
    assign paddle_length = (paddleMode == 1) ? 64 : 96;
    
    reg [8:0] player1_paddle_y_pos;
    reg [8:0] player2_paddle_y_pos;
    
    initial begin
        player1_paddle_y_pos <= (HEIGHT / 2) - (paddle_length / 2);
        player2_paddle_y_pos <= (HEIGHT / 2) - (paddle_length / 2);
    end
    
    reg [9:0] ball_x_pos = P1_SAVE_X_POS;
    reg [8:0] ball_y_pos = P1_SAVE_Y_POS;
    reg ball_v_state = 1;   // 0 = Up, 1 = Down
    reg ball_h_state = 1;   // 0 = Left, 1 = Right
    
    reg game_state = 0;       // 0 = Reset, 1 = Running
    reg [7:0] key_state = 0;
    

    // Keyboard
    wire keyboard_enable_sp;
    singlePulser ksp(keyboard_enable_sp, keyboardEn, clk);
    
    always @(keyboard_enable_sp)
    begin
        if (keyboard_enable_sp)
            key_state = keyboard;
    end
    

    // Game reg
    reg [8:0] player1_paddle_y_pos_next = (HEIGHT / 2) - (PADDLE_LENGTH / 2);
    reg [8:0] player2_paddle_y_pos_next = (HEIGHT / 2) - (PADDLE_LENGTH / 2);
    
    // Game clock
    wire game_clk;
    game_clock game_clock(clk, game_clk);
   

    
    
    always @(posedge clk) begin
          if (reset) begin
                player1_paddle_y_pos_next <= (HEIGHT / 2) - (paddle_length / 2);
                player2_paddle_y_pos_next <= (HEIGHT / 2) - (paddle_length / 2);
          end
//          else if (keyboard_enable_sp) begin
          else if ((keyboard == 8'h77) && (player1_paddle_y_pos > GAME_TOPEDGE)) begin
                player1_paddle_y_pos_next <= (player1_paddle_y_pos - 16) % HEIGHT;
          end
          else if ((keyboard == 8'h73) && (player1_paddle_y_pos <= GAME_BOTTOMEDGE - paddle_length)) begin
                player1_paddle_y_pos_next <= (player1_paddle_y_pos + 16) % HEIGHT;
          end
          else if ((keyboard == 8'h69) && (player2_paddle_y_pos > GAME_TOPEDGE)) begin
                player2_paddle_y_pos_next <= (player2_paddle_y_pos - 16) % HEIGHT;
          end
          else if ((keyboard == 8'h6B) && (player2_paddle_y_pos <= GAME_BOTTOMEDGE - paddle_length)) begin
                player2_paddle_y_pos_next <= (player2_paddle_y_pos + 16) % HEIGHT;
          end
//          end

          
    end
    

    
    // Paddle Update
    always @(posedge game_clk) begin
        player1_paddle_y_pos = player1_paddle_y_pos_next;
        player2_paddle_y_pos = player2_paddle_y_pos_next;
    end
    
    wire isTouchPaddle1;
    wire isTouchPaddle2;
    assign isTouchPaddle1 = (ball_x_pos >= PLAYER1_PADDLE_X_POS + PADDLE_WIDTH - (PADDLE_WIDTH / 2)
                            && ball_x_pos <= PLAYER1_PADDLE_X_POS + PADDLE_WIDTH 
                            && ball_y_pos >= player1_paddle_y_pos - BALL_SIZE
                            && ball_y_pos < player1_paddle_y_pos + paddle_length + BALL_SIZE) ? 1 : 0;
    assign isTouchPaddle2 = (ball_x_pos >= PLAYER2_PADDLE_X_POS - BALL_SIZE
                            && ball_x_pos <= PLAYER2_PADDLE_X_POS - BALL_SIZE + (PADDLE_WIDTH / 2)
                            && ball_y_pos >= player2_paddle_y_pos - BALL_SIZE
                            && ball_y_pos < player2_paddle_y_pos + paddle_length + BALL_SIZE) ? 1 : 0;
    
    // Ball and Score Update
    always @(posedge game_clk or posedge reset) begin
        if (reset) begin
            ball_x_pos <= P1_SAVE_X_POS;
            ball_y_pos <= P1_SAVE_Y_POS;
            ball_v_state <= 1;
            ball_h_state <= 1;
            player1_score <= 0;
            player2_score <= 0;
        end
        else begin
            ball_x_pos = (ball_h_state == 1) ? ball_x_pos + ball_speed : ball_x_pos - ball_speed;
            ball_y_pos = (ball_v_state == 1) ? ball_y_pos + ball_speed : ball_y_pos - ball_speed;
            
            if (ball_y_pos <= GAME_TOPEDGE) begin
                ball_v_state = 1;
            end
            else if (ball_y_pos >= GAME_BOTTOMEDGE - BALL_SIZE + 1) begin
                ball_v_state = 0;
            end
            
            if (ball_x_pos <= GAME_LEFTEDGE) begin
                ball_x_pos = P1_SAVE_X_POS;
                ball_y_pos = P1_SAVE_Y_POS;
                ball_h_state = 1;
                player2_score = (player2_score + 1) % 100;                
            end
            else if (ball_x_pos >= GAME_RIGHTEDGE - BALL_SIZE + 1) begin
                ball_x_pos = P2_SAVE_X_POS;
                ball_y_pos = P2_SAVE_Y_POS;
                ball_h_state = 0;
                player1_score = (player1_score + 1) % 100;  
            end
            
            if (isTouchPaddle1) begin
                ball_h_state = 1;
            end
            else if (isTouchPaddle2) begin
                ball_h_state = 0;
            end
            
        end
    end
    
    
    
    
    
    
    
    
endmodule
