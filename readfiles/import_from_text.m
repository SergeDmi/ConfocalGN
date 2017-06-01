function [ points ] = import_from_text( input,options)
%IMPORT_FROM_TEXT loads points from a text file
%   Assumes the text file to be nice enough
%   It is quite versatile but slow ! 
%   Better use custom code for your filetype 
%   Can read from .txt files or .obj files
%   
%
% Reads coordinates from file, keeping only EITHER
% - non-commented lines (comments specified in options.comments)
%   OR
% - lines with a keyword indicator (if comments.indics is not empty)
%
% Keeps only certain columns, specified by options.range
%
% Serge Dmitrieff, May 2017
% http://biophysics.fr


%% Loading options
if nargin<2
    options=txt_options;
end
if isfield(options,'delimiter')
    % Delimiters between words
    dlm=options.delimiter;
else
    dlm=' ';
end
if isfield(options,'comments')
    % Which keys determine commented lines
    comments=options.comments;
else
    comments={'%'};
end
if isfield(options,'indicators')
    % Which keys determine commented lines
    indics=options.indicators;
else
    indics={};
end
if isfield(options,'range')
    % Range of points
    cols=options.range;
else
    cols=1:3;
end
    

%% Reading input 
f = dir(input);
if ~isempty(f)  
    all_lines=readtext(input);
else
    all_lines={input};
end

%% Dissecting the lines 
% Converting the lines to points if possible
nl=length(all_lines);
lines(nl).pts=[];
np=0;
nc=0;
%% Mode of line section
% We can discard lines if the first word is a comment
%      Or keep lines ONLY if the first word is an indicator
mode=isempty(indics);
% Mode = 0 if looking for indicators of values to keep
% Mode = 1 if looking for indicators of comments to discard
if mode
    keys=comments;
else
    keys=indics;
end
    
for i=1:nl
    line=all_lines{i};
    if ~isempty(line)
        pts=[];
        verify=mode;
        % Trying matlab conversion
        pts=str2num(line);
        % If need be manual conversion
        if isempty(pts)   
            words=readtext(line,dlm,'','','textsource');
            w1=words{1};
            % Looking for a key (either comment or indicator)
            if isempty(str2num(w1))
                switch w1
                    case keys
                        verify=~mode;
                        % A key has beeen found !
                end
                if numel(words)>1
                    words=words(2:end);
                else
                    verify=0;
                end
            end
            % Getting the numbers
            if verify 
                for word=words
                    w=word{1};
                    if isnumeric(w)
                        pts=[pts w];
                    end
                end
            end
        end
        % Keeping the points read from file
        if ~isempty(pts)
            np=np+1;   
            lines(np).pts=pts;
            inc=length(pts); 
            lines(np).nc=inc;
            nc=max(nc,inc);
        end
    end
end

%% Compiling all points in an array
points=zeros(np,nc);
for i=1:np
    points(i,1:lines(i).nc)=lines(i).pts;
end

%% Keeping only the relevant columns
if ~isempty(cols)
    if max(cols)<=size(points,2)
        points=points(:,cols);
    end
end
    

end


