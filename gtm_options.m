function opt = gtm_options
% Provide the options to analyse
%
% They are loaded by gtm_option_load.m,
% which also check for a local 'gtm_options.m'
%
%% Copyright
% This file is part of ConfocalGN, a generator of confocal microscopy images
% Serge Dmitrieff, Nédélec Lab, EMBL 2015-2017
% https://github.com/SergeDmi/ConfocalGN
% Licenced under GNU General Public Licence 3


%% Options for the output image
% Specify image_size or pixel sizes
% Image size in pixels
opt.image_size            =  [512 512 162];
% Size of pixels in physical units
opt.pix_size              = [];
% Spatial offset in physical units
opt.offset                =  [];
% Rotation of the points
opt.rotation              =  [0 0 0];
% Margin around the points 
opt.overscale             =  1.5;
% Scaling between the fluorophore coordinates and physical units
opt.pts_scale             = 1000;
% Image data type
opt.format = 'single';
%% Options for the signal
% Mean signal value
opt.signal                = 100 ;
% Fluorophore properties
opt.fluorophore           = 'poisson';
%opt.fluorophore          = 'permanent';

%% Options for the background
% moments of the background fluorescence distribution
opt.background            = [0] ;
%opt.background           = [10 1 1] ;

%% Misc
opt.verbose               = 1 ;
opt.truth_fname           = '' ;

return