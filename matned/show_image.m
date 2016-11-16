function [ hImage, pixels ] = show_image( im, varargin )

% function [ hImage, pixels ] = show_image ( im, ... )
%
% Display picture "im" in 16-bit gray levels.
% - The image is displayed in a new figure, unless a handle to a figure, axes,
%   or to an image object is provided, in which case the image is displayed
%   in these axes/figure/image.
% - The color range is set automatically, unless it is specified as [ c_min, c_max ]
% - The image is displayed so as to fit in the screen, unless a magnification
%   is specified as ( 'Magnification', value )
%
% Color images can be specified as cells with 'red', 'green' and 'blue' components,
% or as a single matrix im(1:h, 1:w, 1:3) containing the red, green and blue
% panels of size h=heigth x w=width.
%
% show_image(...) returns a handle to the matlab image object, the
% magnification, and the scaled pixel values. The handle can be returned in
% a subsequent call to change the displayed image.
%
% F. Nedelec, 2004-2008. This version November 9, 2012


if nargin < 1 || isempty(im)
    error('Missing or empty image argument');
end

if isfield(im, 'image_name')
    opt.Name = im(1).image_name;
elseif isfield(im, 'filename')
    opt.Name = im(1).filename;
else
    opt.Name = inputname(1);
end


%% parse input

parser = inputParser;
parser.addParamValue('Name',   opt.Name);
parser.addParamValue('Index',          1, @isnumeric);
parser.addParamValue('IndexedColors',  0, @isnumeric);
parser.addParamValue('Ticks',          0, @isnumeric);
parser.addParamValue('Highlight',      0, @isnumeric);
parser.addParamValue('Resizable',      1, @isnumeric);
parser.addParamValue('ResizeAxes',     0, @isnumeric);
parser.addParamValue('Magnification', [], @isnumeric);
parser.addParamValue('ColorRange',    [], @isnumeric);
parser.addParamValue('Handle',        [], @ishandle);

parser.parse(varargin{:});

opt = parser.Results;

%% Check handles

hFig    = [];
hImage  = [];
hAxes   = [];

hType = get(opt.Handle, 'Type');
if isempty(hType)
    
elseif strcmp(hType, 'axes')
    hAxes = opt.Handle;
    hFig  = get(hAxes, 'Parent');
    %try to find the image in the children
    h = findobj(hAxes, 'Type', 'image');
    if ~isempty(h)
        if length(h) > 1
            disp('using first image handle found in the axes');
        end
        hImage = h(1);
    end
    opt.Resizable = 0;
elseif strcmp(hType, 'figure')
    hFig = opt.Handle;
    h = findobj(get(hFig, 'Children'), 'Type', 'axes');
    if ~isempty(h)
        hAxes = h(1);
    end
elseif strcmp(hType, 'image')
    hImage  = opt.Handle;
    hAxes   = get(hImage, 'Parent');
    hFig    = get(hAxes, 'Parent');
    opt.Resizable = 0;
else
    error('unknown Handle type');
end


%% Extract pixels

pixels = image_get_pixels(im, opt.Index);

imsz = size(pixels);

if any( imsz < 2 )
    error('the image is too small to be displayed');
end

%% Adjust color range for display


if isempty(opt.ColorRange)
    
    opt.ColorRange = image_auto_colors(pixels);

elseif numel(opt.ColorRange) == 1
    
    clim = image_auto_colors(pixels);
    opt.ColorRange(1,2) = clim(2);
    
elseif all( size(opt.ColorRange) == [ 1 2 ] )
    
    % use the provided color range for all components of the image:
    for d = 2 : size(pixels,3)
        opt.ColorRange(d,1:2) = opt.ColorRange(1,1:2);
    end
    
end

opt.FigureName = sprintf('%s [%.2f, %.2f]', opt.Name, opt.ColorRange(1), opt.ColorRange(2));

%% Calculate magnification

    function mag = best_zoom(imsz)
        %make the figure as large as possible in the screen
        scrn = get(0,'ScreenSize');
        mag  = min( (scrn([4,3]) - [128 20]) ./ imsz(1:2) );
        if mag > 1 ;  mag = floor(mag);      end
        if mag > 5 ;  mag = 5;               end
        if mag < 1 ;  mag = 1 / ceil(1/mag); end
    end

if  isempty(opt.Magnification)
    opt.Magnification = best_zoom(imsz);
    %fprintf('size %i %i : zoom %f \n', imsz(1), imsz(2), opt.Magnification);
else
    opt.Resizable = 0;
end

%% Make figure

