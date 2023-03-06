`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/10 21:41:12
// Design Name: 
// Module Name: uart_mux
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


module uart_mux(
    input mode,
    output reg rx,
    input tx,
    input bt_rx,
    output reg bt_tx,
    input serial_rx,
    output reg serial_tx
    );

    always@(*)
    begin
        if (mode == 1)
        begin
            rx <= bt_rx;
            bt_tx <= tx;
        end
        else
        begin
            rx <= serial_rx;
            serial_tx <= tx;
        end
    end
endmodule
