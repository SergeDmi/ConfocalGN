function [ stack,offset,nn ] = stack_from_img( img,pix )
%Generates a stack of voxels from a high resolution image
%   img : high res image (convolved),
%   pix : size of voxel in units of img pixels

s=size(img);
nn=floor(s./pix);
di=ceil(pix(1)/2.0);
dj=ceil(pix(2)/2.0);
dk=ceil(pix(3)/2.0);
offset=-[di dj dk];
stack=img(di+(0:(nn(1)-1))*pix(1),dj+(0:(nn(2)-1))*pix(2),dk+(0:(nn(3)-1))*pix(3));


end

