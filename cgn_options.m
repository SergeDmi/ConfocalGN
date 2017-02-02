function opt = confocal_options
% Provide the options to analyse
%
% They are loaded by confocal_load_option.m,
% which also check for a local 'confocal_options.m'
%
%

% Options for image segmentation
opt.segmentation.filt             = [1 1 0];
opt.segmentation.ix               = [];
% Options for sample segmentation
opt.sampling.filt                   = [1 1 0];
opt.sampling.ix                     = 9:16;
% Misc
opt.verbose                       = 1;
return