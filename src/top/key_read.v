`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/29 02:52:56
// Design Name: 
// Module Name: key_read
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


module key_read(
    input clk,
    input[5:0] btn_input,//5 buttons + 1 reset
    output[5:0] btn_output
    );

    // button initialization
    reg[5:0] btn_status_0 = 0;
    reg[5:0] btn_status_1 = 0;
    reg[5:0] btn_status_2 = 0;
    // btn_out
    assign btn_output = (btn_status_2 & btn_status_1 & ~btn_status_0) | (btn_status_2 & btn_status_1 & btn_status_0) | (~btn_status_2 & btn_status_1 & btn_status_0);
    
    // status passer
    always @(posedge clk) 
    begin
        btn_status_0 <= btn_input;
        btn_status_1 <= btn_status_0;
        btn_status_2 <= btn_status_1;
    end
endmodule
