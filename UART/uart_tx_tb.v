`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:00:37 06/09/2020 
// Design Name: 
// Module Name:    uart_tx_tb 
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
module uart_tx_tb();

reg[7:0] inpt_data;
reg clk;
reg tx_dv;
wire op_signal;
wire done_signal;

parameter data_to_tx = 8'ha5;    // information to transmit
parameter clk_period = 10;       // in nano seconds
parameter clk_per_bit = 8'd100;  

//clock
always #5 clk = ~clk;               

//initiating uart transmitter
uart_tx #(clk_per_bit) init(clk,inpt_data,tx_dv,op_signal,done_signal);

initial 
begin
#0 tx_dv = 1'b0;
	clk  = 1'b0;
	inpt_data = data_to_tx;
#clk_period;
tx_dv = 1'b1;
#clk_period;
tx_dv = 1'b0;
#clk_period;

@(posedge done_signal) $stop;


end

endmodule