if isempty( hFig )
    scrn = get(0,'ScreenSize');
    pos  = [ 10, scrn(4)-opt.Magnification*imsz(1)-60,  opt.Magnification*imsz(2),  opt.Magnification*imsz(1) ];
    hFig = figure('Position', pos, 'MenuBar', 'None', 'Units', 'pixels');
else
    set(0, 'CurrentFigure', hFig);
end

% use file name to set figure name:
set(hFig, 'Name', opt.FigureName);

%% Make axes

if isempty( hAxes )
    
    %make axes in the center of the figure, with the appropriate size:
    fpos = get(hFig, 'Position');
    apos = [ 1 + fix( 0.5*( fpos([3,4]) - opt.Magnification*imsz([2,1]) ) ) opt.Magnification*imsz([2,1]) ];
    hAxes = axes('Units', 'Pixels', 'Position', apos);

elseif opt.ResizeAxes
    
    set(hAxes, 'Units', 'Pixels');
    pos = get(hAxes, 'Position');
    set(hAxes, 'Position', [ pos(0:1), opt.Magnification*imsz([2,1]) ]);
    
end

%flip the image up/down to display it correctly
set(hAxes, 'YDir','reverse', 'View', [0 90] );
%fix axes: disable the auto-resize, and adjust the range
set(hAxes, 'DataAspectRatio',[1 1 1], 'PlotBoxAspectRatio', [opt.Magnification opt.Magnification 1]);
set(hAxes, 'XLimMode', 'manual', 'XLim', [1 imsz(2)]);
set(hAxes, 'YLimMode', 'manual', 'YLim', [1 imsz(1)]);

if opt.Ticks
    set(hAxes, 'xtick', 0:100:imsz(2) );
    set(hAxes, 'ytick', 0:100:imsz(1) );
    set(hAxes, 'XColor', 'y', 'YColor', 'y');
else
    set(hAxes, 'Visible','off');
end

hold(hAxes, 'on');

%% Display image

    function res = scale_pixels(pixels, range)
        scale  = 1.0 / double( range(2) - range(1) );
        res = ( double(pixels) - range(1) ) .* scale;
        sel = logical( res < 0 );
        res(sel) = 0;
        sel = logical( res > 1 );
        res(sel) = 1;
    end

if opt.IndexedColors
    
    scale  = double( 2^16-1 ) / ( opt.ColorRange(2)-opt.ColorRange(1) );
    scaled = 1+( double(pixels) - opt.ColorRange(1) ) * scale;
    if isempty( hImage )
        hImage = image('Parent', hAxes, 'CData', scaled);
        cmap = gray( 2^16 );
        colormap( cmap );
    else
        set(hImage, 'cdata', scaled);
    end
    
else
    
    scaled = zeros(size(pixels));
    for d = 1 : size(pixels,3)
        scaled(:,:,d) = scale_pixels( pixels(:,:,d), opt.ColorRange(d,:) );
    end
    if isempty( hImage )
        hImage = image('Parent', hAxes, 'CData', scaled, 'CDataMapping', 'scaled');
        colormap( gray );
        set(hAxes, 'CLim', [0, 1]);
    else
        set(hImage, 'CData', scaled, 'CDataMapping', 'scaled');
    end
    
end

%% highlight high-value pixels

if  opt.Highlight > 0
    %set the background color to yellow:
    set(hFig, 'Color', [1 1 0]);
    %make sat==1 for pixels above hightlight:
    sat = ( pixels >=  opt.Highlight );
    %make these pixels fully transparent, to show the background color
    set(hImage, 'AlphaData', 1-sat, 'AlphaDataMapping', 'none');
    fprintf('Highlighted %i pixels above %i\n', sum(sum(sat)),  opt.Highlight );
end



%% Store information in the UserData

    function resize_callback(hObject, eventData)
        h = get(hFig, 'Children');
        %do not resize if image contains GUI elements
        if isempty(findobj(h, 'Type', 'uipanel'))
            %keep the image in top-left corner if the figure is resized
            fpos = get(hFig, 'Position');
            mag  = min(fpos(3)/imsz(2), fpos(4)/imsz(1));
            %fprintf('resize %i %i : zoom %f \n', fpos(3), fpos(4), mag);
            apos = [ 1, 1+fpos(4)-mag*imsz(1), mag*imsz(2), mag*imsz(1) ];
            set(hAxes, 'Units', 'Pixels', 'Position', apos);
            opt.Magnification = mag;
        end
    end


if opt.Resizable
    set(hFig, 'ResizeFcn', {@resize_callback});
else
    set(hFig, 'Resize', 'off');
end


end


