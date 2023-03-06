`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/02 09:34:40
// Design Name: 
// Module Name: freq_ctl_data
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


module freq_ctl_data(
    input clk,
    input[11:0] freq_ctl,
    output reg[31:0] freq_ctl_data
    );

    reg[3:0] thou;
    reg[3:0] hund;
    reg[3:0] ten;
    reg[3:0] one;

    initial
    begin
        freq_ctl_data[31:28] = 4'hf;
        freq_ctl_data[27:24] = 4'hf;
        freq_ctl_data[23:20] = 4'hf;
        freq_ctl_data[19:16] = 4'hf;

        thou = 4'd0;
        hund = 4'd0;
        ten = 4'd0;
        one = 4'd0;
    end

    always@(posedge clk)
    begin
        one <= freq_ctl % 10;
        ten <= freq_ctl / 10 % 10;
        hund <= freq_ctl / 100 % 10;
        thou <= freq_ctl / 1000;

        freq_ctl_data[15:12] <= thou;
        freq_ctl_data[11:8] <= hund;
        freq_ctl_data[7:4] <= ten;
        freq_ctl_data[3:0] <= one;
    end
endmodule
