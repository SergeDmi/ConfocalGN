function [  ] = tiff_saver_16( data,path,options )
% Wrapper for saveastiff
%   Limiting data format

data=uint16(data);

if nargin<2
    saveastiff(data);
elseif nargin<3
    saveastiff(data,path);
else
    saveastiff(data,path,options);
end

end