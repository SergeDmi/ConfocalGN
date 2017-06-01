function opt = cgn_options_default
% Provide the options to analyse
%
% They are loaded by cgn_option_load.m,
% which also check for a local 'cgn_options.m'
%
%


%% Options for image segmentation
% Filter to be used before thresholding
opt.segmentation.filt             = [1 1 0];
% Indexes of items to be kept when loading the stack
opt.segmentation.ix               = [];

%% Options for sample segmentation
% Filter to be used before thresholding
opt.sampling.filt                 = [1 1 0];
% Indexes of items to be kept when loading the stack
opt.sampling.ix                   = 9:16;

%% Misc
opt.verbose                       = 1;

return