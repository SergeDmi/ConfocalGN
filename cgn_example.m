% Example file,
% to use ConfocalGN to simulate confocal imaging
% Serge Dmitrieff, Nédélec Lab, EMBL 2015-2016
% http://biophysics.fr


%% Example options
save=0;
display=1;
do_plot=1;

%% Ground truth
% - Ground truth can be an image file or a stack, in high resolution
% associated to the size of the high resolution voxel
%truth.img='ground_truth.tiff';
%truth.pix=[11.5 11.5 11.5];
% - Or the ground truth can be fluorophore coordinates
truth.source='ground_truth.txt';


%% Parameters for ConfocalGN
% pix : size of a simulated voxel
% ground truth is high res compared to confocal
conf.pix=[150 150 600];
% Property of the microscope PSF
% Standard deviation of the PSF in the 3 dimensions provided in units of ground truth pixel size
conf.psf=[250 250 500];


%% Here we present two ways of using ConfocalGN
if 1
    % Reading Noise and Signal parameters from image
    sample='sample_image.tiff';
    %% Generating the stack from the image
    % Includes pixel noise
    [res,truth,sample_prop]=confocal_generator(truth,conf,sample);
else
    % Using noise and signal values
    % pixel noise from camera
    noise=[556 1.0371e+04 1.0926e+06]';
    % Estimated mean pix value in signal
    mean_sig=1.0022e+03;
    [res,truth,sample_prop]=stack_generator(truth,conf,noise,mean_sig);
end
stacks=res.stack;

%% Save simulated image
if save
    output='simulated_stack.tiff';
    saveastiff(stacks,output);
end

%% Display simulated image:
if display
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
