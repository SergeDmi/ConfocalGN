function [img,points,pixsizes]=make_img_from_points(input,options)
% Generates an image from a list of points
%   Uses options or gtm_options 
%   input should be the points to convert to an image
%   Prepares points and image scale for generate_image
%
%% Copyright
% This file is part of ConfocalGN, a generator of confocal microscopy images
% Serge Dmitrieff, Nédélec Lab, EMBL 2015-2017
% https://github.com/SergeDmi/ConfocalGN
% Licenced under GNU General Public Licence 3

%% Reading options
defopt=gtm_options_default;
if nargin < 2 
    options=gtm_options_load();  
    if nargin <1
        error('Please provide points to make ground truth');
    end
else
    options=complete_options(options,defopt);
end

%% Preparing variable
fluo=options.signal;
bkgd=options.background;
mode=options.fluorophore;
sizes=options.image_size;
offset=options.offset;
pixsize=options.pix_size;
overscale=options.overscale;
pts_scale=options.pts_scale;
datatype=options.format;

%% Loading the points
if ischar(input)
    points=load_points(input);
else
    points=input;
end
    
if isempty(points)
    error('Error : empty points, please provide points to make ground thruth')
end
s=size(points);

%% Checking points dimensions
if s(2)>s(1)
    points=points';
    s=size(points);
end

if s(2)<3
    pp=zeros(s(1),3);
    pp(:,1:s(1))=points(:,:);
    points=pp;
end

if isempty(sizes) && isempty(pixsize)
    error('You must provide an image size or pixel size')
end

%% Scaling points coordinates if specified in options
if ~isempty(pts_scale)
    points=points.*pts_scale;
end

%% Defining the scaling, i.e. physical size of a pixel
if isempty(pixsize)
     % If no scaling, auto-scale to fit image size
    if options.verbose
        disp('Attempting to automatically scale points to fit in image')
    end
    ddiff=zeros(1,3);
    scales=ones(1,3);
    for i=1:3
        ddiff(i)=max(points(:,i))-min(points(:,i));
        scales(i)=ddiff(i)/sizes(i);
    end
    scaling=(max(scales)*overscale);
    pixsizes=scaling;
end
points=points./pixsizes;

%% Centering and scaling point to reach desired sizes
if isempty(offset)
    % If no offset, auto-offset to center the points
    if options.verbose
        disp('Attempting to automatically center points to fit in image')
    end
    bary=mean(points,1);
    center=sizes/2;
    offset=center-bary;
end
points=points+ones(s(1),1)*offset;

%% Keeping only points inside !
in_space=true(s(1),1);
for i=1:3
    in_space=in_space.*(points(:,i)<=sizes(i));
    in_space=in_space.*(points(:,i)>0);
end
points=points(logical(in_space),:);
nw=sum(~in_space);
if nw>0
    if options.verbose
        disp([num2str(nw) ' points discarded when making image from points. Consider changing scaling'])
    end
end

%% Generating an image from these points
img=generate_image(sizes,points,fluo,bkgd,mode,datatype);

end