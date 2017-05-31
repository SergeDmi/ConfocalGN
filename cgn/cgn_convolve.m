function [ cvd , offset] = cgn_convolve( img,psf,mode)
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
            psf=get_stack(tiffread(psf));
        catch
            error('Unsupported PSF format : must be matlab array or tiff file');
        end
    end
else
    mode=lower(mode);
     if ~isnumeric(psf)
         try 
            psf=get_stack(tiffread(psf));
        catch
            error('Unsupported PSF format : must be matlab array or tiff file');
         end
     end
end

offset=[0 0 0];
if strcmp(mode,'gaussian')
    cvd=convolve_with_gaussian_psf(img,psf);    
else
    cvd=fftconvn(img,psf,mode);
    sc=size(cvd);
    si=size(img);
    ds=sc-si;
    of=floor(ds/2);
    cvd=cvd(of(1):(of(1)+si(1)),of(2):(of(2)+si(2)),of(3):(of(3)+si(3)));
end

end

