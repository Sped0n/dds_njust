`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/02 00:13:33
// Design Name: 
// Module Name: theory_freq_sim
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


module theory_freq_sim;
reg[11:0] ctl;
wire[3:0] thou;
wire[3:0] hund;
wire[3:0] ten;
wire[3:0] one;

initial
begin
    ctl = 12'd1234;
end
// clockgen 10khz
reg clk = 0;
parameter period_clk = 100000;
always
begin
    #(period_clk/2) clk <= 1'b0;
    #(period_clk/2) clk <= 1'b1;
end

theory_freq theory_freq_tb(
    .clk(clk),
    .freq_ctl(ctl),
    .thou_count(thou),
    .hund_count(hund),
    .ten_count(ten),
    .one_count(one)
    );
endmodule
