function pixels = image_get_pixels(im, indx)
% Extract the pixel from the structs returned by tiffread.m
%
% F. Nedelec, Nov. 9 2012
%% Copyright
% This file is part of ConfocalGN, a generator of confocal microscopy images
% Serge Dmitrieff, Nédélec Lab, EMBL 2015-2017
% https://github.com/SergeDmi/ConfocalGN
% Licenced under GNU General Public Licence 3


pixels = im;

%% if index is not specified, return first image

if nargin < 2
    indx = 1;
end

if  isfield(im, 'data')
    pixels = im(indx).data;
end

%% extract tiffread color image

if iscell(pixels)
    res = zeros([size(pixels{1}), 3]);
    try
        for c = 1:length(pixels)
            res(:,:,c) = pixels{c};
        end
    catch
        disp('get_pixel failed to assemble a RGB image');
    end
    pixels = res;
end

end