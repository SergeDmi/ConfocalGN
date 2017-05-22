function [ img ] = convolve_with_psf(img,psf)
%      Wrapper function for convolution of image with PSF
% Replace with your own convolution function if needed

%% Here image convolution with PSF
img=cgn_convolve(img,psf);

end

