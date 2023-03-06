`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/02 08:02:07
// Design Name: 
// Module Name: freq_embed_sim
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


module freq_embed_sim;

// clockgen 100mhz
reg clk = 0;
parameter period_clk = 10;
always
begin
    #(period_clk/2) clk <= 1'b0;
    #(period_clk/2) clk <= 1'b1;
end

reg[11:0] ctl;
reg[1:0] select;
wire clk_10k;
wire clk_05;
wire[7:0] wave;
wire[31:0] data;

initial
begin
    select = 2'b11;
    ctl = 12'd100;
end

divclk divclk_fes(
    .clk(clk),
    .out_clk3(clk_10k),
    .out_clk4(clk_05)
    );

wave_out wave_out_fes(
    .clk(clk_10k),
    .wave_selector(select),
    .freq_ctl(ctl),
    .output_wave(wave)
    );

freq_embed freq_embed_tb(
    .clk_10k(clk_10k),
    .clk_05(clk_05),
    .wave_in(wave),
    .freq_ctl(ctl),
    .freq_data(data)
    );


endmodule
