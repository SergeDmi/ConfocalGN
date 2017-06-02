function [ res,truth,sample_prop] = confocal_generator(truth,conf,sample,options)
% confocal_generator : make mock confocal data from a ground truth
%   Distributed under the terms of the GNU Public licence GPL3
%
%% INPUT :
% * truth is the orginal ground truth
%   either 
%       - truth.source : coordinates of fluorophores
%       - truth.img & truth.pix : high resolution image and pixel size
%   . If truth.source is provided, it will be converted to an image truth.img 
%   using make_ground_truth.
%   . truth.img can be either a matrix or the path to a tiff file
%    truth.pix is the size of a pixel in physical units
%   
%   truth.img should be a high resolution image such as a confocal voxel
%   encompasses a large number of ground truth pixels. It should already 
%   have background noise included if any.
%   This image will be convolved with the psf
%
% * conf.psf is the point spread function of the microscope 
%       it is the 2-way psf (i.e. illumination+observation)
%       also called confocal psf  
%   It can be :
%       - Either a 1x3 vector
%   this assumes the psf to be gaussian (which provides fast convolution)
%   the PSF is in units of the size of original image pixel 
%   ex : psf = [wx,wy,wz] where wi is the gaussian spread on axis i
%       - or an image to be convolved to the ground truth image
%   In this case, make sure the grount truth image and the PSF image have
%   pixels of the same physical size
%
% * conf.pix is a (1x3 vector) containing the voxel size of the microscope
%   in physical units
%
% * sample contains the information on the image to emulate
%       - Either 
%               sample.image 
%   sample image to find background noise and mean signal value
%	from this, a gamma or gaussian noise function is fitted
%       - Or 
%               sample.sig   : mean value of signal voxels
%             & sample.noise : moments of the background voxel values
%
% * options are the options to be used by confocalGN
%
%% OUTPUT :
%
% res is the result containing : 
%   res.stack : the simulated stack
%   res.sig : mean value of simulated signal voxels
%   res.noise : moments of the simulated background voxels values
%   res.img : the image obtained from segmenting res.stack
%   res.offset : spatial offset between the stack and the ground truth
% truth is the structure containing
%   truth.points : fluorophore coordinates of the ground truth
%   truth.img : ground truth image
%   truth.pix : size of a ground truth pixel in physical units
% sample is the sample information, containing :
%   sample.sig : mean value of the sample signal voxels
%   sample.noise : moments of the sample background voxels values
%   (sample.img) : sample image
%
%% RATIONALE
% We convolve the ground truth with the confocal PSF. The PSF should be the
% one measured experimentally from control sample (e.g. bead). So it is
% really how a point *object* would be seen. I.e. it is the 2-way PSF.
%
% The PSF is often Gaussian for a confocal microscope, which can be taken
% advantage of. ConfocalGN also supports non-Gaussian PSF via PSF images.
%
% After convolution, a MULTIPLICATIVE noise is added to the voxels.
% Noise characteristics can be extracted from a sample image.
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

