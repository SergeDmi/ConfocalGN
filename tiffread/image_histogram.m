function h = image_histogram( im, mask, plot_name )

% h = image_histogram( im, mask )
% h = image_histogram( im, mask, plot_name )
%
% calculate the histogram of the given image, optionally restricted on the mask
% h(1) is the number of pixels of value 0, etc.
% F. Nedelec, Dec. 2007

%%compatibility with tiffread:
if ( isfield(im,'data') ) 
    im = double( im.data ); 
end

if nargin < 3
    plot_name = 0;
end

if min(min(im)) < 0
    warning('image_histogram:data', 'Negative pixel values were ignored');
end

%%
if nargin < 2 || isempty(mask)
    
    val = reshape(real(im), numel(im), 1);
    max_val = max(val);
    h = histc(val, 0:max_val);
    %h = sum( histc( im, 0:max_val ), 2);
    
else

    if any( size(im) ~= size(mask) )
        error('Image and mask must be have the same size');
    end
    if min(reshape(mask, numel(mask), 1 )) < 0 
        error('Values of the mask should be non-negative');
    end
    if max(reshape(mask, numel(mask), 1 )) > 1
        error('Values of the mask should be lower or equal to 1');
    end

    imm = im .* mask - ( 1-mask );
    val = reshape( imm, numel(imm), 1 );
    max_val = ceil(max(val));
    
    h = histc(val, 0:max_val);
    
end

%% Make a figure to display the histogram
if plot_name
 
    x = (0:size(h)-1)';
    figure('Name', plot_name, 'Position', [100 150 800 300]);
    axes('Position', [0.05 0.1 0.9 0.8] );
    xlim([0 size(h,1)]);    
    plot(x, h, 'b.', 'MarkerSize',1);
    title('Histogram of pixel values');

end



end
