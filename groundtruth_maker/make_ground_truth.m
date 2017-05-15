function [truth]=make_ground_truth(truth,outfile,options)
% Wrapper function to make a ground truth image from points
%   We make this image from the points provided by input

if nargin < 2
    outfile=[];
    if nargin <1
        error('Please provide source to make ground truth');
    end
end

if nargin < 3
    [img,points,pix]=make_img_from_points(truth.source);
else
    [img,points,pix]=make_img_from_points(truth.source,options);
end

truth.img=img;
truth.points=points;
truth.pix=pix;

if ~isempty(outfile)
    tiff_saver_16(img,outfile);
end

end