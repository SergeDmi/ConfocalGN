function [ res,truth,sample_prop] = confocal_generator(truth,conf,sample,options)
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
% * sample contains the information on the image to emulate
%       
%       sample.image : sample image to find background noise and mean signal value
%       from this, a gamma or gaussian noise function is fitted
%       sample.sig : mean value of signal voxels
%       sample.noise : moments of the background voxel values
%
% * options are the options to be used by confocalGN
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

%% Options loading
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

%% Checking the input
% Checking if the sample is an image or the signal/background moments
% If an image, extracting the signal and background moments
if isfield(sample,'sig') && isfield(sample,'noise')
    noise=sample.noise;
    sig=sample.sig;
    if isfield(sample,'img')
        sample_prop.img=sample.img;
    end
else
    if isnumeric(sample)
        % Sample is an image
        sample_prop.img=sample;
        [sig,noise]=get_img_params(sample,sample_options);
    elseif ischar(sample)
        % Sample is the path to an image
        sample_prop.img=sample;
        [sig,noise]=get_img_params(sample,sample_options);
    elseif isfield(sample,'img') 
        % Sample.img is an image
        sample_prop.img=sample.img;
        [sig,noise]=get_img_params(sample.img,sample_options);
    else
        error('You must provide a valid sample for noise and signal');
    end
end
sample_prop.sig=sig;
sample_prop.noise=noise;
        
%% The confocal generator itself
[res,truth]=stack_generator(truth,conf,sig,noise,options);

end

