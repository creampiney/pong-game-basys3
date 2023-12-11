`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2021 09:59:35 PM
// Design Name: 
// Module Name: uart
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

module uart(
    input clk,
    input RsRx,
    output RsTx,
    output [7:0] out,
    output en
    );
    
    
    
    reg en, last_rec;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire sent, received, baud;
    
    baudrate_gen baudrate_gen(clk, baud);
    uart_rx receiver(baud, RsRx, received, data_out);
    uart_tx transmitter(baud, data_in, en, sent, RsTx);
    
//    initial out = 0;
    assign out = (en == 1) ? data_in : 8'b0;
    
    always @(posedge baud) begin
        if (en) begin
//            out = 0;
            en = 0;
        end
        if (~last_rec & received) begin
            data_in = data_out;
            if (data_in <= 8'h7A && data_in >= 8'h41) begin
//                out = data_in;
                en = 1;
            end
        end
        last_rec = received;
    end
    
endmodule