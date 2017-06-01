function [truth]=make_ground_truth(source,outfile,options)
% Wrapper function to make a ground truth image from points
%   We make this image from the points provided by input
%
% Serge Dmitrieff. Copyright EMBL 2017.

if nargin <1
    error('make_ground_truth requires at least one argument');
end

if isfield(source, 'source')
    source = source.source;
end

if nargin < 3
    [img,points,pix]=make_img_from_points(source);
else
    [img,points,pix]=make_img_from_points(source,options);
end

%% Checking output format
truth.source=source;
truth.img=img;
truth.points=points;
truth.pix=pix;

%% Exporting to a tiff image
if nargin > 1
    if ~isempty(outfile) 
        tiff_saver_16(img,outfile);
    end
end

end