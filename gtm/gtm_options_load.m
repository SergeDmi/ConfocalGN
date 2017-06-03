function opt = gtm_options_load(verbose)
% Load options present in current working directory,
% or load default options
%
% F. Nedelec, 20 Nov. 2012
%% Copyright
% This file is part of ConfocalGN, a generator of confocal microscopy images
% Serge Dmitrieff, Nédélec Lab, EMBL 2015-2017
% https://github.com/SergeDmi/ConfocalGN
% Licenced under GNU General Public Licence 3


if nargin < 1
    verbose = [];
end


%% Load options

f = 'gtm_options.m';

if exist(f,'file')==2
    
    opt = gtm_options;
    if isfield(opt,'verbose') && isempty(verbose)
        verbose=opt.verbose;
    end
        
    if verbose
        fprintf(2,'Loading local options from %s\n', f);
    end
        
    
    
else
    
    opt = gtm_options_default;
    
    if isfield(opt,'verbose') && isempty(verbose)
        verbose=opt.verbose;
    end
        
    if verbose
        fprintf(2,'Loading default options\n');
    end
    
    

end

end