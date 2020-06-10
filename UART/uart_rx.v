`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:38:11 06/09/2020 
// Design Name: 
// Module Name:    uart_rx 
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
module uart_rx
#(parameter clk_per_bit = 8'd100)
(
	input ip_sgnl,        //input signal
	input clk,            //input clock
	output rx_dv,         //ack signal
	output[7:0] rx_byte   //recieved data
);

parameter start_test = (clk_per_bit>>1);
//states of fsm
parameter idle   = 3'b000;
parameter start  = 3'b001;
parameter data   = 3'b010;
parameter stop   = 3'b011;
parameter clean  = 3'b100;

reg[2:0] Ps;                //Present Sate
reg[2:0] index;
reg ip_r,ip,data_dv;
reg[7:0] count;
reg[7:0] data_byte;
//wire[7:0] rx_byte;



always @(posedge clk)
begin
ip_r <= ip_sgnl;
ip <= ip_r;
end

always @(posedge clk)
begin
case(Ps)
idle:
		begin
		data_dv <= 1'b0;
		count <= 0;
		index <= 0;
		if(ip == 1'b1)
			Ps <= idle;
		else
			Ps <= start;
		end
start:
		begin
			if(count < start_test)
				begin
					count <= count + 1'b1;
					Ps <= start;
				end
			else
				begin
					if(ip == 1'b0)
						begin
							count<=0;
							Ps <= data;
						end
					else
						Ps <=idle;
				end
		end
data:
		begin
			if(count < clk_per_bit-1)
				begin
					count <= count + 1'b1;
					Ps <= data;
				end
			else
				begin
					data_byte[index] <= ip;
					count <= 0;
					if(index < 3'd7)
						begin
							index <= index + 1'b1;
							Ps <= data;
						end
					else
						Ps <= stop;
				end	
		end
stop:
		begin
		if(count < clk_per_bit-1)
			begin
				count <= count + 1'b1;
				Ps <= stop;
			end
		else
			begin
				count <= 0;
				data_dv <= 1'b1;
				Ps <= clean;
			end
		end
clean:
		begin
			data_dv <= 1'b0;
			Ps <= idle;
		end
default:
		Ps <= idle;
endcase


end

assign rx_dv = data_dv;	
assign rx_byte = data_byte;

endmodule






