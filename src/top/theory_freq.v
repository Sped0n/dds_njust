`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/01 22:43:27
// Design Name: 
// Module Name: theory_freq
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


module theory_freq(
    input clk,
    input[11:0] freq_ctl,
    output reg[3:0] thou_count,
    output reg[3:0] hund_count,
    output reg[3:0] ten_count,
    output reg[3:0] one_count
    );
    reg[26:0] theo_freq;

    always@(posedge clk)
    begin
        theo_freq <= freq_ctl * 10000 / 4096;
        one_count <= theo_freq % 10;
        ten_count <= theo_freq / 10 % 10;
        hund_count <= theo_freq / 100 % 10;
        thou_count <= theo_freq / 1000;
    end
endmodule
