function h = figureq(oh)

    if (nargin==0) || (~ishandle(oh))
        oh=figure;
    end
    set(0,'currentfigure',oh);
    if nargout
        h=oh;
    end 

end
