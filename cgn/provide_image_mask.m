function [mask] = provide_image_mask(image,options)
% Wrapper function for image segmentation functions
%   Replace by the appropriate image segmentation function

%% Here image segmention function
if nargin>1
    [~,mask]=segment_image(image,options);
else
    [~,mask]=segment_image(image);
end

end

