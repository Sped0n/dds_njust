`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/29 09:07:30
// Design Name: 
// Module Name: seg_ctl
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


module seg_ctl(
    input clk, // 1khz clock
    input[31:0] disp_data_pool, // 8*4
    output reg[7:0] seg0, // left
    output reg[7:0] seg1, // right
    output reg[7:0] seg_flag // seg choose
    );
    reg[3:0] disp_data; // the data needed to display
    reg[2:0] dyn_disp_flag; // dynamic refresh
    // initialization
    initial
    begin
      seg0 = 0;
      seg1 = 0;
      seg_flag = 8'b00000001; // which seg to display
      disp_data = 0;
      dyn_disp_flag = 0;
    end
    // dynamic refresh
    always@(posedge clk)
    begin
        dyn_disp_flag <= dyn_disp_flag + 1;
        case (dyn_disp_flag)
          3'b000:
          begin
            disp_data <= disp_data_pool[3:0];
            seg_flag <= 8'b00000001;
          end
          3'b001:
          begin
            disp_data <= disp_data_pool[7:4];
            seg_flag <= 8'b00000010;
          end
          3'b010:
          begin
            disp_data <= disp_data_pool[11:8];
            seg_flag <= 8'b00000100;
          end
          3'b011:
          begin
            disp_data <= disp_data_pool[15:12];
            seg_flag <= 8'b00001000;
          end
          3'b100:
          begin
            disp_data <= disp_data_pool[19:16];
            seg_flag <= 8'b00010000;
          end
          3'b101:
          begin
            disp_data <= disp_data_pool[23:20];
            seg_flag <= 8'b00100000;
          end
          3'b110:
          begin
            disp_data <= disp_data_pool[27:24];
            seg_flag <= 8'b01000000;
          end
          3'b111:
          begin
            disp_data <= disp_data_pool[31:28];
            seg_flag <= 8'b10000000;
          end
          default:
          begin
            disp_data <= 0;
            seg_flag <= 8'b00000000;
          end
        endcase
    end

    always@(seg_flag)
    begin
      if (seg_flag > 8'b00001000)
      begin
        case (disp_data)
          4'h0 : seg0 <= 8'hfc;
          4'h1 : seg0 <= 8'h60;
          4'h2 : seg0 <= 8'hda;
          4'h3 : seg0 <= 8'hf2;
          4'h4 : seg0 <= 8'h66;
          4'h5 : seg0 <= 8'hb6;
          4'h6 : seg0 <= 8'hbe;
          4'h7 : seg0 <= 8'he0;
          4'h8 : seg0 <= 8'hfe;
          4'h9 : seg0 <= 8'hf6;
          4'ha : seg0 <= 8'hee;
          4'hb : seg0 <= 8'h3e;
          4'hc : seg0 <= 8'h9c;
          4'hd : seg0 <= 8'h7a;
          4'he : seg0 <= 8'h9e;
          4'hf : seg0 <= 8'h8e;
        endcase
      end
      else
      begin
        case (disp_data)
          4'h0 : seg1 <= 8'hfc;
          4'h1 : seg1 <= 8'h60;
          4'h2 : seg1 <= 8'hda;
          4'h3 : seg1 <= 8'hf2;
          4'h4 : seg1 <= 8'h66;
          4'h5 : seg1 <= 8'hb6;
          4'h6 : seg1 <= 8'hbe;
          4'h7 : seg1 <= 8'he0;
          4'h8 : seg1 <= 8'hfe;
          4'h9 : seg1 <= 8'hf6;
          4'ha : seg1 <= 8'hee;
          4'hb : seg1 <= 8'h3e;
          4'hc : seg1 <= 8'h9c;
          4'hd : seg1 <= 8'h7a;
          4'he : seg1 <= 8'h9e;
          4'hf : seg1 <= 8'h8e;
        endcase
      end
    end
endmodule
