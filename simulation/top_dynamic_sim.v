`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/08 12:32:53
// Design Name: 
// Module Name: top_dynamic_sim
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


module top_dynamic_sim;
// clockgen 100mhz
reg clk = 0;
parameter period_clk = 10;
always
begin
    #(period_clk/2) clk <= 1'b0;
    #(period_clk/2) clk <= 1'b1;
end
reg[5:0] btn_in;
reg[7:0] switch;
wire[7:0] seg0;
wire[7:0] seg1;
wire[7:0] seg_flag;
wire[7:0] LED;
wire[7:0] wave;

initial
begin
    btn_in = 0;
    switch = 0;
end
top_dynamic top_dynamic_tb(
    .clk(clk),
    .btn_in(btn_in),
    .switch(switch),
    .seg0(seg0),
    .seg1(seg1),
    .seg_flag(seg_flag),
    .LED(LED),
    .toDAC(wave)
    );
endmodule
