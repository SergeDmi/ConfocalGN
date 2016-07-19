function [ img,no,t ] = threshold( img,t )
% Thresholds a signal, either from a given threshold or with Otsu method 
%   Thresholded pixels become NaN
% S. Dmitrieff 2016
if nargin<2
    t=otsu_threshold(img);
end
no=logical(img<t);
img(no)=NaN;
end

