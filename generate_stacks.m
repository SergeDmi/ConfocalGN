function [ stack,offset] = generate_stacks( img,psf,pix,mean_px,stdev_px )
% generate_stacks : make mock confocal data from a "perfect" image
%   img is the orginial "pure" signal, with isotropic 1x1x1 voxels
%   psf is the point spread function of the microscope (1x3 vector)
%   the psf is in units of the size of original image pixel
%   pix is the pixel size of the microscope, i.e. how many pixels of the
%   original image fit in one microscope voxel         (1x3 vector)
%
%   mean_px is the mean pixel value from noise
%   stdev_px is the standard deviation
%
%
%   stack is the simulated confocal stack
%   offset is the correction in x,y,z to go back to the original coords
%
% Serge Dmitrieff 2016

if nargin<5
    stdev_px=0;
    if nargin<4
        mean_px=0;
    end
end

%% 3D Convoluting of the image
if sum(psf>0)
    img=gauss3filter(img,psf);
end

%% Taking the pixels
s=size(img);
nn=floor(s./pix);
offset=pix-[1 1 1];
stack=zeros(nn);

di=1:pix(1);
dj=1:pix(2);
for z=0:nn(3)-1
    for i=0:nn(1)-1
        for j=0:nn(2)-1
            stack(i+1,j+1,z+1)=sum(sum(img(i*pix(1)+di,j*pix(2)+dj,z*pix(3)+1)));
        end
    end
end

stack(:)=stack(:)+(mean_px+stdev_px*box_muller(nn(1)*nn(2)*nn(3)));

end

