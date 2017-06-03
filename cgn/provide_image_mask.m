function [mask] = provide_image_mask(image,options)
% Wrapper function for image segmentation functions
%   Replace by the appropriate image segmentation function
%% Copyright
% This file is part of ConfocalGN, a generator of confocal microscopy images
% Serge Dmitrieff, Nédélec Lab, EMBL 2015-2017
% https://github.com/SergeDmi/ConfocalGN
% Licenced under GNU General Public Licence 3

%% Here image segmention function
if nargin>1
    [~,mask]=segment_image(image,options);
else
    [~,mask]=segment_image(image);
end

end

