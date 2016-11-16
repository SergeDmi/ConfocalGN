function range = image_auto_colors(im)

% F. Nedelec, August 2010
% automatically calculates color-range
% match bottom/top ~1% of pixel values


if size(im,2) == 1

    range = zeros(length(im), 2);

    for i = 1:length(im)
        range(i,:) = auto_contrast(im(i).data);
    end
    
else
    
    range = auto_contrast(im);

end


    function range = auto_contrast(data)
        
        for d = 1 : size(data,3)
        
            pix = data(:,:,d);
            range(d,1) = double( min(pix(:)) );
            range(d,2) = double( max(pix(:)) );
            
            hs = cumsum(image_histogram(pix));
            
            if ~isempty(hs)
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


end



