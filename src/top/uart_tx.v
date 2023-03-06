`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/09 10:42:44
// Design Name: 
// Module Name: uart_tx
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


module uart_tx(
    input clk,
    input[7:0] uart_data,
    input uart_tx_en,
    output reg uart_txd,
    output uart_tx_busy,
    output uart_tx_active
    );

    reg uart_en_tmp0;
    reg uart_en_tmp1;
    reg tx_flag;
    reg[3:0] tx_cnt; // data being transmitted
    reg[15:0] clk_cnt;
    reg[7:0] tx_data; // a caching layer
    wire start; // start transmission flag
    parameter CLK_FREQ = 100_000_000; 
    parameter UART_FREQ = 9600; 
    parameter BSP_CNT = CLK_FREQ/UART_FREQ;

    

    // uart_tx_busy 
    assign uart_tx_busy = tx_flag; 

    // start
    assign start = uart_en_tmp0 & (~uart_en_tmp1);
    assign uart_tx_active = start;
    always@(posedge clk)
    begin
        uart_en_tmp0 <= uart_tx_en; 
        uart_en_tmp1 <= uart_en_tmp0; 
    end

    // clk_cnt 
    always @(posedge clk)
    begin 
        if(tx_flag)
        begin 
            if(clk_cnt < BSP_CNT - 1'd1)
            begin
                clk_cnt <= clk_cnt + 1'd1;
            end
            else
            begin
                clk_cnt <= 16'd0;
            end 
        end 
        else 
            clk_cnt <= 16'd0; 
    end

    // tx_cnt 
    always @(posedge clk)
    begin 
        if(tx_flag)
        begin 
            if(clk_cnt == BSP_CNT - 1'd1)
            begin
                tx_cnt <= tx_cnt + 4'd1;
            end
        end 
        else
        begin
            tx_cnt <= 4'd0;
        end
    end
    // uart_txd 
    always @(posedge clk)
    begin 
        if(tx_flag)
        begin
        case(tx_cnt) 
            4'd0: uart_txd <= 1'd0; 
            4'd1: uart_txd <= tx_data[0]; 
            4'd2: uart_txd <= tx_data[1]; 
            4'd3: uart_txd <= tx_data[2]; 
            4'd4: uart_txd <= tx_data[3]; 
            4'd5: uart_txd <= tx_data[4]; 
            4'd6: uart_txd <= tx_data[5]; 
            4'd7: uart_txd <= tx_data[6]; 
            4'd8: uart_txd <= tx_data[7]; 
            4'd9: uart_txd <= 1'd1; 
            default: uart_txd <= 1'd1; 
            endcase
        end 
        else 
            uart_txd <= 1'd1;
    end

    //tx_data tx_flag 
    always @(posedge clk)
    begin 
        if(start == 1'b1)
        begin 
            tx_data <= uart_data; 
            tx_flag <= 1'b1; 
        end 
        else if ((tx_cnt == 4'd9) && (clk_cnt == BSP_CNT -1'd1))
        begin 
            tx_flag <= 1'b0; 
            tx_data <= 8'd0; 
        end 
    end

endmodule
