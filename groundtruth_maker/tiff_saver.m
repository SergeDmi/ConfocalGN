function [  ] = tiff_saver( data,path,options )
% Wrapper for saveastiff
%   Limiting data format

datatype='';
if nargin==3
    if isfield(options,'format')
        datatype=options.format;
    end
end
   
if ~isempty(datatype)
    data=cast(data,datatype);
end

if nargin<2
    saveastiff(data);
elseif nargin<3
    saveastiff(data,path);
else
    saveastiff(data,path,options);
end

end