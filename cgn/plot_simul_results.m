function [  ] = plot_simul_results(truth,im,conf,offset,options)
% plot results of simulated stacks
%   compares ground truth to simulated

defopt=cgn_options_load();
if nargin<5
    options=defopt;
    if nargin<1
        error('Error : get_img_params requires an image or or image filename')
    end
end
if isfield(options,'segmentation')
    options=options.segmentation;
end


%% Convert from stack to pixel coordinatees Pts and intensities W
% (because of smaller scale, there is an offset between the stack and
% the ground truth) 
Pts  = convertpoints(im, conf.pix, offset);

%% Converting ground truth image to points
img2=segment_image(truth,options);
pts = convertpoints(img2);

%% convert the coordinates to voxel units
Pts(:)=Pts(:)/conf.pix(1);
pts(:)=pts(:)/conf.pix(1);

%% Plot data points:
% In blue : simulated pixels after thresholding
% In black : ground truth
figure
hold all
scatter3(pts(1,:),pts(2,:),pts(3,:),'k.')
scatter3(Pts(1,:),Pts(2,:),Pts(3,:),'b')
axis equal


end

