function [ M ] = rotmat_3D( angles )
% Creates a rotation matrix from Euler angles
%% Copyright
% This file is part of ConfocalGN, a generator of confocal microscopy images
% Serge Dmitrieff, Nédélec Lab, EMBL 2015-2017
% https://github.com/SergeDmi/ConfocalGN
% Licenced under GNU General Public Licence 3

a=angles(1);
b=angles(2);
c=angles(3);
Rx=[[1 0 0];[0 cos(a) -sin(a)];[0 sin(a) cos(a)]];
Ry=[[cos(b) 0 sin(b)];[0 1 0];[-sin(b) 0 cos(b)]];
Rz=[[cos(c) -sin(c) 0];[sin(c) cos(c) 0];[0 0 1]];
M=Rx*Ry*Rz;


end

