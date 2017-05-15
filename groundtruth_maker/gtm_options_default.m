function opt = gtm_options_default
% Provide the options to analyse
%
% They are loaded by gtm_option_load.m,
% which also check for a local 'gtm_options.m'
%
%

%% Options for the output image
% Specify image_size or pixel sizes
opt.image_size            =  [512 512 162];
opt.pix_size               = []; 
opt.offset                =  [];
opt.rotation              =  [0 0 0];
opt.overscale                =  1.5;
opt.pts_scale                = 1;
%% Options for the signal
opt.signal                  = 100 ;
opt.fluorophore                  = 'poisson';
%opt.fluorophore                  = 'permanent';

%% Options for the background
% moments of the background fluorescence distribution
%opt.background                  = [1 1 1] ;
opt.background            = [10 1 1] ;

%% Misc
% moments of the background fluorescence distribution
opt.verbose               = 1 ;

return