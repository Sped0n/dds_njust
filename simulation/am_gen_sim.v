`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/10 23:32:10
// Design Name: 
// Module Name: am_gen_sim
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


module am_gen_sim;

wire[7:0] ss;
wire[7:0] sc;

// clockgen 10khz
reg clk = 0;
parameter period_clk = 10000;
always
begin
    #(period_clk/2) clk <= 1'b0;
    #(period_clk/2) clk <= 1'b1;
end

am_gen am_gen_tb(
    .clk(clk),
    .sin_s(ss),
    .sin_c(sc)
);
endmodule
