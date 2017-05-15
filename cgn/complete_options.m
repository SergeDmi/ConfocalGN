function [ opt ] = complete_options(opt,defopt,ofields)
%COMPLETE OPTIONS copletes missing fields in an option structure
%   By comparing it to the default options

if nargin<2
    error('Complete options : Not enough arguments')
elseif nargin<3
    % Completing all fields
    ofields=fields(defopt);
end

%% For a fields, checking is field exists
nf=numel(ofields);
for n=1:nf
    fname=ofields{n};
    if ~isfield(opt,fname)
        % Loading from the default options
        value=getfield(defopt,fname);
        opt=setfield(opt,fname,value);
    end
end

end

