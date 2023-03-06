`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/02 10:50:14
// Design Name: 
// Module Name: dynamic_ctl
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


module dynamic_ctl(
    input clk_10khz,
    input[7:0] to_DAC,
    input[5:0] btn_value,
    input[7:0] switch,
    input[31:0] freq_data_pool,
    input[31:0] freq_ctl_data_pool,
    input[31:0] uart_recv_data,
    output reg[7:0] LED0,
    output reg[7:0] LED1,
    output reg[1:0] wave_select,
    output reg dac_mode,
    output reg uart_mode,
    output reg[11:0] freq_ctl,
    output reg[31:0] data
    );

    // which number to adjust during number adjust
    reg[5:0] btn_seg_flag;
    // 0 for dds & freq display
    // 1 for dds & freq adjust
    // 2 for dds & num display & num adjust
    reg[1:0] global_mode;
    // whether to enter freq_ctl adjust mode
    reg freq_ctl_flag;
    // display num data pool
    reg[31:0] num_data_pool;
    // am disp pool
    wire[31:0] am_pool;
    assign am_pool[31:16] = 16'haaaa;
    assign am_pool[15:0] = freq_data_pool[31:16];
    // number display pos
    reg[2:0] num_seg_pos;
    // freq adjust pos
    reg[1:0] freq_adj_pos;
    // button last status
    reg[5:0] btn_last_status;
    // reset

    // uart receive data(last)
    reg[31:0] last_uart_recv;
    // uart_disp status
    reg uart_disp;

    // initialization
    initial
    begin
        freq_ctl = 12'd1;
        LED0 = 8'b00000000;
        LED1 = 8'b00000000;
        global_mode = 2'b0;
        btn_last_status = 0;
        // default sin
        wave_select = 2'd0;
        num_seg_pos = 0;
        freq_adj_pos = 0;
        last_uart_recv = 0;
        // default number
        num_data_pool[31:28] = 4'h6;
        num_data_pool[27:24] = 4'h8;
        num_data_pool[23:20] = 4'h0;
        num_data_pool[19:16] = 4'h1;
        num_data_pool[15:12] = 4'h1;
        num_data_pool[11:8] = 4'h0;
        num_data_pool[7:4] = 4'h3;
        num_data_pool[3:0] = 4'h3;
        uart_mode = 1;
        uart_disp = 0;
    end

    always@(posedge clk_10khz)
    begin
        if ((btn_last_status[5] == 0) && (btn_value[5] == 1))
        begin
            global_mode <= global_mode + 2'd1;
        end

        // dds mode
        if (global_mode == 2'd0)
        begin
            dac_mode <= 1;
            if ((btn_last_status[2] == 0) && (btn_value[2] == 1))
            begin
                wave_select <= wave_select + 2'd1;
            end

            case(wave_select)
                2'd0: LED1 <= 8'b11000000;
                2'd1: LED1 <= 8'b00110000;
                2'd2: LED1 <= 8'b00001100;
                2'd3: LED1 <= 8'b00000011;
            endcase

            if (switch != 0)
            begin
                if ((btn_last_status[3] == 0) && (btn_value[3] == 1))
                begin
                    freq_adj_pos <= freq_adj_pos + 2'd1;
                end
                else if ((btn_last_status[0] == 0) && (btn_value[0] == 1))
                begin
                    freq_adj_pos <= freq_adj_pos - 2'd1;
                end

                case (freq_adj_pos)
                    2'd0:
                    begin
                        LED0 <= 8'b00000001;
                    end
                    2'd1:
                    begin
                        LED0 <= 8'b00000010;
                    end
                    2'd2:
                    begin
                        LED0 <= 8'b00000100;
                    end
                    2'd3:
                    begin
                        LED0 <= 8'b00001000;
                    end    
                endcase

                data <= freq_ctl_data_pool;

                if ((btn_last_status[4] == 0) && (btn_value[4] == 1))
                begin
                    case (freq_adj_pos)
                        2'b00: freq_ctl <= freq_ctl + 12'd1;
                        2'b01: freq_ctl <= freq_ctl + 12'd10;
                        2'b10: freq_ctl <= freq_ctl + 12'd100;
                        2'b11: freq_ctl <= freq_ctl + 12'd1000;
                    endcase
                end
                else if ((btn_last_status[1] == 0) && (btn_value[1] == 1))
                begin
                    case (freq_adj_pos)
                        2'b00: freq_ctl <= freq_ctl - 12'd1;
                        2'b01: freq_ctl <= freq_ctl - 12'd10;
                        2'b10: freq_ctl <= freq_ctl - 12'd100;
                        2'b11: freq_ctl <= freq_ctl - 12'd1000;  
                    endcase
                end
            end
            else
            begin
                LED0 <= to_DAC;
                data <= freq_data_pool;
            end
        end
        // am_mod
        else if (global_mode == 2'd1)
        begin
            dac_mode <= 0;
            LED0 <= 8'b0000000;
            LED1 <= to_DAC;
            data <= am_pool;
        end
        // num/uart mode
        else if (global_mode == 2'd2)
        begin
            dac_mode <= 0;
            if (last_uart_recv != uart_recv_data)
            begin
                uart_disp <= 1;
            end

            // uart mode switch
            if ((btn_last_status[2] == 0) && (btn_value[2] == 1))
            begin
                uart_mode <= ~uart_mode;
            end

            if ((btn_last_status[3] == 0) && (btn_value[3] == 1))
            begin
                uart_disp <= 0;
                num_seg_pos <= num_seg_pos + 3'd1;
            end
            else if ((btn_last_status[0] == 0) && (btn_value[0] == 1))
            begin
                uart_disp <= 0;
                num_seg_pos <= num_seg_pos - 3'd1;
            end

            // LED0
            if (uart_disp == 0)
            begin
                case (num_seg_pos)
                    3'd0:
                    begin
                        LED0 <= 8'b00000001;
                    end
                    3'd1:
                    begin
                        LED0 <= 8'b00000010;
                    end
                    3'd2:
                    begin
                        LED0 <= 8'b00000100;
                    end
                    3'd3:
                    begin
                        LED0 <= 8'b00001000;
                    end
                    3'd4:
                    begin
                        LED0 <= 8'b00010000;
                    end
                    3'd5:
                    begin
                        LED0 <= 8'b00100000;
                    end
                    3'd6:
                    begin
                        LED0 <= 8'b01000000;
                    end
                    3'd7:
                    begin
                        LED0 <= 8'b10000000;
                    end
                endcase
            end

            if (uart_mode)
            begin
                LED1 <= 8'b00001111;
            end
            else
            begin
                LED1 <= 8'b11110000;
            end

            if (uart_disp == 1)
            begin
                data <= uart_recv_data;
            end
            else
            begin
                data <= num_data_pool;
            end

            if ((btn_last_status[4] == 0) && (btn_value[4] == 1))
            begin
                uart_disp <= 0;
                case (num_seg_pos)
                    3'd0:
                    begin
                        num_data_pool[3:0] <= num_data_pool[3:0] + 4'h1;
                    end
                    3'd1:
                    begin
                        num_data_pool[7:4] <= num_data_pool[7:4] + 4'h1;
                    end
                    3'd2:
                    begin
                        num_data_pool[11:8] <= num_data_pool[11:8] + 4'h1;
                    end
                    3'd3:
                    begin
                        num_data_pool[15:12] <= num_data_pool[15:12] + 4'h1;
                    end
                    3'd4:
                    begin
                        num_data_pool[19:16] <= num_data_pool[19:16] + 4'h1;
                    end
                    3'd5:
                    begin
                        num_data_pool[23:20] <= num_data_pool[23:20] + 4'h1;
                    end
                    3'd6:
                    begin
                        num_data_pool[27:24] <= num_data_pool[27:24] + 4'h1;
                    end
                    3'd7:
                    begin
                        num_data_pool[31:28] <= num_data_pool[31:28] + 4'h1;
                    end
                endcase
            end
            else if ((btn_last_status[1] == 0) && (btn_value[1] == 1))
            begin
                uart_disp <= 0;
                case (num_seg_pos)
                    3'd0:
                    begin
                        num_data_pool[3:0] <= num_data_pool[3:0] - 4'h1;
                    end
                    3'd1:
                    begin
                        num_data_pool[7:4] <= num_data_pool[7:4] - 4'h1;
                    end
                    3'd2:
                    begin
                        num_data_pool[11:8] <= num_data_pool[11:8] - 4'h1;
                    end
                    3'd3:
                    begin
                        num_data_pool[15:12] <= num_data_pool[15:12] - 4'h1;
                    end
                    3'd4:
                    begin
                        num_data_pool[19:16] <= num_data_pool[19:16] - 4'h1;
                    end
                    3'd5:
                    begin
                        num_data_pool[23:20] <= num_data_pool[23:20] - 4'h1;
                    end
                    3'd6:
                    begin
                        num_data_pool[27:24] <= num_data_pool[27:24] - 4'h1;
                    end
                    3'd7:
                    begin
                        num_data_pool[31:28] <= num_data_pool[31:28] - 4'h1;
                    end
                endcase
            end
        end
        else
        begin
            global_mode <= 2'd0;
        end
        btn_last_status <= btn_value;
        last_uart_recv <= uart_recv_data;
    end
endmodule