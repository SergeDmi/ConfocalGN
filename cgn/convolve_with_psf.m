function [ img,offset ] = convolve_with_psf(img,psf)
%      Wrapper function for convolution of image with PSF
% Replace with your own convolution function if needed

%% Here image convolution with PSF
% Offset is an offset in pixel between the source image and the convolved
% image
[img,offset]=cgn_convolve(img,psf);

end

