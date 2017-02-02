function opt = cgn_options_default
% Provide the options to analyse
%
% They are loaded by cgn_option_load.m,
% which also check for a local 'cgn_options.m'
%
%

% Options for image segmentation
opt.segmentation.filt             = [1 1 0];
opt.segmentation.ix               = [];

% Options for sample segmentation
opt.sampling.filt                   = [1 1 0];
opt.sampling.ix                     = 9:16;

% Misc
opt.verbose                       = 0;

return