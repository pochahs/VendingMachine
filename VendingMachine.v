`timescale 1ns / 1ps

module VendingMachine (L_button, R_button, C_button, clk, rst, switch, DIGIT, SEG, LED);

parameter price0 = 7;
parameter price1 = 5;
parameter price2 = 6;
parameter price3 = 10;
parameter price4 = 8; 

input L_button, R_button, C_button;
input clk, rst;
input [3:0] switch;

output [7:0] DIGIT;
output [6:0] SEG;
output [9:0] LED;

reg state, nextstate;
reg [6:0] sum, nextsum;
reg [7:0] DIGIT;
reg [9:0] LED;
reg [6:0] SEG;
reg [27:0] SEG1, SEG2;

reg [6:0] a;

always @(switch) begin //АЁАн update
   if(switch[0]==1) nextsum = sum + 1;
   if(switch[1]==1) nextsum = sum + 5;
   if(switch[2]==1) nextsum = sum + 10;
   if(switch[3]==1) nextsum = sum + 20;
end

always @(posedge clk) begin
     if(!rst) 
     begin
          LED <= 0;
          state <= 0;
          sum <= 0;
          DIGIT <= 8'b11111110;
     end
     
     else
     begin
          state<=nextstate; 
          sum<=nextsum;
          if (sum>=price4) LED[4]<=1;
          else LED[4]<=0; 
          if (sum>=price3) LED[3]<=1;
          else LED[3]<=0;
          if (sum>=price2) LED[2]<=1;
          else LED[2]<=0;
          if (sum>=price1) LED[1]<=1;
          else LED[1]<=0;
          if (sum>=price0) LED[0]<=1;
          else LED[0]<=0;
      end
end

always @(state or L_button or R_button)
begin
    case (state)
        0:
                begin //SEG2 0000 
                    if (LED[4]) nextstate=1;
                    else if (LED[3]) nextstate = 2;
                    else if (LED[2]) nextstate = 3;
                    else if (LED[1]) nextstate = 4;
                    else if (LED[0]) nextstate = 5;
                    else nextstate = 0;
                end 

        1: 
               begin //SEG2 0700
                                
                    LED[9] = 0; 
                    if (L_button & ~R_button) nextstate = 5;
                    else if (~L_button & R_button) nextstate = 2;
                    else nextstate = 6;
                    a = price4; 
                                        
                    if(C_button)
                         begin
                            nextsum=sum-price4;
                         end
               end           

        2: 
               begin //SEG2 0550
                                                   
                    LED[8] = 0; 
                    if (L_button & ~R_button) nextstate = 1;
                    else if (~L_button & R_button) nextstate = 3; 
                    else nextstate = 7; 
                    a = price3;
                    
                    if(C_button)
                        begin
                            nextsum=sum-price3;
                        end
                end

        3: 
               begin //SEG2 0600
                                                
                    LED[7] = 0; 
                    if (L_button & ~R_button) nextstate = 2; 
                    else if (~L_button & R_button) nextstate = 4; 
                    else nextstate = 8;  
                    a = price2;
                    
                    if(C_button)
                        begin
                            nextsum=sum-price2;
                        end
                end

        4: 
               begin //SEG2 1000
                    
                    LED[6] = 0; 
                    if (L_button & ~R_button) nextstate = 3; 
                    else if (~L_button & R_button) nextstate = 5; 
                    else nextstate = 9; 
                    a = price1; 
                    
                    if(C_button)
                        begin
                            nextsum=sum-price1;
                        end
                end

        5: 
                begin //SEG2 0800 
                
                    LED[5] = 0; 
                    if (L_button & ~R_button) nextstate = 4;
                    else if (~L_button & R_button) nextstate = 1; 
                    else nextstate = 10; 
                    a = price0;
                    
                    if(C_button)
                        begin
                            nextsum=sum-price0;
                        end
                end

        6: 
                begin //SEG2 0800 
                
                    LED[8] = 0;
                    LED[5] = 0;
                    LED[9] = 1;
                    if (L_button & ~R_button) nextstate = 5;
                    else if (~L_button & R_button) nextstate = 2;
                    else nextstate = 1; 
                    a = price4;
                    
                    if(C_button)
                        begin
                            nextsum=sum-price4;
                        end
                end 

        7: 
                begin //SEG2 0800 
                    
                    LED[7] = 0;
                    LED[9] = 0;
                    LED[8] = 1;
                    if (L_button & ~R_button) nextstate = 1;
                    else if (~L_button & R_button) nextstate = 3; 
                    else nextstate = 2; 
                    a = price3;

                    if(C_button)
                        begin
                            nextsum=sum-price3;
                        end
                end 

        8: 
                begin
                    
                    LED[6] = 0;
                    LED[8] = 0;
                    LED[7] = 1;
                    if (L_button & ~R_button) nextstate = 2;
                    else if (~L_button & R_button) nextstate = 4; 
                    else nextstate = 3;
                    a = price2;
                    
                    if(C_button)
                        begin
                            nextsum=sum-price2;
                        end
                end 

        9: 
                begin //SEG2 0800 
                   
                    LED[5] = 0;
                    LED[7] = 0;
                    LED[6] = 1;
                    if (L_button & ~R_button) nextstate = 3;
                    else if (~L_button & R_button) nextstate = 5;
                    else nextstate = 4; 
                    a = price1;
    
                    if(C_button)
                        begin
                            nextsum=sum-price1;
                        end

                end 

        10: 
               begin //SEG2 0800 
                                                 
                    LED[4] = 0;
                    LED[6] = 0;
                    LED[5] = 1;
                    if (L_button & ~R_button) nextstate = 4;
                    else if (~L_button & R_button) nextstate = 1;
                    else nextstate = 5;
                    a = price0;

                    if(C_button)
                        begin
                            nextsum=sum-price0;
                        end
                end
endcase
end

always @(DIGIT or SEG1 or SEG2) begin//update price
      case(DIGIT)
            8'b11111110: SEG = SEG1[6:0];
            8'b11111101: SEG = SEG1[13:7];
            8'b11111011: SEG = SEG1[20:14];
            8'b11110111: SEG = SEG1[27:21]; 
            8'b11101111: SEG = SEG2[6:0];
            8'b11011111: SEG = SEG2[13:7];
            8'b10111111: SEG = SEG2[20:14];
            8'b01111111: SEG = SEG2[27:21];
            default: SEG = 7'b0;
      endcase
end

SevenSegment a1 (clk, rst, sum, SEG2);
SevenSegment a2 (clk, rst, a, SEG1);
            
endmodule

