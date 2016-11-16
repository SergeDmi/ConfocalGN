function [ v1,v2 ] = box_muller(n )
% Box-Muller gaussian number generateor
%   
a=rand(n,1);
b=rand(n,1);
v1=sqrt(-2*log(a)).*sin(2*pi*b);
v2=sqrt(-2*log(a)).*cos(2*pi*b);


end

