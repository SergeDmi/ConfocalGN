% Example file,
% to use ConfocalGN to simulate confocal imaging
% Serge Dmitrieff, Nédélec Lab, EMBL 2015-2016
% http://biophysics.fr

%% Ground truth

% Ground truth can be an image file or a stack, in high resolution

truth='ground_truth.tiff';
save=0;
display=1;
plot=1;

%% Parameters for ConfocalGN

% pix : number of pixels of the ground truth in a confocal voxel
% ground truth is high res compared to confocal
conf.pix=[8 8 32];

% Property of the microscope PSF
% Standard deviation of the PSF in the 3 dimensions provided in units of ground truth pixel size
conf.psf=[13 13 22];


%% Here we present two ways of using ConfocalGN
if 1
    % Reading Noise and Signal parameters from image
    sample='sample_image.tiff';
    %% Making a ground truth file if there is none
    if exist(truth, 'file')<2
        make_ground_truth(truth)
        disp('Generated ground truth')
    end
    %% Generating the stack from the image
    % Includes pixel noise
    [stacks,offset,achieved_sig,achieved_noise,im,mean_sig,noise]=confocal_generator(truth,conf,sample);
else
    % Using noise and signal values
    % pixel noise from camera
    noise=[556 1.0371e+04 1.0926e+06]';
    % Estimated mean pix value in signal
    mean_sig=1.0022e+03;
    [stacks,offset,achieved_sig,achieved_noise,im]=stack_generator(truth,conf,noise,mean_sig);
end

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
if plot
    plot_simul_results(truth,im,conf,offset)
end
