function h = image_drawrect( brect, spec, msg, hAxes )

% draw <brect> = [ x_min, y_min, x_max, y_max ] on the current image
%
%

if nargin < 2
    spec = 'g-';
end
if nargin < 4
    hAxes = gca;
end

lx = brect(1);
ly = brect(2);
ux = brect(3);
uy = brect(4);

if nargin > 2
    h(1) = text(ly, ux, [' ',msg], 'Color', spec(1), 'FontSize', 12,...
        'VerticalAlignment', 'bottom', 'Parent', hAxes);
    h(2) = plot(hAxes, [ ly, ly, uy, uy, ly ], [ lx, ux, ux, lx, lx ], spec);
else
    h = plot(hAxes, [ ly, ly, uy, uy, ly ], [ lx, ux, ux, lx, lx ], spec);
end


