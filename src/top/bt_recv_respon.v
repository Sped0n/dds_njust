`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/09 15:53:05
// Design Name: 
// Module Name: bt_8bit
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


module bt_recv_response(
    input clk,
    input bt_rxd,
    output[31:0] bt_recv_data,
    output bt_txd
    );

    reg last_recv_data;
    reg[63:0] send_data;
    reg send_en;
    wire send_done;
    wire data_refresh;

    initial 
    begin
        last_recv_data = 0;
        send_en = 0;
        //Success!
        send_data[63:56] = 8'd83;
        send_data[55:48] = 8'd117;
        send_data[47:40] = 8'd99;
        send_data[39:32] = 8'd99;
        send_data[31:24] = 8'd101;
        send_data[23:16] = 8'd115;
        send_data[15:8] = 8'd115;
        send_data[7:0] = 8'd33;
    end

    recv_8byte bt_recv_8byte(
        .clk(clk),
        .bt_rxd(bt_rxd),
        .data_32bit(bt_recv_data),
        .refresh(data_refresh)
        );

    send_8byte bt_send_8byte(
        .clk(clk),
        .en(send_en),
        .ascii_data(send_data),
        .bt_txd(bt_txd),
        .done(send_done)
        );

    always@(posedge clk)
    begin
        send_en = data_refresh;
    end

endmodule
