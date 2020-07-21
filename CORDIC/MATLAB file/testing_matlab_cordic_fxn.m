clear all;
clc;

niter = 16;            % no. of iterations in cordic

%creating LUT table for cordic
 atan_lut = atan(2.^(1-[1:niter]));
 
%creating array of angles ( in radians ) 
phi = linspace(0,2*pi,100);

%initial values
xin = 1/1.647;
yin = 0;

%calling cordin function
[cos_values,sin_values,~] = cordic(xin,yin,phi,atan_lut);

subplot(211);
hold on 
plot(phi*(180/pi),cos_values);
plot(phi*(180/pi),sin_values);
title('cordic outputs');
legend('cos values from cordic','sin values from cordic');
hold off

subplot(212);
hold on
plot(phi*(180/pi),cos(phi));
plot(phi*(180/pi),sin(phi));
title('actual values');
legend('actual cos','actual sin');
hold off




