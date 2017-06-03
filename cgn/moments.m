function [ M ] = moments( X,n )
% moments returns the n first moments of distribution X
%   default : n=3
%% Copyright
% This file is part of ConfocalGN, a generator of confocal microscopy images
% Serge Dmitrieff, Nédélec Lab, EMBL 2015-2017
% https://github.com/SergeDmi/ConfocalGN
% Licenced under GNU General Public Licence 3

if nargin <2
    n=3;
end
M=zeros(n,1);
m=mean(X);
X=X-m;
M(1)=m;
for k=2:n
    M(k)=mean(X.^k);
end

end

