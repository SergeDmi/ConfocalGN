function opt = confocal_options
% Provide the options to analyse
%
% They are loaded by confocal_load_option.m,
% which also check for a local 'confocal_options.m'
%
%% Copyright
% This file is part of ConfocalGN, a generator of confocal microscopy images
% Serge Dmitrieff, Nédélec Lab, EMBL 2015-2017
% https://github.com/SergeDmi/ConfocalGN
% Licenced under GNU General Public Licence 3


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

%% Output image option
opt.format                    = 'single';

%% Misc
opt.verbose                       = 1;

return
