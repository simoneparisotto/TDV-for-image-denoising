% does NOT scale color values if autoscale not supplied or false
function display_multichannel(vdisplay, channels, autoscale)
    if (nargin < 2)
        M = size(vdisplay,ndims(vdisplay));
    else
%		disp(class(channels));
%		disp(channels);
        if (strcmp(class(channels),'struct'))
            [dims,imgdims,N,nimgdims,M] = get_dimensions(size(vdisplay),channels); % hack for compatibility with TVlib
        elseif (isnumeric(channels))
            M = channels;
        else
            error('invalid specification of channel count');
        end
    end
    
    if (nargin < 3)
        autoscale = false;
    end
    
    if (M == 2)
        vdisplay(:,:,3) = 0;
    end
    if (M == 4)
        vdisplay(:,:,4) = []; % Throw away 4th basis vector (=> corresponds to "black")
    end
    if (M > 4)
        error('Cannot display images with more than 4 channels');
    end
    if (M == 1)
        if (~autoscale)
            im = image(max(0,min(255,uint16(vdisplay * 256)))); % correct
        else
            im = imagesc(vdisplay);
        end
        c =  (0:(1/255):1)' * [1 1 1];
        colormap(c);
        %set(im,'CDataScaling','direct');
    else
        if (~autoscale)
            image(max(0,min(1,vdisplay)));
        else
            vmin = min(vdisplay(:));
            vmax = max(vdisplay(:));
            divisor = vmax - vmin;
            if (divisor <= 0)
                divisor = 1;
            end
            image((vdisplay-vmin)./divisor);
        end
    end
end
