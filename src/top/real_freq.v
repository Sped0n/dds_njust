`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/02 02:04:36
// Design Name: 
// Module Name: real_freq
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


module real_freq(
    input clk,
    input[7:0] wave,
    output reg[3:0] thou_count,
    output reg[3:0] hund_count,
    output reg[3:0] ten_count,
    output reg[3:0] one_count
    );
    reg[19:0] freq_tmp;
    reg[19:0] freq_count;
    reg half;
    initial
    begin
        freq_count <= 20'd0;
        freq_tmp <= 20'd0;
    end

    always@(*)
    begin
        if(wave <= 8'd127)
        begin
            half <= 1'b0;
        end
        else
        begin
            half <= 1'b1;
        end
    end

    always@(posedge half)
    begin
        if(clk == 0)
        begin
            freq_tmp <= freq_tmp + 1;
        end
        else
        begin
            if(freq_tmp != 0)
            begin
                freq_count <= freq_tmp;
            end
            freq_tmp <= 0;
        end
    end

    always@(negedge clk)
    begin
        one_count <= freq_count % 10;
        ten_count <= (freq_count / 10) % 10;
        hund_count <= (freq_count / 100) % 10;
        thou_count <= freq_count / 1000;
    end

endmodule
