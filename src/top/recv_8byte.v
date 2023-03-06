`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/09 18:17:42
// Design Name: 
// Module Name: bt_recv_8bit
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


module recv_8byte(
    input clk,
    input bt_rxd,
    output reg[31:0] data_32bit,
    output refresh
    );

    wire bt_rx_done;
    wire[7:0] bt_recv_data;
    reg[3:0] recv_data_cache;
    reg test = 0;

    initial
    begin
        data_32bit = 32'd0;
        recv_data_cache = 0;
    end

    uart_rx uart_rx_bt(
        .clk(clk),
        .uart_rxd(bt_rxd),
        .uart_data(bt_recv_data),
        .uart_rx_done(bt_rx_done)
        );

    assign refresh = bt_rx_done;

    always@(posedge clk)
    begin
        if (bt_rx_done == 1)
        begin
            case(bt_recv_data)
                8'd48: recv_data_cache = 4'h0;
                8'd49: recv_data_cache = 4'h1;
                8'd50: recv_data_cache = 4'h2;
                8'd51: recv_data_cache = 4'h3;
                8'd52: recv_data_cache = 4'h4;
                8'd53: recv_data_cache = 4'h5;
                8'd54: recv_data_cache = 4'h6;
                8'd55: recv_data_cache = 4'h7;
                8'd56: recv_data_cache = 4'h8;
                8'd57: recv_data_cache = 4'h9;
                default: recv_data_cache = 4'hf;
            endcase

            data_32bit[31:28] <= data_32bit[27:24];
            data_32bit[27:24] <= data_32bit[23:20];
            data_32bit[23:20] <= data_32bit[19:16];
            data_32bit[19:16] <= data_32bit[15:12];
            data_32bit[15:12] <= data_32bit[11:8];
            data_32bit[11:8] <= data_32bit[7:4];
            data_32bit[7:4] <= data_32bit[3:0];
            data_32bit[3:0] <= recv_data_cache;
        end
    end
endmodule
