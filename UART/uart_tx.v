`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:  
// Design Name: 
// Module Name:    uart_tx 
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
//clocks per bit = (frequency of clocl avilable)/(baud rate)
//for example:
// if frequency of clock = 10Mhz, selected baud-rate = 115200
// clk_per_bit = (10000000/115200) = 87
//////////////////////////////////////////////////////////////////////////////////
module uart_tx
#(parameter clk_per_bit = 8'd100)
(
	input clk,
	input[7:0] ip_data,
	input tx_dv,
	output tx_signal,
	output tx_done
);

//fsm states
parameter idle  = 3'b000;
parameter start = 3'b001;
parameter data  = 3'b010;
parameter stop  = 3'b011;
parameter clean = 3'b100;

reg[2:0] Ps; //present state
reg[3:0] index;
reg[7:0] count;
reg data_done,tx_op;

always @(posedge clk)
begin
case(Ps)
idle:
		begin
		tx_op <= 1'b1;
		count <= 8'h00;
		index <= 4'h0;
		data_done <= 1'b0;
		if(tx_dv == 1'b1)
			Ps <= start;
		else
			Ps <= idle;
		end
start:
		begin
		tx_op <= 1'b0;
		if(count < clk_per_bit-1)
			begin
				count <= count + 1'b1;
				Ps <= start;
			end
		else
			begin
				count <= 8'h00;
				Ps <= data;
			end
		end
data:
		begin
		if( index < 4'd8 )
			begin
			tx_op <= ip_data[index];
			if(count < clk_per_bit-1)
				begin 
					count <= count + 1'b1;
				end
			else
				begin
					index <= index + 1'b1;
					count <= 8'h00;
				end
			Ps <= data;
			end
		else
			begin
				count <= 8'h00;
				Ps <= stop;
			end
		end
stop:
		begin
		tx_op <= 1'b1;
		if(count < clk_per_bit-1)
			begin
				count <= count + 1'b1;
				Ps <= stop;
			end
		else
			begin
				data_done <= 1'b1;
				Ps <= clean;
			end
		end
clean:
		begin
			data_done <= 1'b1;
			Ps <= idle;
		end

default: Ps <= idle;	
endcase
end

assign tx_signal = tx_op;
assign tx_done = data_done;
 
endmodule








