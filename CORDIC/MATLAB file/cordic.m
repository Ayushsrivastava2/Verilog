function [xn,yn,zn] = cordic(x0,y0,phi,lut)
%phi can be array (1 x m)
niter = length(lut);
m = length(phi);

x = zeros(niter,m);
y = zeros(niter,m);
z = zeros(niter,m);

quad = floor(phi./(pi/2));
angle = rem(phi,pi/2);

x(1,:) = x0*cos((pi/2)*quad) - y0*sin((pi/2)*quad);
y(1,:) = y0*cos((pi/2)*quad) + x0*sin((pi/2)*quad);

%x(1,:) = x0;
%y(1,:) = y0;

z(1,:) = angle;

for i = 1:(niter-1)
    di = (-1).^(z(i,:)>=0);
    x(i+1,:) = x(i,:) + di.*bitsra(y(i,:),i-1);
    y(i+1,:) = y(i,:) - di.*bitsra(x(i,:),i-1);
    z(i+1,:) = z(i,:) + di.*lut(i);
end

    xn = x(niter,:);
    yn = y(niter,:);
    zn = z(niter,:);
end



