function [ sig,noise,img,stack,mask] = get_img_params(image,options)
% Finds mean pixel value of signal, and background distribution in image
%   For this we segment the image (gaussian filter+thresholding)
%   image can be a filename (then loaded with tiffread)
%   or a stack
%
% Input :
% image is an image or image file, filt is the segmenting parameters
% ix is the frames to be kept from the image 
%
% Output :
% mean_sig is the mean value of 'signal' pixels
% noise are the moments of the 'background' pixels
% signal vs background are determined by the segment_image function
% please replace by your own for optimal usage
% stack is the analyzed image (raw data)
% mask are the background pixels 
%
% Serge Dmitrieff, Nélec Lab, EMBL 2016
% www.biophysics.fr

defopt=cgn_options_load();
if nargin<2
    options=defopt;
    if nargin<1
        error('Error : get_img_params requires an image or or image filename')
    end
end
if isfield(options,'segmentation')
    options=options.segmentation;
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
    stack=get_stack(imgs);
else
    if ~isempty(image) 
        if ~isempty(ix)
            if max(ix)<=size(image,3)
                stack=image(:,:,ix);
            else
                error('Image does not contain required frame. Please change options.xxxx.ix')
            end
        else
            stack=image;
        end
    else
        error('Empty image')
    end
end

%% Segmenting image
%-------------------------------------------------------------------------
% USER : Replace segment_image by your own segmenting procedure if need be
%-------------------------------------------------------------------------
% mask are the pixels to be filtered OUT, i.e. noise
% img is the resulting image
[img,mask]=segment_image(stack,options);

%% Computing signal & noise properties
% Background value in original image
bkg=stack(mask);
% Signal value in original image
frt=stack(~mask);
% Observables
noise=moments(bkg);
sig=moments(frt);

end

