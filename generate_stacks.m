function [ stack,offset] = generate_stacks( img,psf,pix,mean_px,stdev_px )
% generate_stacks : make mock confocal data from a ground truth
%
% INPUT
% * img is the orginal ground truth, with isotropic 1x1x1 pixels
%   this image shall be convolved with the psf
%   should already have background noise included if any
%
% * psf is the point spread function of the microscope 
%       it is the 2-way psf (i.e. illumination+observation)
%       also called confocal psf  ; here : 1x3 vector
%   here we assume the psf to be gaussian which provides fast convolution
%   the psf is in units of the size of original image pixel 
%       ex : psf = [wx,wy,wz] where wi is the gaussian width on axis i
%
% * pix is the voxel size of the microscope, i.e. how many pixels of the
%   original image fit in one microscope voxel         (1x3 vector)
%
% * mean_px is the mean voxel value from sensor noise
% * stdev_px is the standard deviation
%
% OUTPUT
% * stack is the simulated confocal stack
%
% * offset is the translation in x,y,z to go back to the original coord
%   as the shape gets
%
% RATIONALE
% We convolve the ground truth with the confocal psf. The psf should be the
% one measured experimentally from control sample (e.g. bead). So it is
% really how a point *object* would be seen.
%
% In many cases, the confocal psf is close to gaussian. Please make sure it
% is the case for your setup, or that the exact shape of the PSF is not
% relevant to your issue.
%
% This program is intended solely for analysis testing purpose.
% This IS not a rigorous implementation of confocal optics and electronics.
%
% Serge Dmitrieff, Nédélec Lab, EMBL 2016

if nargin<5
    stdev_px=0;
    if nargin<4
        mean_px=0;
    end
end

%% 3D Convoluting of the image
if sum(psf>0)
	% Enable this if you have Parrallel Computing Toolbox enabled
    %img=gauss3filter(gpuArray(img),psf);
    img=gauss3filter(img,psf);
end

%% Taking the pixels 
s=size(img);
nn=floor(s./pix);
di=ceil(pix(1)/2.0);
dj=ceil(pix(2)/2.0);
dk=ceil(pix(3)/2.0);
offset=[di dj dk];
stack=img(di+(0:(nn(1)-1))*pix(1),dj+(0:(nn(2)-1))*pix(2),dk+(0:(nn(3)-1))*pix(3));
stack(:)=stack(:)+(mean_px+stdev_px*box_muller(nn(1)*nn(2)*nn(3)));

end

