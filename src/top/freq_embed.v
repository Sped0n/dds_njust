`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/02 07:03:05
// Design Name: 
// Module Name: freq_embed
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


module freq_embed(
    input clk_10k,
    input clk_05,
    input[7:0] wave_in,
    input[11:0] freq_ctl,
    output reg[31:0] freq_data
    );
    
    // get theoretical frequency data
    wire[3:0] theo_thou;
    wire[3:0] theo_hund;
    wire[3:0] theo_ten;
    wire[3:0] theo_one;

    theory_freq theory_freq_embed(
        .clk(clk_10k),
        .freq_ctl(freq_ctl),
        .thou_count(theo_thou),
        .hund_count(theo_hund),
        .ten_count(theo_ten),
        .one_count(theo_one)
        );

    //get real frequency data
    wire[3:0] real_thou;
    wire[3:0] real_hund;
    wire[3:0] real_ten;
    wire[3:0] real_one;
    
    real_freq real_freq_embed(
        .clk(clk_05),
        .wave(wave_in),
        .thou_count(real_thou),
        .hund_count(real_hund),
        .ten_count(real_ten),
        .one_count(real_one)
        );

    always@(posedge clk_10k)
    begin
        // real frequency
        freq_data[31:28] <= real_thou;
        freq_data[27:24] <= real_hund;
        freq_data[23:20] <= real_ten;
        freq_data[19:16] <= real_one;
        // theoretical frequency
        freq_data[15:12] <= theo_thou;
        freq_data[11:8] <= theo_hund;
        freq_data[7:4] <= theo_ten;
        freq_data[3:0] <= theo_one;
    end

endmodule
