`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/02 09:51:48
// Design Name: 
// Module Name: freq_ctl_data_sim
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


module freq_ctl_data_sim;
// clockgen 100mhz
reg clk = 0;
parameter period_clk = 10;
always
begin
    #(period_clk/2) clk <= 1'b0;
    #(period_clk/2) clk <= 1'b1;
end

wire[31:0] data;

reg[11:0] freq_ctl = 12'd1234;

freq_ctl_data freq_ctl_data_tb(
    .clk(clk),
    .freq_ctl(freq_ctl),
    .freq_ctl_data(data)
    );
endmodule
