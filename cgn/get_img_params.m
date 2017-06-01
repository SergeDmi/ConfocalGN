function [ sig,noise,img,stack,mask] = get_img_params(sample_image,options)
% Finds mean pixel value of signal, and background distribution in image
%   For this we segment the image using provide_image_mask 
%   (or sample_image.mask if defined)
%   image can be a filename (then loaded with tiffread)
%   or a stack (matrix of voxel values)
%
% Input :
%   image is an image or image file, filt is the segmenting parameters
%   ix is the frames to be kept from the image 
%
% Output :
%    mean_sig is the mean value of 'signal' pixels
%    noise are the moments of the 'background' pixels
%    signal vs background are determined by the segment_image function
%    please replace by your own for optimal usage
%    stack is the analyzed image (raw data)
%    mask are the background pixels 
%
% Serge Dmitrieff, Nédélec Lab, EMBL 2016
% www.biophysics.fr

%% Checking options
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
defopt=defopt.segmentation;
options=complete_options(options,defopt);
ix=options.ix;

%% Getting the mask for segmentation and checking the image
mask=[];
if isfield(sample_image,'image')
    image=sample_image.image;
    if isfield(sample_image,'mask')
        mask=sample_image.mask;
    end
else
    image=sample_image;
end


if ischar(image)
    if ~isempty(ix)
        imgs=get_stack(tiffread(image,ix));
    else
        imgs=get_stack(tiffread(image));
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

if isempty(mask)
    % mask are the signal pixels
    mask=provide_image_mask(stack,options);
end

img=stack.*mask;
%% Computing signal & noise properties
% Background value in original image
bkg=stack(~mask);
% Signal value in original image
frt=stack(mask);
% Observables
noise=moments(bkg);
sig=moments(frt);

end

