`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:14:35 07/19/2020 
// Design Name: 
// Module Name:    cordic 
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
module cordic(clk,x0,y0,phi,xn,yn);

localparam wd = 32;
localparam niter = 16;
input clk;
input wire signed 		[wd-1:0] x0,y0;
input wire 					[31:0] phi;
output wire signed 		[wd-1:0] xn,yn;

wire [31:0] atan_table [0:30];

assign atan_table[00] = 'b00100000000000000000000000000000; // 45.000 degrees -> atan(2^0)
assign atan_table[01] = 'b00010010111001000000010100011101; // 26.565 degrees -> atan(2^-1)
assign atan_table[02] = 'b00001001111110110011100001011011; // 14.036 degrees -> atan(2^-2)
assign atan_table[03] = 'b00000101000100010001000111010100; // atan(2^-3)
assign atan_table[04] = 'b00000010100010110000110101000011;
assign atan_table[05] = 'b00000001010001011101011111100001;
assign atan_table[06] = 'b00000000101000101111011000011110;
assign atan_table[07] = 'b00000000010100010111110001010101;
assign atan_table[08] = 'b00000000001010001011111001010011;
assign atan_table[09] = 'b00000000000101000101111100101110;
assign atan_table[10] = 'b00000000000010100010111110011000;
assign atan_table[11] = 'b00000000000001010001011111001100;
assign atan_table[12] = 'b00000000000000101000101111100110;
assign atan_table[13] = 'b00000000000000010100010111110011;
assign atan_table[14] = 'b00000000000000001010001011111001;
assign atan_table[15] = 'b00000000000000000101000101111100;
assign atan_table[16] = 'b00000000000000000010100010111110;
assign atan_table[17] = 'b00000000000000000001010001011111;
assign atan_table[18] = 'b00000000000000000000101000101111;
assign atan_table[19] = 'b00000000000000000000010100010111;
assign atan_table[20] = 'b00000000000000000000001010001011;
assign atan_table[21] = 'b00000000000000000000000101000101;
assign atan_table[22] = 'b00000000000000000000000010100010;
assign atan_table[23] = 'b00000000000000000000000001010001;
assign atan_table[24] = 'b00000000000000000000000000101000;
assign atan_table[25] = 'b00000000000000000000000000010100;
assign atan_table[26] = 'b00000000000000000000000000001010;
assign atan_table[27] = 'b00000000000000000000000000000101;
assign atan_table[28] = 'b00000000000000000000000000000010;
assign atan_table[29] = 'b00000000000000000000000000000001;
assign atan_table[30] = 'b00000000000000000000000000000000;
 
reg signed [wd-1:0] X [0:niter];
reg signed [wd-1:0] Y [0:niter];
reg 		  [31:0]   Z [0:niter];

wire [1:0] quad;
assign quad = phi[31:30];

always @(posedge clk)   //initial values
begin
	case(quad)
	2'b00:	// 0 to 90
		begin
			X[0] <= x0;
			Y[0] <= y0;
			Z[0] <= phi;
		end
	2'b01: //90 to 180
		begin
			X[0] <= -y0;
			Y[0] <= x0;
			Z[0] <= {2'b00,phi[29:0]};
		end
	2'b10: //180 to 270
		begin
			X[0] <= -x0;
			Y[0] <= -y0;
			Z[0] <= {2'b00,phi[29:0]};
		end
	2'b11: //270 to 360
		begin
			X[0] <= y0;
			Y[0] <= -x0;
			Z[0] <= {2'b00,phi[29:0]};
		end
	endcase
end

genvar i;

generate for(i=0; i < niter; i=i+1)
	begin:abc
	
		initial begin
			X[i+1] <= 1'b0;
			Y[i+1] <= 1'b0;
			Z[i+1] <= 1'b0;
		end
	
		//wire di;
		//wire signed [wd:0] Xsr,Ysr;
		
		//assign Xsr = X[i] >>> i;
		//assign Ysr = Y[i] >>> i;
		
		//assign di = Z[i][31];
		
		always @(posedge clk)
		begin
			/*X[i+1] <= di? X[i] + Ysr 			:	X[i] - Ysr;
			Y[i+1] <= di? Y[i] - Xsr 			:	Y[i] + Ysr;
			Z[i+1] <= di? Z[i] + atan_lut[i] :	Z[i] - atan_lut[i];*/
			
			if(Z[i][31])
				begin
					X[i+1] <= X[i] + (Y[i]>>>(i));
					Y[i+1] <= Y[i] - (X[i]>>>(i));
					Z[i+1] <= Z[i] + atan_table[i];
				end
			else
				begin
					X[i+1] <= X[i] - (Y[i]>>>(i));
					Y[i+1] <= Y[i] + (X[i]>>>(i));
					Z[i+1] <= Z[i] - atan_table[i];
				end
				
		end
	end
endgenerate

assign xn = X[niter];
assign yn = Y[niter];

endmodule 
