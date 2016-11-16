% Example of mock confocal data generation
%   We first generate a baseball seam curve
%   We then make it confocal
% Serge Dmitrieff, Nédélec Lab, EMBL 2015
% http://biophysics.fr

%% Ground truth 
% Ground truth can be an image file or a stack
% Must be high resolution
img='ground_truth.tiff';

%% CONFOCAL GN Parameters
% pix : number of pixels of the ground truth in a confocal voxel
% ground truth is high res compared to confocal
conf.pix=[8 8 32];
% Psf : Property of the microscope
% Size pf the psf in the 3 dimensions in units of ground truth pixel size
conf.psf=[13 13 22];


%% Reading Noise and Signal parameters from image
if 1
    % sample image
    sample='sample_image.tiff';
    %% Generating the stack from the image
    % Includes pixel noise
    [stacks,offset,achieved_sig,achieved_noise,im,mean_sig,noise]=confocal_generator(img,conf,sample);
else
%% Using noise and singal values 
    % pixel noise from camera
    noise=[556 1.0371e+04 1.0926e+06]';
    % Estimated mean pix value in signal
    mean_sig=1.0022e+03;
    [stacks,offset,achieved_sig,achieved_noise,im]=stack_generator(img,conf,noise,mean_sig);
end

%% Graphical output : Image segmentation & plotting to compare simulated data to original
if 1
    pix=conf.pix;
    % We then convert from stack to pixel coordinatees Pts and intensities W
    % (because of smaller scale, there is an offset between the stack and
    % the ground truth) 
    [ Pts,W ] = convertpoints( im , conf.pix,offset);
    % Converting ground truth image to points
    [ ~,~,img2] = get_img_params(img);
    pts = convertpoints( img2 );
    % We convert the coordinates to voxel units
    Pts(:)=Pts(:)/pix(1);
    pts(:)=pts(:)/pix(1);
    % Plotting
    figure
    hold all
    scatter3(pts(1,:),pts(2,:),pts(3,:),'k.')
    scatter3(Pts(1,:),Pts(2,:),Pts(3,:),'b')
    axis equal
end
