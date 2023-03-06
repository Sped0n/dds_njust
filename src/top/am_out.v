`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/10 23:50:14
// Design Name: 
// Module Name: am_out
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


module am_out(
    input clk,
    output reg[7:0] am_wave
    );

    wire[7:0] sc;
    wire[7:0] ss;
    wire[15:0] raw;
    reg[7:0] raw_tmp;

    am_gen am_gen_out(
        .clk(clk),
        .sin_s(ss),
        .sin_c(sc)
        );

    mult mult_am(
        .CLK(clk),
        .A(ss),
        .B(sc),
        .P(raw)
        );

    always@(posedge clk)
    begin
        raw_tmp = raw[15:8];
        am_wave = raw_tmp + 8'd128;
    end
    
endmodule
