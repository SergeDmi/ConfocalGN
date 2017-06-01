function [ cvd , offset] = cgn_convolve( img,psf,mode)
%% CGN-specific wrapper to convolution functions
%   Uses either a gaussian kernel or an image-type PSF
%   Gaussian kernel uses a 3x1 vector PSF : mode = gaussian
%   Otherwise, uses an image PSF          : mode = *
%       See fftconvn for possible modes

if nargin<3
    mode='';
end

%% Defining which convolution to perform based on inputs
if isempty(mode)
    % If mode is unspecified
	mode='full';
    if isnumeric(psf)
        % PSF is a matrix or vector
        if length(psf)<=3
            mode='gaussian';
        end
    else
        % Trying to load PSF as an image
        try 
            psf=get_stack(tiffread(psf));
        catch
            error('Unsupported PSF format : must be matlab array or tiff file');
        end
    end
else
    % If mode is specified
    mode=lower(mode);
     if ~isnumeric(psf)
         try 
            psf=get_stack(tiffread(psf));
        catch
            error('Unsupported PSF format : must be matlab array or tiff file');
         end
     end
end

% Performing the convolution
offset=[0 0 0];
if strcmp(mode,'gaussian')
    % Gaussian convolution
    cvd=convolve_with_gaussian_psf(img,psf);    
else
    % Generic image convolution
    cvd=fftconvn(img,psf,mode);
    sc=size(cvd);
    si=size(img);
    ds=sc-si;
    of=floor(ds/2);
    % Removing pixels added by the convolution
    cvd=cvd(of(1):(of(1)+si(1)),of(2):(of(2)+si(2)),of(3):(of(3)+si(3)));
end

end

