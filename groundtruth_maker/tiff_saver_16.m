function [  ] = tiff_saver( data,path,options )
% Wrapper for saveastiff
%   Limiting data format

data=cast(data,'single');

if nargin<2
    saveastiff(data);
elseif nargin<3
    saveastiff(data,path);
else
    saveastiff(data,path,options);
end

end