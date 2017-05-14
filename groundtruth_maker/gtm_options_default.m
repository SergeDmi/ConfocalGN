function opt = gtm_options_default
% Provide the options to analyse
%
% They are loaded by gtm_option_load.m,
% which also check for a local 'gtm_options.m'
%
%

%% Options for the output image
opt.image_size            = [512 512 162];
opt.offset             =  [];
opt.scaling             =  1;

%% Options for the signal
opt.signal                  = 10 ;
opt.fluorophore                  = 'poisson';
%opt.fluorophore                  = 'permanent';

%% Options for the background
% moments of the background fluorescence distribution
opt.background                  = [0 0 0] ;

%% Misc
% moments of the background fluorescence distribution
opt.verbose                = 1 ;

return