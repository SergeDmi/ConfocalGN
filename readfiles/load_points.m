function [ points ] = load_points( input,options )
% Load points from a text file
%   Wrapper function for import from text
%% Copyright
% This file is part of ConfocalGN, a generator of confocal microscopy images
% Serge Dmitrieff, Nédélec Lab, EMBL 2015-2017
% https://github.com/SergeDmi/ConfocalGN
% Licenced under GNU General Public Licence 3

if nargin < 2
    points=import_from_text(input);
else
    points=import_from_text(input,options);
end

end

