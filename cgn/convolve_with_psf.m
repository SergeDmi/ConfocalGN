function [ img ] = convolve_with_psf(img,psf)
% Convolves an image with a gaussian psf
if sum(psf>0)
	% Enable this if you have Parrallel Computing Toolbox enabled
    %img=gauss3filter(gpuArray(img),psf);
    img=gauss3filter(img,psf);
end

end

