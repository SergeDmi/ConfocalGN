function [mask] = provide_image_mask(image,options)
% Wrapper function for image segmentation functions
%   Replace by the appropriate image segmentation function

%% Here image segmention function
[~,mask]=segment_image(image,options);

end

