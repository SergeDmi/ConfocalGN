function opt = load_options(verbose)
% Load options present in current working directory,
% or load default options
%
% F. Nedelec, 20 Nov. 2012

if nargin < 1
    verbose = 0;
end


%% Load options

f = dir('confocal_options.m');

if ~ isempty(f)
    
    if verbose
        fprintf(2,'Loading local options from %s\n', f.name);
    end
        
    opt = confocal_options;
    
else
    
    if verbose
        fprintf(2,'Loading default options\n');
    end
    
    opt = confocal_default_options;

end


end