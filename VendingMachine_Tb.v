`timescale 1ns / 1ns

module VendingMachine_Tb;

parameter tlimit = 100000000;
parameter clkPeriod = 7;

wire [7:0] DIGIT;
wire [9:0] LED;
wire [6:0] SEG;
reg L_button=0;
reg R_button=0;
reg C_button=0;
reg clk=0;
reg rst=1;
reg [3:0] switch=0;

VendingMachine m1(L_button, R_button, C_button, clk, rst, switch, DIGIT, SEG, LED);
        
always #clkPeriod clk=~clk;

always @(posedge clk) begin
   if ($time >= tlimit) $stop;
   else begin
      switch[0] = 1;
	switch[1]=1;
	switch[2]=1;
	switch[3]=1;
	#20 switch=4'b0;
   end
end
wire on;

assign on = ($time < tlimit)? 1: 0;
always @(*) begin
   if (on) begin
      #20;
      switch[0] = $random % 2;   
      switch[1] = $random % 2;
      switch[2] = $random % 2;
      switch[3] = $random % 2;
      #30;
      switch=4'b0;
   end
end
integer i;

initial begin
	rst=0;
	#20;
	rst=1;
	#20 L_button = 1;
        #20 L_button = 0;
        #20 L_button = 1;
        #20 L_button = 0;
        #20 L_button = 1;
        #20 L_button = 0;
      
   //$fdisplay (result, "time = %d, LED = %d, SEG = %d", $time, LED, SEG);
   #50 C_button = 1;
   #30 C_button = 0;
    //$fdisplay (result, "time = %d, LED = %d, SEG = %d", $time, LED, SEG);
   //$fclose(result);
   #20;
  $stop;
end
endmodule