`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/02 05:59:39
// Design Name: 
// Module Name: top_dynamic
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


module top_dynamic(
    input clk,
    input[5:0] btn_in,
    input[7:0] switch,
    input burx,
    input surx,
    output[7:0] seg0,
    output[7:0] seg1,
    output[7:0] seg_flag,
    output[7:0] LED0,
    output[7:0] LED1,
    output[7:0] toDAC,
    output DAC_ILE,
    output DAC_CS,
    output DAC_WR1,
    output DAC_WR2,
    output DAC_XFER,
    output butx,
    output sutx,
    output reg bt_master=1 , bt_sw_hw=0 , bt_rst=1 , bt_sw=1 , bt_pw=1
    );

    reg[5:0] btn_seg_flag;
    reg freq_ctl_flag;
    reg[31:0] num_data_pool;

    reg[1:0] adjust_ctl_flag;

    // DAC param initialization
    assign DAC_ILE = 1;
    assign DAC_CS = 0;
    assign DAC_WR1 = 0;
    assign DAC_WR2 = 0;
    assign DAC_XFER = 0;

    // bluetooth param initialization

    // clock divider
    wire clk_1ms;
    wire clk_20ms;
    wire clk_10khz;
    wire clk_05hz;

    divclk divclk_dds(
        .clk(clk),
        .out_clk1(clk_1ms),
        .out_clk2(clk_20ms),
        .out_clk3(clk_10khz),
        .out_clk4(clk_05hz)
        );
    
    // button input
    wire[5:0] btn_out;

    key_read keyread_dds(
        .clk(clk_20ms),
        .btn_input(btn_in),
        .btn_output(btn_out)
        );

    // display
    wire[31:0] disp_data_pool;
    seg_ctl seg_ctl_dds(
        .clk(clk_1ms),
        .disp_data_pool(disp_data_pool),
        .seg0(seg0),
        .seg1(seg1),
        .seg_flag(seg_flag)
        );

    wire dac_mode;
    wire dds_clk;
    wire am_clk;

    assign dds_clk = clk_10khz & dac_mode;
    assign am_clk = clk_10khz & (~dac_mode);

    // dds
    wire[1:0] wave_select;
    wire[11:0] freq_ctl;
    wire[7:0] dds_mux;

    wave_out wave_out_dds(
        .clk(dds_clk),
        .wave_selector(wave_select),
        .freq_ctl(freq_ctl),
        .output_wave(dds_mux)
        );

    // am
    wire[7:0] am_mux;
    am_out am_out_dynamic(
        .clk(am_clk),
        .am_wave(am_mux)
        );

    // dac mux
    dac_mux dac_mux_dynamic(
        .mode(dac_mode),
        .am(am_mux),
        .dds(dds_mux),
        .dac(toDAC)
        );

    // theoretical frequency & real frequency display data to display
    wire[31:0] freq_data_pool;

    freq_embed freq_embed_dds(
        .clk_10k(clk_10khz),
        .clk_05(clk_05hz),
        .wave_in(toDAC),
        .freq_ctl(freq_ctl),
        .freq_data(freq_data_pool)
        );

    // process freq_ctl_data that needed to display
    wire[31:0] freq_ctl_data_pool;

    freq_ctl_data freq_ctl_data_dds(
        .clk(clk_10khz),
        .freq_ctl(freq_ctl),
        .freq_ctl_data(freq_ctl_data_pool)
        );

    // uart mux
    wire uart_rx;
    wire uart_tx;
    wire uart_mode;

    uart_mux uart_mux_dynamic(
        .mode(uart_mode),
        .rx(uart_rx),
        .tx(uart_tx),
        .bt_rx(burx),
        .bt_tx(butx),
        .serial_rx(surx),
        .serial_tx(sutx)
        );
    
    // uart
    wire[31:0] uart_recv_data;
    bt_recv_response bt_recv_response_dynamic(
        .clk(clk),
        .bt_rxd(uart_rx),
        .bt_recv_data(uart_recv_data),
        .bt_txd(uart_tx)
        );

    // main control function
    dynamic_ctl dynamic_ctl_dds(
        .clk_10khz(clk_10khz),
        .to_DAC(toDAC),
        .btn_value(btn_out),
        .switch(switch),
        .freq_data_pool(freq_data_pool),
        .freq_ctl_data_pool(freq_ctl_data_pool),
        .uart_recv_data(uart_recv_data),
        .LED0(LED0),
        .LED1(LED1),
        .wave_select(wave_select),
        .dac_mode(dac_mode),
        .uart_mode(uart_mode),
        .freq_ctl(freq_ctl),
        .data(disp_data_pool)
        );      

endmodule
