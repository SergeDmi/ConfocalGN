function [ stacks,offset,achieved_sig,achieved_noise,im,sig,noise] = confocal_generator(img,conf,sample,options)
% confocal_generator : make mock confocal data from a ground truth
%   Distributed under the terms of the GNU Public licence GPL3
%
% INPUT
% * img is the orginal ground truth, with isotropic 1x1x1 pixels
%   this image shall be convolved with the psf
%   should already have background noise included if any
%   is either a matrix or a tiff file
%
% * conf.psf is the point spread function of the microscope 
%       it is the 2-way psf (i.e. illumination+observation)
%       also called confocal psf  ; here : 1x3 vector
%   here we assume the psf to be gaussian which provides fast convolution
%   the psf is in units of the size of original image pixel 
%       ex : psf = [wx,wy,wz] where wi is the gaussian width on axis i
%
% * conf.pix is the voxel size of the microscope, i.e. how many pixels of the
%   original image fit in one microscope voxel         (1x3 vector)
%
% * sample is a sample image to find background noise and mean signal value
%       from this, a gamma or gaussian noise function is fitted
%
% * filt is a filtering option of image segmentation
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
% www.biophysics.fr

if nargin<3
    error('You must provide a ground truth, confocal properties, and a sample image, ');
end
defopt=cgn_options_load();
if nargin<4
    options=defopt;
end

if isfield(options,'sampling')
    sample_options=options.sampling;
else
    sample_options=defopt.sampling;
end

if ~isfield(options,'verbose')
    options.verbose=defopt.verbose;
end
% Finding parameters from the image
[sig,noise]=get_img_params(sample,sample_options);
% Confocal generator
[stacks,offset,achieved_sig,achieved_noise,im]=stack_generator(img,conf,sig,noise,options);

end

