function [ img ] = convolve_with_gaussian_psf(img,psf)
% Convolves an image with a gaussian psf
%% Copyright
% This file is part of ConfocalGN, a generator of confocal microscopy images
% Serge Dmitrieff, Nédélec Lab, EMBL 2015-2017
% https://github.com/SergeDmi/ConfocalGN
% Licenced under GNU General Public Licence 3

if sum(psf>0)
	% Enable this if you have Parrallel Computing Toolbox enabled
    %img=gauss3filter(gpuArray(img),psf);
    img=gauss3filter(img,psf);
end

end

