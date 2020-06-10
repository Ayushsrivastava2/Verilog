`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:04:12 06/09/2020 
// Design Name: 
// Module Name:    uart_rx_tb 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module uart_rx_tb();

reg clk = 1'b0;
reg signal;
parameter sgnl_data = 12'b110011010111;   //data = 11001101
parameter clk_per_bit = 8'd100;
parameter clk_period = 10;
reg[7:0] count;
reg[11:0] data;
reg[3:0] index;
wire rx_dv;
wire[7:0] recieve_data;
reg[7:0] Op_data;

always #5 clk = ~clk;


uart_rx #(clk_per_bit) init(signal,clk,rx_dv,recieve_data);

initial 
begin
#0 count = 8'h00;
	data  = sgnl_data;
	signal= 1'b1;
	
#clk_period;

for(index = 4'h0;index < 4'hc;index = index + 1'b1)
begin
signal = data[index];
	for(count = 8'h00; count < clk_per_bit-1 ; count = count + 1'b1)
	begin
		#clk_period;
		if(rx_dv == 1'b1)
			$display(" signal recieved");
	end  // end of count for loop
end // end of index for loop

@(posedge rx_dv) $display("signal recieved");
#clk_period;

Op_data = recieve_data;
if(Op_data == 8'b11001101)
	$display("mission successful");
else
	$display("mission fail");

#clk_period;
$stop;
end  // end of init block

endmodule
