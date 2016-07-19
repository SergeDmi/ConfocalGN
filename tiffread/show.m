function hImage = show(im, varargin)

% function hImage = show ( im, varargin )
%
% shows the image, allowing mouse control of brightness / contrast
% clicking with right button gives an local autoscale
% dragging with right button adjust the contrast (horizontal) and brightness (vertical)
%
% This adds a pixel-info display to  show_image(im)
%
% F. Nedelec, nedelec@embl-heidelberg.de  last modified Nov 2012

[hImage, pixels] = show_image(im, varargin{:}, 'Name', inputname(1));

mDown  = 0;
downC  = [];
downP  = [ 0, 0 ];
altKey = 0; % true is alt-key is down
spcKey = 0; % true is space bar is down
cLim   = image_auto_colors(pixels);
hFig   = gcf;
hAxes  = gca;
zoomF  = 1;
focusP = [ mean(xlim), mean(ylim) ];

%set(hFig, 'DoubleBuffer','on');

hText = text('Parent', hAxes, 'Units', 'Pixels', 'Position', [2 2],...
    'VerticalAlignment', 'Bottom', 'HorizontalAlignment', 'left',...
    'FontName', 'FixedWidth', 'Color', 'blue',...
    'String', sprintf('colors = [ %i, %i ] ', cLim(1), cLim(2) ) );


set(hFig, 'WindowButtonDownFcn',   {@mouse_down});
set(hFig, 'WindowButtonUpFcn',     {@mouse_up});
set(hFig, 'WindowButtonMotionFcn', {@mouse_motion});
set(hFig, 'WindowScrollWheelFcn',  {@mouse_wheel});
set(hFig, 'KeyPressFcn',           {@key_down});
set(hFig, 'KeyReleaseFcn',         {@key_up});

drawnow;


%% Callback functions

    function m = current_point()
        P = get(hAxes, 'CurrentPoint');
        m = P(1,1:2);
    end


    function mouse_down(hObject, eventData)
        downP = current_point;
        downC = cLim;
        mDown = 1;
    end


    function mouse_up(hObject, eventData)
        m = current_point;
        if all( m == downP ) && altKey
            % a point right-click : local autoscale
            m = round(m);
            adjust_color(image_crop(pixels, [m(2)-8 m(1)-8 m(2)+8 m(1)+8]));
        end
        mDown = 0;
    end


    function mouse_wheel(hObject, eventData)
        m = current_point;
        z = zoomF;
        if eventData.VerticalScrollCount > 0
            if ( zoomF < 100 )
                zoomF = zoomF * 1.1;
            end
        elseif eventData.VerticalScrollCount < 0
            if ( zoomF > 1 )
                zoomF = zoomF / 1.1;
            end
        end
        focusP = ((zoomF-z)*m + z*focusP)/zoomF;
        adjust_view(focusP, zoomF);
    end


    function mouse_motion(hObject, eventData)
        if spcKey
            focusP = focusP + downP - current_point;
            %fprintf('focus <- %f %f\n', focusP(1), focusP(2));
            adjust_view(focusP, zoomF);
        elseif mDown
            if altKey
                % modify contrast / brightness
                chg = double(current_point - downP) ./ [diff(xlim) diff(ylim)];
                dc = chg * double(downC(2)-downC(1));
                cMin = max(0, downC(1)-dc(2)+dc(1));
                cMax = max(0, downC(2)-dc(2)-dc(1));
                adjust_color([cMin, cMax]);
            else
            end
        else
            report_pixel(current_point);
        end
    end
 

    function key_down(hObject, eventData)
        if strcmp(eventData.Key, 'alt')
            altKey = 1;
        elseif eventData.Character == ' '
            downP = current_point;
            spcKey = 1;
        elseif eventData.Character == 'z'
            adjust_color(auto_contrast(pixels));
            reset_view;
        end
    end

    function key_up(hObject, eventData)
        if strcmp(eventData.Key, 'alt')
            altKey = 0;
        elseif eventData.Character == ' '
            spcKey = 0;
        end
    end

%% Accessory functions

    function report_pixel(P)
        %range = [0 -1 +1 -2 +2];
        range = [0];
        ii = max(1, min(size(pixels,1), round(P(2))+range ));
        jj = max(1, min(size(pixels,2), round(P(1))+range ));
        avg = mean(mean( pixels(ii, jj) ));
        set(hText, 'string', sprintf('pixel (%4i, %4i)= %.0f ', ii, jj, avg));
    end


    function adjust_view(p, z)
        w = 0.5 * ( size(pixels, 2) - 1 ) / z;
        h = 0.5 * ( size(pixels, 1) - 1 ) / z;
        roi = [p(1)-w, p(1)+w, p(2)-h, p(2)+h];
        axis(hAxes, roi);
        refresh(hFig);
    end


    function reset_view()
        roi = [1, size(pixels,2), 1, size(pixels,1)];
        axis(hAxes, roi);
        focusP = [ mean(roi(1:2)), mean(roi(3:4)) ];
        zoomF  = 1;
    end


    function res = scale_pixels(pixels, range)
        scale  = 1.0 / double( range(2) - range(1) );
        res = ( double(pixels) - range(1) ) .* scale;
        sel = logical( res < 0 );
        res(sel) = 0;
        sel = logical( res > 1 );
        res(sel) = 1;
    end


    function adjust_color(data)
        mn = double(min(data(:)));
        mx = double(max(data(:)));
        if  mx > mn
            cLim = [ mn mx ];
            set(hImage, 'cdata', scale_pixels(pixels, cLim));
            set(hText, 'string', sprintf('colors=[ %.2f, %.2f ]', mn, mx));
        end
    end


    function range = auto_contrast(im)
        % match bottom/top ~1% of pixel values
        for d = 1 : size(im,3)
            range(d,1) = double( min(min(im(:,:,d))) );
            range(d,2) = double( max(max(im(:,:,d))) );
            
            hs = cumsum(image_histogram(im(:,:,d)));
            ss = hs(length(hs));
            
            cB = find(hs>ss*0.01, 1, 'first');
            cT = find(hs<ss*0.995, 1, 'last');
            
            if cB < cT
                range(d,1) = cB;
                range(d,2) = cT;
            end
        end
    end


end