function [ stack,offset] = generate_stacks( truth,conf,sig,noise,options)
% generate_stacks : make mock confocal data from a ground truth
%   Distributed under the terms of the GNU Public licence GPL3
%
%% INPUT :
% * truth is the orginal ground truth
%       - truth.img & truth.pix : high resolution image and pixel size
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
%
%  sig   : mean value of signal voxels
%  noise : moments of the background voxel values
%
%% OUTPUT
% * stack is the simulated confocal stack
%
% * offset is the translation in x,y,z to go back to the original
% coordinates system
%   
%
% Serge Dmitrieff, Nédélec Lab, EMBL 2016
% www.biophysics.fr

%% Verifying input
if nargin<2
    error('You must provide an image and confocal imaging properties');
end
if ~isfield(truth,'img')
    error('Improper ground truth format : should be stored in truth.img')
else
    img=truth.img;
end
if ~isfield(truth,'pix')
    error('You must provide a pixel size')
elseif isempty(truth.pix)
    error('You must provide a pixel size')
else
    %% Stack generation
    psf=conf.psf;
    if isnumeric(psf)
        if 4>length(psf)
            psf=psf./truth.pix;
        end
    end
    pix=conf.pix./truth.pix;
end

if ischar(img)
    imgs=tiffread(img);
    img=get_stack(imgs);
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
defopt=defopt.segmentation;

if nargin<5
    options=defopt;
else
    options=complete_options(options,defopt);
end
if isfield(options,'format')
    datatype=options.format;
else
    datatype='';
end
%% 3D Convoluting of the image
[img,off1]=convolve_with_psf(img,psf);
%% Taking the pixels 
[stack,off2,nn]=stack_from_img(img,pix);
offset=off1+off2;

%% Generating pixel noise
px_noise=pixel_distribution(noise,nn);

%% Estimating signal & noise levels and calibrating noise
[ Ssig,Snoise] = get_img_params(stack,options);
S=Ssig(1);
B=Snoise(1);
% Desired signal to noise 
SNR=sig(1)/noise(1);
% Linear algebra on stack to reach desired signal and noise level
b=(S-SNR*B)/(SNR-1);
a=1/(B+b);
stack=a*(stack+b);
%% We multiply the stack by the noise
stack(:)=stack(:).*px_noise(:);

if ~isempty(datatype)
    stack=cast(stack,datatype);
end

end
