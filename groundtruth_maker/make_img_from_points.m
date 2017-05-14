function [img,points]=make_img_from_points(input,options)
% Generates an image from a list of points

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

fluo=options.signal;
bkgd=options.background;
mode=options.fluorophore;
sizes=options.image_size;
offset=options.offset;
scaling=options.scaling;

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

if isempty(scaling)
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
    scaling=(max(scales)*1.5);
end
points=points/scaling;


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
img=generate_image(sizes,points,fluo,bkgd,mode);

end