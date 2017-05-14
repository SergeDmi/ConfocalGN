function [ opt ] = txt_options(  )
% Options for text parsing
%% File structures
opt.delimiter=' ';
opt.maxim=3;

%% Use comments for text files
% Lines starting with a comment are discarded
opt.comments={'%','#','fiber','frame','Volume','Set'};

%% Use indicators for .obj files
% Lines not starting by an indicator are discarded
% Warning : using indicators overrides oppt.comments
% opt.indicators={'v','vn','vt'};

%% Range of points to take
opt.range=3:5;
end

