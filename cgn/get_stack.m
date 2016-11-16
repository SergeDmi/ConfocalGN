function [ stack ] = get_stack( imgs )
% Convert an image read from tiffread into a stack
%   Because sometimes tiffread does weird things... 
%   Mostly because matlab doesn't have a great way to save tiff files
%
% Rationale : imgs was read from tiffread is either :
% [a] A collection of objects ; each object is one slice of stack
% The data elements contain a 2D array and should not be in cell format
% [b] One object, of which data is a cell array, each cell containing
% a 2D array which is a slice of the stack
%
% Serge Dmitrieff, Nédélec lab, EMBL, 2016
% www.biophysics.fr

n=length(imgs);
if n>1
    if ~iscell(imgs(1).data)
        % Best case scenario, properly saved tiff : case [a]
        s=size(imgs(1).data);
        s(3)=n;
        stack=zeros(s);
        for i=1:n
            stack(:,:,i)=imgs(i).data;
        end
    else
        % Weird  scenario
        % img saved like case [a] but data is a cell
        s=size(imgs(1).data{1});
        s(3)=n;
        stack=zeros(s);
        for i=1:n
            if length(imgs(i).data>1)
                error('Unsupported tiff format : stack of stacks')
            end
            stack(:,:,i)=imgs(i).data;
        end
    end
else
    if ~iscell(imgs.data)
        % img saved like case [a] but only 2D
        s=size(imgs.data);
        s(3)=1;
        stack=zeros(s);
        stack(:,:,1)=imgs(1).data;
    else
        % img saved like case [b] 
        ns=length(imgs.data);
        s=size(imgs.data{1});  
        s(3)=ns;
        stack=zeros(s);
        for i=1:ns
            stack(:,:,i)=imgs(1).data{i};
        end
    end
end

