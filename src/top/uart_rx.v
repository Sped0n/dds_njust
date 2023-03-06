`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/09 10:41:17
// Design Name: 
// Module Name: uart_rx
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


module uart_rx(
    input clk, // 100mhz clock
    input uart_rxd, // raw data
    output reg[7:0] uart_data,
    output reg uart_rx_done
    );

    reg uart_rxd_tmp0;
    reg uart_rxd_tmp1;
    reg rx_flag;
    reg[3:0] rx_cnt;
    reg[15:0] clk_cnt;
    reg[7:0] rx_data;
    reg[3:0] last_rx_cnt;
    wire start;
    // config
    parameter CLK_FREQ = 100_000_000; 
    parameter UATR_FREQ = 9600; 
    parameter BSP_CNT = CLK_FREQ/UATR_FREQ;

    initial 
    begin
        rx_cnt = 0;
        rx_flag = 0;
        uart_rxd_tmp0 = 0;
        uart_rxd_tmp1 = 0;
        clk_cnt = 0;
        rx_data = 0;
        last_rx_cnt = 0;
        uart_rx_done = 0;
    end

    // start
    assign start = uart_rxd_tmp1 & (~uart_rxd_tmp0);
    always @(posedge clk)
    begin 
        uart_rxd_tmp0 <= uart_rxd; 
        uart_rxd_tmp1 <= uart_rxd_tmp0; 
    end

    //rx_flag 
    always @(posedge clk)
    begin 
        if(start)
        begin
            rx_flag <= 1'd1;
        end
        else if(rx_cnt == 4'd9 && clk_cnt == BSP_CNT/2 - 1'd1)
        begin
            rx_flag <= 1'd0; 
        end
    end

    // clk_cnt 
    always @(posedge clk)
    begin 
        if (rx_flag)
        begin 
            if (clk_cnt < BSP_CNT - 1'd1)
            begin
                clk_cnt <= clk_cnt + 1'd1;
            end
            else
            begin
                clk_cnt <= 16'd0; 
            end
        end 
        else
        begin
            clk_cnt <= 16'd0;
        end
    end
    
    // rx_cnt
    always @(posedge clk)
    begin 
        last_rx_cnt <= rx_cnt;
        if (rx_flag)
        begin 
            if (clk_cnt == BSP_CNT - 1'd1)
            begin
                rx_cnt <= rx_cnt + 4'd1;
            end
        end 
        else
        begin
            rx_cnt <= 4'd0;
        end 
    end

    // rx_data
    always @(posedge clk)
    begin 
        if (rx_flag)
        begin
            if (clk_cnt == BSP_CNT/2)
            begin 
                case(rx_cnt)
                    4'd1: rx_data[0] <= uart_rxd_tmp1; 
                    4'd2: rx_data[1] <= uart_rxd_tmp1; 
                    4'd3: rx_data[2] <= uart_rxd_tmp1; 
                    4'd4: rx_data[3] <= uart_rxd_tmp1; 
                    4'd5: rx_data[4] <= uart_rxd_tmp1; 
                    4'd6: rx_data[5] <= uart_rxd_tmp1; 
                    4'd7: rx_data[6] <= uart_rxd_tmp1; 
                    4'd8: rx_data[7] <= uart_rxd_tmp1;
                    default:; 
                endcase
            end
        end
        else
        begin 
            rx_data <= 8'd0;
        end
    end

    //rx_data 
    always @(posedge clk)
    begin 
        if (rx_cnt == 4'd9 && last_rx_cnt != 4'd9)
        begin 
            uart_rx_done <= 1'd1;
            uart_data <= rx_data;
        end
        else 
        begin
            uart_rx_done <= 1'd0;  
            uart_data <= 0;
        end
    end
endmodule
