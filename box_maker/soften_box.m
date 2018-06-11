% Example file,
%% Copyright
% This file is part of ConfocalGN, a generator of confocal microscopy images
% Serge Dmitrieff, Nédélec Lab, EMBL 2015-2017
% https://github.com/SergeDmi/ConfocalGN
% Licenced under GNU General Public Licence 3


%% Example options
do_save=1;
do_display=0;
do_plot=0;

%% Ground truth
% - Ground truth can be an image file or a stack, in high resolution
%       associated to the size of the high resolution voxel
%      E.G.
%              truth.img='ground_truth.tiff';
%              truth.pix=[11.5 11.5 11.5];
% - Or the ground truth can be fluorophore coordinates
truth.img=Img;
truth.pix=[1 1 1];
%% Parameters for ConfocalGN
% conf.pix : size of a simulated voxel in physical units (e.g. nanometer)
% ground truth should be of high resolution
% i.e; conf.pix(:) >> truth.pix(:)
conf.pix=[1 1 1];
% conf.psf : 2-way point spread funciton
% Can be either :
% - Standard deviation of the PSF in the 3 dimensions (in physical units)
% - an image to be convolved with ground truth truth.img
conf.psf=[2 2 2];
%conf.psf='gauss_psf.tiff';

%% Here we present two ways of using ConfocalGN
if 0
    % Reading Noise and Signal parameters from image
    sample='sample_image.tiff';
    %% Generating the stack from the image
    [res,truth,sample]=confocal_generator(truth,conf,sample);
else
    % Using user-defined noise and signal values
    sample.noise=[0 0 0]';
    sample.sig=1.0022e+03;
    %% Generating the stack from the image
    [res,truth,sample]=confocal_generator(truth,conf,sample);
end
%% Output : 
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


%% Plotting and saving
stacks=res.stack;

%% Save simulated image
if do_save
    output='simulated_stack_w.tiff';
    opt.format='single';
    tiff_saver(stacks,output,opt);
end

%% Display simulated image:
if do_display
    for i = 1:size(stacks, 3)
        show(stacks(:,:,i));
    end
end

%% Display Image segmentation & plotting to compare simulated data to original
if do_plot
    if isfield(truth,'points')
        plot_simul_results(truth,res,conf)
    end
end
