`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/01 09:49:53
// Design Name: 
// Module Name: full_adder_sim
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


module full_adder_sim;
    reg[11:0] ctl;
    wire[7:0] sin_wav;
    wire[7:0] tri_wav;
    wire[7:0] squ_wav;
    wire[7:0] saw_wav;

    initial
    begin
        ctl <= 12'd100;
    end
    // clockgen 10khz
    reg clk = 0;
    parameter period_clk = 10000;
    always
    begin
        #(period_clk/2) clk <= 1'b0;
        #(period_clk/2) clk <= 1'b1;
    end

    full_adder full_adder_tb(
        .clk(clk),
        .freq_ctl(ctl),
        .sine_wave(sin_wav),
        .square_wave(squ_wav),
        .triangle_wave(tri_wav),
        .sawtooth_wave(saw_wav)
    );
endmodule
