function [dims,imgdims,N,L,M] = get_dimensions(dimf, params)
%GET_DIMENSIONS Splits dimensions of f. Returns image dimensions (imgdims),
%  numer of pixels (N), number of models (M) and number of image
%  dimensions(L)
    dims = getparameter(params,'dimensions',dimf);
    
    if (nargout > 1)
        imgdims = dims(1:end-1);
    end
    if (nargout > 2)
        N = prod(imgdims);  % # of pixels
    end
    if (nargout > 3)
        L = numel(imgdims); % # of image dimensions
    end
    if (nargout > 4)
        M = dims(end);      % # of models
    end
end
