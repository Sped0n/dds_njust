`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/11 00:01:49
// Design Name: 
// Module Name: am_out_sim
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


module am_out_sim;

wire[7:0] out;
// clockgen 10khz
reg clk = 0;
parameter period_clk = 10000;
always
begin
    #(period_clk/2) clk <= 1'b0;
    #(period_clk/2) clk <= 1'b1;
end

am_out am_out_tb(
    .clk(clk),
    .am_wave(out)
);
endmodule
