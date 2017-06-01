function [ img,sig_mask,bg_mask] = segment_image(image,options)
% Minimal image segmentation function
%   Gaussian blurring + thresholding
%   Should be replaced by your own !
%
%   img is the thresholded image
%   sig_mask is the mask to apply to the image to obtain the signal voxels
%   bg_mask is the mask to apply to the image to obtain the background voxels
%
% options or options.segmentation should contain filt
% filt is a 3x1 vector for the Gaussian blurring to be applied
%
% Serge Dmitrieff, Nédélec Lab, EMBL 2016
% www.biophysics.fr

defopt=cgn_options_load();
if nargin<2
    options=defopt;
end
if isfield(options,'segmentation')
    options=options.segmentation;
end
defopt=defopt.segmentation;
options=complete_options(options,defopt);

filt=options.filt;
ix=options.ix;

if ischar(image)
    if ~isempty(ix)
        stack=get_stack(tiffread(image,ix));
    else
        stack=get_stack(tiffread(image));
    end
   
else
    if ~isempty(image)
        stack=image;
    else
        error('Empty image')
    end
end

% Blurring
img=gauss3filter(stack,filt);
% Thresholding
[img,bg_mask]=threshold(img);
sig_mask=~bg_mask;

end

