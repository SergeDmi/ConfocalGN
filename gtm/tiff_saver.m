function [  ] = tiff_saver( data,path,options )
% Wrapper for saveastiff
%   Limiting data format
%% Copyright
% This file is part of ConfocalGN, a generator of confocal microscopy images
% Serge Dmitrieff, Nédélec Lab, EMBL 2015-2017
% https://github.com/SergeDmi/ConfocalGN
% Licenced under GNU General Public Licence 3

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