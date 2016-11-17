% Example file,
% to use ConfocalGN to simulate confocal imaging
% Serge Dmitrieff, Nédélec Lab, EMBL 2015-2016
% http://biophysics.fr

%% Ground truth

% Ground truth can be an image file or a stack, in high resolution

truth='ground_truth.tiff';

%% Parameters for ConfocalGN

% pix : number of pixels of the ground truth in a confocal voxel
% ground truth is high res compared to confocal
conf.pix=[8 8 32];

% Property of the microscope PSF
% Standard deviation of the PSF in the 3 dimensions provided in units of ground truth pixel size
conf.psf=[13 13 22];

if 1
    % Reading Noise and Signal parameters from image
    sample='sample_image.tiff';
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


%% Display simulated image:
for i = 1:size(stacks, 3)
    show(stacks(:,:,i));
end


%% Display Image segmentation & plotting to compare simulated data to original
if 1
    % Convert from stack to pixel coordinatees Pts and intensities W
    % (because of smaller scale, there is an offset between the stack and
    % the ground truth) 
    [ Pts, W ] = convertpoints(im, conf.pix, offset);

    % Converting ground truth image to points
    [ ~,~,img2] = get_img_params(truth);
    pts = convertpoints(img2);

    % convert the coordinates to voxel units
    Pts(:)=Pts(:)/conf.pix(1);
    pts(:)=pts(:)/conf.pix(1);

    % Plot data points:
    figure
    hold all
    scatter3(pts(1,:),pts(2,:),pts(3,:),'k.')
    scatter3(Pts(1,:),Pts(2,:),Pts(3,:),'b')
    axis equal

end
