function [ sig,noise,img,stack,mask] = get_img_params(sample_image,options)
% Finds mean pixel value of signal, and background distribution in image
%   For this we segment the image using provide_image_mask
%   image can be a filename (then loaded with tiffread)
%   or a matrix of voxel values
%
% Input :
%    image is an image or image file, filt is the segmenting parameters
%    ix is the frames to be kept from the image 
%
% Output :
%   sig is the mean value of 'signal' pixels
%   noise are the moments of the 'background' pixels
%   img is the thresholded image
%   stack is the analyzed image (raw data)
%   mask are the signal pixels 
%
% Warning :
%	signal vs background are determined by provide_image_mask
%   by default, it relies on a simple image segmentation procedure
%   please replace by your own procedure for optimal usage
%   
%% Copyright
% This file is part of ConfocalGN, a generator of confocal microscopy images
% Serge Dmitrieff, Nédélec Lab, EMBL 2015-2017
% https://github.com/SergeDmi/ConfocalGN
% Licenced under GNU General Public Licence 3


%% Input verification and processing
% Checking options
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

% Checking image and mask
mask=[];
if isfield(sample_image,'img')
    image=sample_image.img;
    if isfield(sample_image,'mask')
        mask=sample_image.mask;
    end
else
    image=sample_image;
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

%% Image segmentation
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
