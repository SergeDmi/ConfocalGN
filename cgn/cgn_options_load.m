function opt = cgn_options_load(verbose)
% Load options present in current working directory,
% or load default options
%
% F. Nedelec, 20 Nov. 2012

if nargin < 1
    verbose = 0;
end


%% Load options

f = dir('cgn_options.m');

if ~ isempty(f)
    
    if verbose
        fprintf(2,'Loading local options from %s\n', f.name);
    end
        
    opt = cgn_options;
    
else
    
    if verbose
        fprintf(2,'Loading default options\n');
    end
    
    opt = cgn_options_default;

end


end