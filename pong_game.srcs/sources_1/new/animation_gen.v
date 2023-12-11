`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 11:23:24 AM
// Design Name: 
// Module Name: animation_gen
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


module animation_gen(
    output wire hsync, vsync,
    output wire [11:0] rgb,
    input wire clk,
    input wire [15:0] score,
    input wire [8:0] player1_paddle_y_pos,
    input wire [8:0] player2_paddle_y_pos,
    input wire [9:0] ball_x_pos,
    input wire [8:0] ball_y_pos,
    input wire [6:0] paddle_length,
    input wire ballBoost,
    input wire paddleMode
	);
	
	parameter WIDTH = 640;
	parameter HEIGHT = 480;
	
	parameter GAME_RGB = 12'h000;
	parameter EDGE_RGB_LEFT = 12'hEFF;
	parameter EDGE_RGB_RIGHT = 12'hFEF;
	parameter TEXT_RGB = 12'h000;
	parameter PADDLE_RGB = 12'h262;
	parameter BALL_RGB = 12'hB22;
	parameter DASH_RGB = 12'h444;
	parameter BG_LEFT_RGB = 12'h002;
	parameter BG_RIGHT_RGB = 12'h200;
	
	parameter BOTTOM_TEXT_1 = 160'h50_72_65_73_73_00_57_00_6F_72_00_53_00_74_6F_00_6d_6F_76_65;
	parameter BOTTOM_TEXT_2 = 160'h50_72_65_73_73_00_49_00_6F_72_00_4B_00_74_6F_00_6d_6F_76_65;
	parameter BALLBOOST_TEXT = 96'h46_61_73_74_65_72_00_42_61_6C_6C_13;
	parameter PADDLESTATE_TEXT = 120'h53_68_6F_72_74_65_72_00_50_61_64_64_6C_65_13;
	
	parameter GAME_LEFTEDGE = 32;
	parameter GAME_RIGHTEDGE = 607;
	parameter GAME_TOPEDGE = 32;
	parameter GAME_BOTTOMEDGE = 447;
	
    parameter PLAYER1_PADDLE_X_POS = 80;
    parameter PLAYER2_PADDLE_X_POS = 552;
    parameter PADDLE_LENGTH = 96;
    parameter PADDLE_WIDTH = 8;
    
    parameter BALL_SIZE = 8;
	
	// register for Basys 2 8-bit RGB DAC 
	reg [11:0] rgb_reg;
	reg reset = 0;
	wire [9:0] x, y;
	
	// edge color
	wire [11:0] bg_rgb;
	assign bg_rgb = (x < WIDTH/2) ? EDGE_RGB_LEFT : EDGE_RGB_RIGHT;
	
	wire [11:0] game_rgb;
	assign game_rgb = (x < WIDTH/2) ? BG_LEFT_RGB : BG_RIGHT_RGB;
	
	// font rom
	reg [10:0] font_address;
	initial font_address = 0;
	wire [7:0] font_data;
	
	font_rom font_rom(p_tick, font_address, font_data);
	
	
	wire [7:0] bottom_text1_addr;
	wire [7:0] bottom_text2_addr;
	wire [7:0] ballboost_addr;
	wire [7:0] paddlemode_addr;
	assign bottom_text1_addr = ((191-x)/8 + 1)*8 - 1;
	assign bottom_text2_addr = ((607-x)/8 + 1)*8 - 1;
	assign ballboost_addr = ((127-x)/8 + 1)*8 - 1;
	assign paddlemode_addr = ((607-x)/8 + 1)*8 - 1;
	
	
	
	// video status output from vga_sync to tell when to route out rgb signal to DAC
	wire video_on;
	wire p_tick;

    // instantiate vga_sync
    vga_sync vga_sync_unit (
        .clk(clk), .reset(reset), 
        .hsync(hsync), .vsync(vsync), .video_on(video_on), .p_tick(p_tick), 
        .x(x), .y(y)
        );
        
    // Address for text
    always @*
    begin
        // Score Text
        if ((x >= 296) && (x <= 303) && (y >= 8) && (y <= 23)) begin
	        // Score - first digit
	        font_address <= {(7'h30 + score[15:12]),(y[3:0] - 4'd8)};
	    end
	    else if ((x >= 304) && (x <= 311) && (y >= 8) && (y <= 23)) begin
	        // Score - second digit
	        font_address <= {(7'h30 + score[11:8]),(y[3:0] - 4'd8)};
	    end
	    else if ((x >= 328) && (x <= 335) && (y >= 8) && (y <= 23)) begin
	        // Score - third digit
	        font_address <= {(7'h30 + score[7:4]),(y[3:0] - 4'd8)};
	    end
	    else if ((x >= 336) && (x <= 343) && (y >= 8) && (y <= 23)) begin
	        // Score - forth digit
	        font_address <= {(7'h30 + score[3:0]),(y[3:0] - 4'd8)};
	    end
	    
	    else if (ballBoost == 1 && x >= 32 && x < 128 && y >= 8 && y <= 23) begin
	       // Ball speedup
	       font_address <= {BALLBOOST_TEXT[ballboost_addr -: 8],((y[3:0] - 4'd8))};
	    end
	    else if (paddleMode == 1 && x >= 488 && x < 608 && y >= 8 && y <= 23) begin
	       // Paddle mode
	       font_address <= {PADDLESTATE_TEXT[paddlemode_addr -: 8],((y[3:0] - 4'd8))};
	    end
	    
	    // Bottom Text
	    else if (x >= 32 && x <= 191 && y >= 456 && y <= 471) begin
	        font_address <= {BOTTOM_TEXT_1[bottom_text1_addr -: 8],((y[3:0] - 4'd456))};
	    end
	    else if (x >= 448 && x <= 607 && y >= 456 && y <= 471) begin
	        font_address <= {BOTTOM_TEXT_2[bottom_text2_addr -: 8],((y[3:0] - 4'd456))};
	    end
    end
    
    // Rendering
	always @(posedge p_tick)
	    // Score Text
	    if ((x >= 296) && (x <= 303) && (y >= 8) && (y <= 23)) begin
	        // Score - first digit
            rgb_reg[11:0] <= (font_data[303-x] == 1) ? TEXT_RGB : bg_rgb;
	    end
	    else if ((x >= 304) && (x <= 311) && (y >= 8) && (y <= 23)) begin
	        // Score - second digit
            rgb_reg[11:0] <= (font_data[311-x] == 1) ? TEXT_RGB : bg_rgb;
	    end
	    else if ((x >= 328) && (x <= 335) && (y >= 8) && (y <= 23)) begin
	        // Score - third digit
	        rgb_reg[11:0] <= (font_data[335-x] == 1) ? TEXT_RGB : bg_rgb;
	    end
	    else if ((x >= 336) && (x <= 343) && (y >= 8) && (y <= 23)) begin
	        // Score - forth digit
            rgb_reg[11:0] <= (font_data[343-x] == 1) ? TEXT_RGB : bg_rgb;
	    end
	    
	    else if (ballBoost == 1 && x >= 32 && x < 128 && y >= 8 && y <= 23) begin
	        // Ball speedup
	        rgb_reg[11:0] <= (font_data[127-x] == 1) ? TEXT_RGB : bg_rgb;
	    end
	    else if (paddleMode == 1 && x >= 488 && x < 608 && y >= 8 && y <= 23) begin
	        // Paddle mode
	        rgb_reg[11:0] <= (font_data[607-x] == 1) ? TEXT_RGB : bg_rgb;
	    end
	    
	    
	    // Bottom Text
	    else if (x >= 32 && x <= 191 && y >= 456 && y <= 471) begin
	        rgb_reg[11:0] <= (font_data[(191-x)%8] == 1) ? TEXT_RGB : bg_rgb;
	    end
	    else if (x >= 448 && x <= 607 && y >= 456 && y <= 471) begin
	        rgb_reg[11:0] <= (font_data[(607-x)%8] == 1) ? TEXT_RGB : bg_rgb;
	    end
	    
	    // Border
	    else if (x < GAME_LEFTEDGE || x > GAME_RIGHTEDGE || y < GAME_TOPEDGE || y > GAME_BOTTOMEDGE) begin
	        rgb_reg[11:0] <= bg_rgb;
	    end
	    
	    // Ball
	    else if ((x >= ball_x_pos) && (x < ball_x_pos + BALL_SIZE) && (y >= ball_y_pos) && (y < ball_y_pos + BALL_SIZE)) begin
	       rgb_reg[11:0] <= BALL_RGB;
	    end
	    
	    // Player 1 Paddle
	    else if ((x >= PLAYER1_PADDLE_X_POS) && (x < PLAYER1_PADDLE_X_POS + PADDLE_WIDTH) && (y >= player1_paddle_y_pos) && (y < player1_paddle_y_pos + paddle_length)) begin
	        rgb_reg[11:0] <= PADDLE_RGB;
	    end
	    
	    // Player 2 Paddle
	    else if ((x >= PLAYER2_PADDLE_X_POS) && (x < PLAYER2_PADDLE_X_POS + PADDLE_WIDTH) && (y >= player2_paddle_y_pos) && (y < player2_paddle_y_pos + paddle_length)) begin
	        rgb_reg[11:0] <= PADDLE_RGB;
	    end
	    
	    // Background
	    else if (x >= (WIDTH/2) - 1 && x <= WIDTH/2 && y >= GAME_TOPEDGE && y <= GAME_BOTTOMEDGE && y[2] == 1) begin
	        // Dash line at center
	        rgb_reg[11:0] <= DASH_RGB;
	    end
//	    else if ((x >= GAME_LEFTEDGE) && (x <= GAME_RIGHTEDGE) && (y >= GAME_TOPEDGE) && (y <= GAME_BOTTOMEDGE)) begin
//	        // Game zone
//	        rgb_reg[11:0] <= game_rgb;
//	    end
        else begin
	        // Game zone
	        rgb_reg[11:0] <= game_rgb;
	    end
	    
    
    // output
    assign rgb = (video_on) ? rgb_reg : 12'b0;
endmodule
