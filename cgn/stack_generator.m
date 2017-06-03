function [ res,truth] = stack_generator( truth,conf,sig,noise,options)
% stack_generator : make mock confocal data from a ground truth
%   Distributed under the terms of the GNU Public licence GPL3
%
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
%
%  sig   : mean value of signal voxels
%  noise : moments of the background voxel values
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
%
% Serge Dmitrieff, Nédélec Lab, EMBL 2016
% www.biophysics.fr

%% Input verification
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

%% Options verification
defopt=cgn_options_default;
if nargin<5
    options=cgn_options_load();
else
    options=complete_options(options,defopt);
end
seg_options=options.segmentation;


%% Loading image
make_truth=0;
if ~isfield(truth,'img')
    make_truth=1;
elseif isempty(truth.img)
    make_truth=1;
end

if make_truth
    if isfield(truth,'options')
        outfile=truth.options.truth_fname;
        truth_options=truth.options;
        truth=make_ground_truth(truth,outfile,truth_options);
    else
        outfile='';
        truth=make_ground_truth(truth,outfile);
    end
end

%% Generating stacks        
[ stack,offset] = generate_stacks( truth,conf,sig,noise,seg_options);

%% Formating output
[SIG,NOISE,img]=get_img_params(stack,seg_options);
res.stack=stack;
res.offset=offset;
res.sig=SIG;
res.noise=NOISE;
res.img=img;

%% Detailed output
if options.verbose>0
    % we compare the 'target' signal and noise (sig,noise) to the signal and
    % noise obtained by the simulator
    disp('Target:');
    disp(['    signal       ', num2str(sig', 6)]);
    disp(['    noise        ', num2str(noise', 6)]);
    disp(['    signal/noise ', num2str(sig(1)/noise(1))])
    disp('Achieved:');
    disp(['    signal       ', num2str(SIG', 6)]);
    disp(['    noise        ', num2str(NOISE', 6)]);
    disp(['    signal/noise ', num2str(SIG(1)/NOISE(1))]);
end

end

