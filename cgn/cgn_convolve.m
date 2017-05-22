function [ cvd ] = cgn_convolve( img,psf,mode)
%% CGN wrapper to convolution functions
%   Uses either a gaussian kernel or an image-type psf

if nargin<3
    mode='';
end

if isempty(mode)
	mode='full';
    if isnumeric(psf)
        if length(psf)<=3
            mode='gaussian';
        end
    else
        try 
            psf=tiffread(psf);
        catch
            error('Unsupported PSF format : must be matlab array or tiff file');
        end
    end
else
    mode=lower(mode);
end

if strcmp(mode,'gaussian')
    cvd=convolve_with_gaussian_psf(img,psf);
else
    cvd=fftconvn(img,psf,mode);
end

end

