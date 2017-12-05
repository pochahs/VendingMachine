`timescale 1ns / 1ps

module SevenSegment(clk, rst ,value, SEG);

      input clk, rst;
      input [6:0] value;
      output[27:0] SEG;
      
      reg[31:0] count;
      reg clk_10000;

      reg[27:0] SEG;
      
      reg value_h, value_t;  
      
      always@(posedge clk or negedge rst) begin
           if(!rst) begin
                count <= 32'd0;
                clk_10000<=0;
           end
           else begin
                if(count == 'd10000) begin
                    count <= 32'd0;
                    clk_10000 <= ~clk_10000;
                end
                else begin
                    count <= count +1;
                end
           end
      end     
      
      always @(posedge clk) begin
           if(rst==1) begin
                value_h = value%10;
                value_t = value/10; 
           end
           
           SEG[6:0] <= 7'b0000001;
           SEG[13:7] <= 7'b0000001; 
        
      case(value_h)
           0: SEG[20:14] = 7'b0000001;
           1: SEG[20:14] = 7'b1001111;
           2: SEG[20:14] = 7'b0010010;
           3: SEG[20:14] = 7'b0000110;
           4: SEG[20:14] = 7'b1001100;
           5: SEG[20:14] = 7'b0100100;
           6: SEG[20:14] = 7'b0100000;
           7: SEG[20:14] = 7'b0001111;
           8: SEG[20:14] = 7'b0000000;
           9: SEG[20:14] = 7'b0000100;
           default: SEG[20:14] = 7'b0;
      endcase

      case(value_t)
           0: SEG[27:21] = 7'b0000001;
           1: SEG[27:21] = 7'b1001111;
           2: SEG[27:21] = 7'b0010010;
           3: SEG[27:21] = 7'b0000110;
           4: SEG[27:21] = 7'b1001100;
           5: SEG[27:21] = 7'b0100100;
           6: SEG[27:21] = 7'b0100000;
           7: SEG[27:21] = 7'b0001111;
           8: SEG[27:21] = 7'b0000000;
           9: SEG[27:21] = 7'b0000100;
           default: SEG[27:21] = 7'b0;
      endcase
      end

endmodule