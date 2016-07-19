function [ img,mask] = segment_image(image,filt,ix)
% Minimal image segmentation function
%   Gaussian blurring + thresholding
% 
% Should be replaced by your own !
%
% Serge Dmitrieff, Nédélec Lab, EMBL 2016
% www.biophysics.fr

if nargin<3
    ix=[];
    if nargin<2
        warning('Default : no filer')
        filt=[0 0 0];
    end     
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

