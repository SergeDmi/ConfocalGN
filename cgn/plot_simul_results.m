function [  ] = plot_simul_results(truth,res,conf,options)
% Plots results of simulated stacks
%   compares ground truth to simulated
%   see confocal_generator for definitions of truth, res, conf

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
im=res.img;
offset=res.offset.*truth.pix;

%% Convert from stack to pixel coordinatees Pts and intensities W
% (because of smaller scale, there is an offset between the stack and
% the ground truth) 
[Pts,W]  = convertpoints(im, conf.pix, offset);

%% Converting ground truth image to points
%img2=segment_image(truth,options);
%pts = convertpoints(img2);
pts=truth.points';

%% convert the coordinates to physical units
if length(truth.pix)==1
    pts(:)=pts(:).*truth.pix;
elseif length(truth.pix)==3
    np=size(pts,2);
    pts(:,:)=pts(:,:).*(ones(np,1)*truth.pix(:));
end
    
%% Plot data points:
% In blue : simulated pixels after thresholding
% In black : ground truth
figure
hold all
scatter3(Pts(1,:),Pts(2,:),Pts(3,:),30,W,'filled')
scatter3(pts(1,:),pts(2,:),pts(3,:),'k.')
axis equal

end

