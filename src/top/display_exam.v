`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/29 00:21:36
// Design Name: 
// Module Name: display_exam
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


module display_exam(
    input clk,
    output reg[10:0] dis_seg
    );
    reg[19:0] cnt=0;//FERQDIV
    reg[1:0] sel=0;//sel enable flag
    parameter div=50000;//2khz
    
    always@(posedge clk)
    begin
        cnt<=cnt+1;
        if(cnt==div)
            begin
                cnt<=0;
                sel<=sel+1;
            end
     end

    always@(posedge clk)
    begin
        case(sel)
            0:dis_seg<=11'b1000_1101101;
            1:dis_seg<=11'b0100_1111110;
            2:dis_seg<=11'b0010_0110000;
            3:dis_seg<=11'b0001_1110000;
            default:dis_seg<=11'b0000_0000000;
        endcase
    end

endmodule
