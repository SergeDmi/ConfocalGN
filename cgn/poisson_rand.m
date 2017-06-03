function [ Y ] = poisson_rand( l,N )
% Simple poisson random number generator
%   Implementing Knuth Algorithm
%% Copyright
% This file is part of ConfocalGN, a generator of confocal microscopy images
% Serge Dmitrieff, Nédélec Lab, EMBL 2015-2017
% https://github.com/SergeDmi/ConfocalGN
% Licenced under GNU General Public Licence 3

Y = zeros(N,1);
X = rand(N,1);
el=exp(-l);
cl=logical(X>=el);    
nl=sum(cl);

while nl>0
    X(cl)=X(cl).*rand(nl,1);
    Y(cl)=Y(cl)+1;
    cl=logical(X>=el);    
    nl=sum(cl);
end

end