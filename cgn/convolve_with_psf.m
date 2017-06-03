function [ img,offset ] = convolve_with_psf(img,psf)
%      Wrapper function for convolution of image with PSF
% Replace with your own convolution function if needed
%% Copyright
% This file is part of ConfocalGN, a generator of confocal microscopy images
% Serge Dmitrieff, Nédélec Lab, EMBL 2015-2017
% https://github.com/SergeDmi/ConfocalGN
% Licenced under GNU General Public Licence 3

%% Here image convolution with PSF
% Offset is an offset in pixel between the source image and the convolved
% image
[img,offset]=cgn_convolve(img,psf);

end

