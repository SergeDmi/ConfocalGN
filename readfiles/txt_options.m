function [ opt ] = txt_options(  )
% Options for text parsing
%% File structures
% Delimiter between coordinates
opt.delimiter=' ';

%% Use comments for text files
% Lines starting with a comment are discarded
opt.comments={'%','#','fiber','frame','Volume','Set'};

%% Use indicators for lines to keep
% Lines not starting by an indicator are discarded
% Warning : using indicators overrides opt.comments
% E.g. for and .obj file
% opt.indicators={'v','vn','vt'};

%% Range of columns to take
opt.range=3:5;
end

