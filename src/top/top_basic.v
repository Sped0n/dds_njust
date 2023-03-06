`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/29 21:12:56
// Design Name: 
// Module Name: top_basic
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


module top_basic(
    input clk,
    input[4:0] btn_input,
    output[7:0] seg0,
    output[7:0] seg1,
    output[7:0] seg_flag,
    output[7:0] LED
    );

    wire[4:0] btn_out;
    reg[31:0] data_pool;
    reg[2:0] blink = 0;
    reg[3:0] i = 0;
    reg[4:0] btn_seg_flag = 5'd0;
    reg[7:0] LED = 8'b00000001;

    initial 
    begin
        data_pool[31:28] = 4'h2;
        data_pool[27:24] = 4'h0;
        data_pool[23:20] = 4'h2;
        data_pool[19:16] = 4'h2;
        data_pool[15:12] = 4'h2;
        data_pool[11:8] = 4'h1;
        data_pool[7:4] = 4'h4;
        data_pool[3:0] = 4'hc;
    end
    
    always@(posedge btn_out[0])
    begin
        case (btn_seg_flag)
            5'd0:
            begin
                data_pool[3:0] = data_pool[3:0] + 4'h1;
            end
            5'd4:
            begin
                data_pool[7:4] = data_pool[7:4] + 4'h1;
            end
            5'd8:
            begin
                data_pool[11:8] = data_pool[11:8] + 4'h1;
            end
            5'd12:
            begin
                data_pool[15:12] = data_pool[15:12] + 4'h1;
            end
            5'd16:
            begin
                data_pool[19:16] = data_pool[19:16] + 4'h1;
            end
            5'd20:
            begin
                data_pool[23:20] = data_pool[23:20] + 4'h1;
            end
            5'd24:
            begin
                data_pool[27:24] = data_pool[27:24] + 4'h1;
            end
            5'd28:
            begin
                data_pool[31:28] = data_pool[31:28] + 4'h1;
            end
        endcase
    end

    always@(posedge btn_out[1])
    begin
        btn_seg_flag = btn_seg_flag + 4;
        case (btn_seg_flag)
            5'd0:
            begin
                LED = 8'b00000001;
            end
            5'd4:
            begin
                LED = 8'b00000010;
            end
            5'd8:
            begin
                LED = 8'b00000100;
            end
            5'd12:
            begin
                LED = 8'b00001000;
            end
            5'd16:
            begin
                LED = 8'b00010000;
            end
            5'd20:
            begin
                LED = 8'b00100000;
            end
            5'd24:
            begin
                LED = 8'b01000000;
            end
            5'd28:
            begin
                LED = 8'b10000000;
            end
            default:
            begin
                LED = 8'b00000000;
            end
        endcase
    end

    divclk divclk_tpb(
        .clk(clk), 
        .out_clk(clk_1khz), 
        .btn_clk(clk_20ms)
        );
    seg_ctl seg_disp(
        .clk(clk),
        .clk_1ms(clk_1khz),
        .disp_data_pool(data_pool),
        .blink_flag(blink),
        .seg0(seg0),
        .seg1(seg1),
        .seg_flag(seg_flag)
        );
    key_read keyread_tpb(
        .clk(clk),
        .btn_clk(clk_20ms),
        .btn_input(btn_input),
        .btn_output(btn_out)
        );
endmodule
