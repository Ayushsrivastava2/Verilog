`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.07.2020 19:26:59
// Design Name: 
// Module Name: cordic_test
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


module cordic_test();
localparam BW=32;
real cos,sin;
reg [BW-1:0] Xin,Yin;
reg  [31:0] angle;
wire signed [BW-1:0] Xout, Yout;
reg master_clk;
localparam FALSE = 1'b0;
localparam TRUE = 1'b1;
parameter timeperiod = 10; 

localparam VALUE = 32'b01001101101110100111011011010100; 
localparam sf=2.0**(-31.0);
//localparam VALUE = 16'h26dd; 

reg signed [63:0] i;
reg      start;

always #(timeperiod/2) master_clk = ~master_clk;

initial
begin
   start = FALSE;
   $display("Starting sim");
   master_clk = 1'b0;
   angle = 0;
   Xin = VALUE;                     
   Yin = 1'd0;                      

   #1000;
   @(posedge master_clk);
   start = TRUE;
   
   
   for (i = 0; i < 360; i = i + 1)     
     
   begin
      #timeperiod;
      start = FALSE;
      angle = ((1 << 32)*i)/360;    
      //$display ("angle = %d, %h",i, angle);
      cos= (($itor(Xout))*sf);
      //A=A/32000.0;
     // A=A*(2.0**(-31.0));
      //$display ("Xout = %f",A);
      sin= (($itor(Yout))*sf);
      //B=B/32000.0;
      //B=B*(2.0**(-31.0));
      //$display ("Yout = %f",B);
      #(18*timeperiod)
      $display("%f,%f;",cos,sin); 
   end

   #500
   $display("Simulation has finished");
   $stop;
end

cordic sin_cos (master_clk, Xin, Yin, angle, Xout, Yout);
 

/*initial
begin
  master_clk = 1'b0;
  $display ("master_clk started");
  #5;
  forever
  begin
    #(timeperiod/2) master_clk = 1'b1;
    #(timeperiod/2) master_clk = 1'b0;
  end
end*/


endmodule
