`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/09 18:17:20
// Design Name: 
// Module Name: bt_send_8bit
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


module send_8byte(
    input clk,
    input en,
    input[63:0] ascii_data,
    output bt_txd,
    output reg done
    );

    reg bt_tx_en;
    wire bt_tx_busy;
    wire bt_tx_active;
    reg[3:0] send_count = 4'd0;
    reg[7:0] bt_send_data;
    reg clear;
    reg en_tmp0;
    reg en_tmp1;
    wire start;
    reg send_flag;

    uart_tx uart_tx_bt(
        .clk(clk),
        .uart_data(bt_send_data),
        .uart_tx_en(bt_tx_en),
        .uart_txd(bt_txd),
        .uart_tx_busy(bt_tx_busy),
        .uart_tx_active(bt_tx_active)
        );

    assign start = en_tmp0 & (~en_tmp1);
    always@(posedge clk)
    begin
        en_tmp0 <= en; 
        en_tmp1 <= en_tmp0; 
    end

    always@(posedge clk)
    begin
        if (start == 1'b1)
        begin
            send_flag <= 1'b1;
        end
        else if (done == 1)
        begin
            send_flag <= 1'b0;
        end
    
    end

    always@(negedge bt_tx_busy or posedge done)
    begin
        if (send_count < 4'd8)
        begin
            send_count <= send_count + 4'd1;
        end
        if (done == 1)
        begin
            send_count <= 0;
        end

    end

    always@(posedge clk)
    begin
        if (send_flag == 1)
        begin
            if (bt_tx_busy == 0 && done == 0)
            begin
                case(send_count)
                    4'd0: 
                    begin
                        bt_tx_en <= 1;
                        bt_send_data <= ascii_data[63:56];
                        done <= 0;
                    end
                    4'd1:
                    begin
                        bt_tx_en <= 1;
                        bt_send_data <= ascii_data[55:48];
                        done <= 0;
                    end
                    4'd2:
                    begin
                        bt_tx_en <= 1;
                        bt_send_data <= ascii_data[47:40];
                        done <= 0;
                    end
                    4'd3: 
                    begin
                        bt_tx_en <= 1;
                        bt_send_data <= ascii_data[39:32];
                        done <= 0;
                    end
                    4'd4: 
                    begin
                        bt_tx_en <= 1;
                        bt_send_data <= ascii_data[31:24];
                        done <= 0;
                    end
                    4'd5: 
                    begin
                        bt_tx_en <= 1;
                        bt_send_data <= ascii_data[23:16];
                        done <= 0;
                    end
                    4'd6: 
                    begin
                        bt_tx_en <= 1;
                        bt_send_data <= ascii_data[15:8];
                        done <= 0;
                    end
                    4'd7: 
                    begin
                        bt_tx_en <= 1;
                        bt_send_data <= ascii_data[7:0];
                        done <= 0;
                    end
                    4'd8:
                    begin
                        done <= 1;
                        bt_tx_en <= 0;
                        clear <= 1;
                    end
                endcase
            end
            else
            begin
                bt_tx_en <= 0;
            end
        end
        else
        begin
            if (done != 0)
            begin
                done <= 0;
            end
        end
    end

endmodule
