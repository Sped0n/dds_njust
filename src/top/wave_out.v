`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/01 10:55:26
// Design Name: 
// Module Name: wave_out
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


module wave_out(
    input clk, //10khz clock
    input[1:0] wave_selector,
    input[11:0] freq_ctl,
    output reg[7:0] output_wave
    );

    wire[7:0] sin_input;
    wire[7:0] squ_input;
    wire[7:0] tri_input;
    wire[7:0] saw_input;

    full_adder full_adder_embed(
        .clk(clk),
        .freq_ctl(freq_ctl),
        .sine_wave(sin_input),
        .square_wave(squ_input),
        .triangle_wave(tri_input),
        .sawtooth_wave(saw_input)
        );

    always@(posedge clk)
    begin
        case(wave_selector)
            2'd0: output_wave <= sin_input;
            2'd1: output_wave <= squ_input;
            2'd2: output_wave <= tri_input;
            2'd3: output_wave <= saw_input;
        endcase
    end
endmodule
