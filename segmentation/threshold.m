function [ img,no,t ] = threshold( img,t )
% Thresholds a signal, either from a given threshold or with Otsu method 
%   Thresholded pixels become NaN
%% Copyright
% This file is part of ConfocalGN, a generator of confocal microscopy images
% Serge Dmitrieff, Nédélec Lab, EMBL 2015-2017
% https://github.com/SergeDmi/ConfocalGN
% Licenced under GNU General Public Licence 3

if nargin<2
    t=otsu_threshold(img);
end
no=logical(img<t);
img(no)=NaN;
end

