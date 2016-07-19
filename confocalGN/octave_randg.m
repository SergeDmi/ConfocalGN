function [ r ] = octave_randg( a , n )
% Generate a (nx1) vector of gamma(a,1)-distributed random numbers
%   very simplified version of octave's randg
%   all credits to octave randg -- Distributed under GPL licence
% Copyright (C) 2006-2015 John W. Eaton
%
% Octave is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or (at
% your option) any later version.
%
% Octave is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Octave; see the file COPYING.  If not, see
% <http://www.gnu.org/licenses/>.
%
%   See: Marsaglia G and Tsang W (2000), "A simple method for generating
%   gamma variables", ACM Transactions on Mathematical Software 26(3) 363-372
% Original version written by Paul Kienzle distributed as free software in the in the public domain. 
%
% Modified and simplified for Matlab by Serge Dmitrieff, 2016
% www.biophysics.fr

if a<1
  a=1+a;
end
d=a-1.0/3.0;
c=1./sqrt(9.0*d);
r=zeros(n,1);
for i=1:n
v=-1;
while v<=0
    x=box_muller(1);
    v=1+c*x;
    v=v^3;
end
token=1;
while token>0
    token=0;
    u=rand;
    xsq = x*x;
    if (u >= 1.-0.0331*xsq*xsq && log(u) >= 0.5*xsq + d*(1-v+log (v)))
        token=1;
    end
end
r(i)=d*v;

end

