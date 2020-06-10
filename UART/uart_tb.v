`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    Year 2020
// Design Name: 
// Module Name:    uart_tb 
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
module uart_tb();

reg clk;
//reg signal;
reg[7:0] data_byte;
reg tx_dv;
parameter clk_per_bit = 8'd50;
parameter clk_period = 10;
parameter byte_to_send = 8'ha9;
wire tx_done;
wire rx_done;
wire[7:0] rx_output;
wire tx_output;
reg[7:0] recieved_byte;

always #5 clk = ~clk;

uart_rx #(clk_per_bit) init_rx(tx_output,clk,rx_done,rx_output);
uart_tx #(clk_per_bit) init_tx(clk,data_byte,tx_dv,tx_output,tx_done);

initial 
begin
#0 clk = 1'b0;
	tx_dv = 1'b0;
	data_byte = byte_to_send;
	
#clk_period;
#clk_period;

tx_dv = 1'b1;
#clk_period;

tx_dv = 1'b0;
#clk_period;

@(posedge tx_done) 
	$display("data send successfully");
//@(posedge rx_done)
//	$display("data recieved successfully");

#clk_period;
recieved_byte = rx_output;

#clk_period;
#clk_period;

if( recieved_byte == data_byte )
	begin
		$display("correct byte recieved");
		#clk_period;
	end
else
	begin
		$display("incorrect byte recieved");
		#clk_period;
	end
	
#clk_period;
#clk_period;
$stop;

end

endmodule
