`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/02 02:21:16
// Design Name: 
// Module Name: real_freq_sim
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


module real_freq_sim;
reg[11:0] ctl;
wire[7:0] sine;
wire clk_10khz;
wire clk_05hz;
wire[3:0] thou;
wire[3:0] hund;
wire[3:0] ten;
wire[3:0] one;
// clockgen 100mhz
reg clk = 0;
parameter period_clk = 10;
always
begin
    #(period_clk/2) clk <= 1'b0;
    #(period_clk/2) clk <= 1'b1;
end

initial
begin
    ctl = 12'd100;
end


divclk divclk_tb(
    .clk(clk), 
    .out_clk3(clk_10khz),
    .out_clk4(clk_05hz)
    );

full_adder full_adder_tb(
    .clk(clk_10khz),
    .freq_ctl(ctl),
    .sine_wave(sine)
    );

real_freq real_freq_tb(
    .clk(clk_05hz),
    .wave(sine),
    .thou_count(thou),
    .hund_count(hund),
    .ten_count(ten),
    .one_count(one)
    );
endmodule
