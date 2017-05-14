function [img,points]=make_ground_truth(input,outfile,options)
% Wrapper function to make a ground truth image from points
%   We make this image from the points provided by input

if nargin < 2
    outfile=[];
    if nargin <1
        error('Please provide source to make ground truth');
    end
end

if nargin < 3
    [img,points]=make_img_from_points(input);
else
    [img,points]=make_img_from_points(input,options);
end

if ~isempty(outfile)
    tiff_saver_16(img,outfile);
end

end