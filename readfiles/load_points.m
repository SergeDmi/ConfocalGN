function [ points ] = load_points( input,options )
% Load points from a text file
%   Wrapper function for import from text

if nargin < 2
    points=import_from_text(input);
else
    points=import_from_text(input,options);
end

end

