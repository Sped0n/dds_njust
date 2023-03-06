`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/29 08:33:45
// Design Name: 
// Module Name: divclk
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


module divclk(
    input clk,
    output reg out_clk1,
    output reg out_clk2,
    output reg out_clk3,
    output reg out_clk4
    );

    reg[31:0] out_clk1_cnt = 0;
    reg[31:0] out_clk2_cnt = 0;
    reg[31:0] out_clk3_cnt = 0;
    reg[31:0] out_clk4_cnt = 0;

    initial
    begin
      out_clk1 = 0;
      out_clk2 = 0;
      out_clk3 = 0;
      out_clk4 = 0;
    end

    parameter div_1ms = 49999;
    parameter div_20ms = 999999;
    parameter div_10khz = 4999;
    parameter div_05hz = 99999999;
    // 1ms clock
    always@(posedge clk)
    begin
        out_clk1_cnt <= out_clk1_cnt + 1;
        if (out_clk1_cnt == div_1ms)
        begin
            out_clk1 <= ~out_clk1;
            out_clk1_cnt <= 0;
        end
    end
    // 20ms clock
    always@(posedge clk)
    begin
      out_clk2_cnt <= out_clk2_cnt + 1;
      if (out_clk2_cnt == div_20ms) 
      begin
        out_clk2 <= ~out_clk2;
        out_clk2_cnt <= 0;
      end
    end
    // 10kHz clock
    always@(posedge clk)
    begin
      out_clk3_cnt <= out_clk3_cnt + 1;
      if (out_clk3_cnt == div_10khz) 
      begin
        out_clk3 <= ~out_clk3;
        out_clk3_cnt <= 0;
      end
    end
    // 0.5Hz clock
    always@(posedge clk)
    begin
      out_clk4_cnt <= out_clk4_cnt + 1;
      if (out_clk4_cnt == div_05hz) 
      begin
        out_clk4 <= ~out_clk4;
        out_clk4_cnt <= 0;
      end
    end
endmodule
