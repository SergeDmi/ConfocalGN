function image = load_pixels(image)

% Load the pixel data for the given image,
%
% Syntax:
%         load_pixels(image)
%
% image should be a struct with the following fields:
% * image.file_name
% * image.index
% * image.channel
%
% See also
%       make_image_list
%
% F. Nedelec - 25 Oct 2012

im = tiffread(image.file_name, image.index);


%copy the pixel size which is stored in the LSM meta-data
if isfield(im, 'lsm') && isfield(im.lsm, 'VoxelSizeX') && isfield(im.lsm, 'VoxelSizeY')
    if ( im.lsm.VoxelSizeX == im.lsm.VoxelSizeY )
        image.pixelSize = im.lsm.VoxelSizeX * 1e6; %convert to micro-meters
    end
end



% get specified channel in color images:
if iscell(im.data)
    image.data = im.data{image.channel};
else
    image.data = im.data;
end

end