function [ v1,v2 ] = box_muller(n )
% Box-Muller gaussian number generateor
%% Copyright
% This file is part of ConfocalGN, a generator of confocal microscopy images
% Serge Dmitrieff, Nédélec Lab, EMBL 2015-2017
% https://github.com/SergeDmi/ConfocalGN
% Licenced under GNU General Public Licence 3
   
a=rand(n,1);
b=rand(n,1);
v1=sqrt(-2*log(a)).*sin(2*pi*b);
v2=sqrt(-2*log(a)).*cos(2*pi*b);

end

