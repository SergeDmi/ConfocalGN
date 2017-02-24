function [ r ] = gamma_random_parallel( a , n )
% Generates an (n x 1) vector of gamma(a,1)-distributed random numbers
%   very simplified version of octave's randg
%   with a touch of matlab parrallelization
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
% Modified and simplified for Matlab. 
% Implementation of Matlab parrallelization by Serge Dmitrieff, 2016
% This is the fastest matlab gamma distribution generator I found x_x
% Please let me know if you have better !
% 
% www.biophysics.fr

if a<1
  a=1+a;
end
d=a-1.0/3.0;
c=1./sqrt(9.0*d);
x=zeros(n,1);
v=-ones(n,1);
m=logical(v<0);
while sum(m)>0
    x(m)=box_muller(sum(m));
    v(m)=1+c*x(m);
    v(m)=v(m).^3;
    m=logical(v<0);
end

m=ones(n,1);
xsq=x.*x;
while sum(m)>0
    u=rand(sum(m),1);
    m=logical((u >= 1.-0.0331*xsq(m).*xsq(m)).*(log(u) >= 0.5*xsq(m) + d*(1-v(m)+log (v(m)))));
end
r=d*v;


end

