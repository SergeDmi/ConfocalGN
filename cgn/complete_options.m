function [ opt ] = complete_options(opt,defopt,ofields)
%COMPLETE OPTIONS completes missing fields in an option structure
%   By comparing it to the default options
%% Copyright
% This file is part of ConfocalGN, a generator of confocal microscopy images
% Serge Dmitrieff, Nédélec Lab, EMBL 2015-2017
% https://github.com/SergeDmi/ConfocalGN
% Licenced under GNU General Public Licence 3

if nargin<2
    error('Complete options : Not enough arguments')
elseif nargin<3
    % Completing all fields
    ofields=fields(defopt);
end

%% For a fields, checking is field exists
nf=numel(ofields);
for n=1:nf
    fname=ofields{n};
    if ~isfield(opt,fname)
        % Loading from the default options
        value=getfield(defopt,fname);
        opt=setfield(opt,fname,value);
    end
end

end

