function [ img,mask] = segment_image(image,options)
% Minimal image segmentation function
%   Gaussian blurring + thresholding
%   Should be replaced by your own !
%
%   img is the thresholded image
%   mask is the mask to apply to the image to obtain the background
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
if isfield(options,'filt')
    filt=options.filt;
else
    filt=defopt.segmentation.filt;
end
if isfield(options,'ix')
    ix=options.ix;
else
    ix=defopt.segmentation.ix;
end

if ischar(image)
    if ~isempty(ix)
        imgs=tiffread(image,ix);
    else
        imgs=tiffread(image);
    end
    n=length(imgs);
    s=size(imgs(1).data);
    s(3)=n;

    stack=zeros(s);
    for i=1:n
        stack(:,:,i)=imgs(i).data;
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
[img,mask]=threshold(img);


end

