`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/11 01:05:08
// Design Name: 
// Module Name: dac_mux
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


module dac_mux(
    input mode,
    input[7:0] am,
    input[7:0] dds,
    output reg[7:0] dac
    );
    always@(*)
    begin
        if(mode == 1)
        begin
            dac <= dds;
        end
        else
        begin
            dac <= am;
        end
    end
endmodule
