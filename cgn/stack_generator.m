function [ stack,offset,SIG,NOISE,img] = stack_generator( img,conf,sig,noise,options)
% stac_generator : make mock confocal data from a ground truth
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
% * noise is (at least) the two first moments of the noise distribution
%   If the distribution is skewed enough (large enough third moment)
%   it is modeled by gamma function
%   Otherwise, the noise is gaussian
%
% * sig is the moments of the signal distribution
%       sig(1) is the aim for the signal mean pixel value
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
% Serge Dmitrieff, N??d??lec Lab, EMBL 2016
% www.biophysics.fr

if nargin<2
    error('You must provide an image and confocal imaging properties');
end



if nargin>2
   if sig(1)<0
        error('Invalid expected mean signal');
   elseif sig(1)<noise(1);
       warning('Signal expected lower than signal');
   end
else 
    error('No signal level specified');
end


if nargin<4
    noise=[0 0 0];
    warning('No noise');
else
    if length(noise)<2
        error('Invalid noise properties (not enough moments)');
    else
        if length(noise)==2
            noise(3)=0;
        end
    end
end

defopt=cgn_options_load();
if nargin<5
    options=defopt;
end
if isfield(options,'segmentation')
   seg_options=options.segmentation;
else
    seg_options=defopt.segmentation;
end

%% Stack generation
[ stack,offset] = generate_stacks( img,conf,sig,noise,seg_options);
[SIG,NOISE,img]=get_img_params(stack,seg_options);


% we compare the 'target' signal and noise (sig,noise) to the signal and
% noise obtained by the simulator
if options.verbose>0
    disp(['Target mean_pix : ' num2str(sig') '  -  target noise : ' num2str(noise')])
    disp(['        Target SNR : ' num2str(sig(1)/noise(1))])
    disp(['Achieved mean_pix : ' num2str(SIG') '  -  achieved noise : ' num2str(NOISE')])
    disp(['        Achieved SNR : ' num2str(SIG(1)/NOISE(1))])
end

end

