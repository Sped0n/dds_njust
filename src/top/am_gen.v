`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/10 23:06:11
// Design Name: 
// Module Name: am_gen
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


module am_gen(
    input clk,
    output signed[7:0] sin_s,
    output signed[7:0] sin_c
    );

    parameter freq_s = 7'd64;
    parameter freq_c = 11'd1920;
    parameter cnt_width = 8'd15;
    
    reg [cnt_width-1:0] cnt_s;
    reg [cnt_width-1:0] cnt_c;

    wire [11:0] addr_s;
    wire [11:0] addr_c;

    wire signed[7:0] raw_s;
    wire signed[7:0] raw_c;

    initial
    begin
        cnt_s = 0;
        cnt_c = 0;
    end

    always @(posedge clk) 
    begin
        cnt_s <= cnt_s + freq_s;
        cnt_c <= cnt_c + freq_c; 
    end

    assign addr_s = cnt_s[cnt_width-1:cnt_width-12]; 
    assign addr_c = cnt_c[cnt_width-1:cnt_width-12]; 

    assign sin_s = raw_s + 8'd128;
    assign sin_c = raw_c + 8'd128;

    sine_rom sine_am_s(
        .a(addr_s),
        .clk(clk),
        .spo(raw_s)
    );

    sine_rom sine_am_c(
        .a(addr_c),
        .clk(clk),
        .spo(raw_c)
    );

endmodule
