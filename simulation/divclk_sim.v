`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/01 08:30:43
// Design Name: 
// Module Name: divclk_sim
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


module divclk_sim;
    wire clk1;
    wire clk2;
    wire clk3;
    wire clk4;
    // clockgen 100mhz
    reg clk = 0;
    parameter period_clk = 10;
    always
    begin
        #(period_clk/2) clk <= 1'b0;
        #(period_clk/2) clk <= 1'b1;
    end

    divclk divclk_tb(
        .clk(clk), 
        .out_clk1(clk1),
        .out_clk2(clk2),
        .out_clk3(clk3),
        .out_clk4(clk4)
        );
endmodule
