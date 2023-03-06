`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/02 01:43:27
// Design Name: 
// Module Name: wave_out_sim
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


module wave_out_sim;
reg[11:0] ctl;
reg[1:0] select;
wire[7:0] out;

initial
begin
    select = 2'b11;
    ctl = 12'd4;
end
// clockgen 10khz
    reg clk = 0;
    parameter period_clk = 10000;
    always
    begin
        #(period_clk/2) clk <= 1'b0;
        #(period_clk/2) clk <= 1'b1;
    end
wave_out wave_out_tb(
    .clk(clk),
    .wave_selector(select),
    .freq_ctl(ctl),
    .output_wave(out)
    );
endmodule
