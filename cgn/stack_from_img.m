function [ stack,offset,nn ] = stack_from_img( img,pix )
% Generates a stack of voxels from a high resolution image
%   img : high res image (ALREADY CONVOLVED with PSF),
%   pix : size of voxel in units of img pixels

%% We read the pixel values at the center of a voxel
s=size(img);
nn=floor(s./pix);
di=pix(1)/2.0;
dj=pix(2)/2.0;
dk=pix(3)/2.0;
offset=-[di dj dk];
stack=img(ceil(di+(0:(nn(1)-1))*pix(1)),ceil(dj+(0:(nn(2)-1))*pix(2)),ceil(dk+(0:(nn(3)-1))*pix(3)));


end

