`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/01 09:25:25
// Design Name: 
// Module Name: full_adder
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


module full_adder(
    input clk,
    input[11:0] freq_ctl,
    output[7:0] sine_wave,
    output[7:0] square_wave,
    output[7:0] triangle_wave,
    output[7:0] sawtooth_wave
    );

    reg[11:0] addr;

    initial
    begin
        addr <= 12'd0;
    end

    always@(posedge clk)
    begin
        addr <= addr + freq_ctl;
    end

    sine_rom sine(
        .a(addr),
        .clk(clk),
        .spo(sine_wave)
    );
    square_rom square(
        .a(addr),
        .clk(clk),
        .spo(square_wave)
    );
    triangle_rom triangle(
        .a(addr),
        .clk(clk),
        .spo(triangle_wave)
    );
    sawtooth_rom sawtooth(
        .a(addr),
        .clk(clk),
        .spo(sawtooth_wave)
    );
endmodule
