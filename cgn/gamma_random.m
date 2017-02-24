function rnd = gamma_random(a, b, n)
%generate an nx1 array of gamma(a,b)-distributed random values
%   very simplified version of octave's gamrnd

% Copyright (C) 1995, 1996, 1997, 2005, 2006, 2007 Kurt Hornik
%
% This file is part of Octave.
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
% Author: KH <Kurt.Hornik@wu-wien.ac.at>
% Description: Random deviates from the Gamma distribution
% Original version written by Paul Kienzle distributed as free
% software in the in the public domain.  
%
%
% simplified for matlab in 2016 by Serge Dmitrieff
% www.biophysics.fr
if (nargin > 1)
    if (~isscalar(a) || ~isscalar(b)) 
        error ('gamrnd: a and b must be of common  scalar');
    end
end

if (nargin < 3)
    n=1;
    if nargin < 2
        b=1;
        if nargin<1
            a=1;
        end
    end
end

rnd= b*gamma_random_parallel(a,n);

end

