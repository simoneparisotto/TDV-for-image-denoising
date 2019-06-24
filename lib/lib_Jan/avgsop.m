% creates 1-dimensional sparse average operator matrix for
% vectors with length n
% boundaries can be a string or a cell array of 2 strings for left and
% right boundary conditions
% normbnd is optional returns an upper bound for the operator's norm if
% available (and +inf if not).
% NOTE: A grid spacing of _2_ is assumed!
function [result,resultbound] = avgsop(n, scheme, boundaries)
    result = [];
    normbound = +inf;
    
    if (n < 1)
        error('n must be positive');
    end
    
    if (strcmp(class(boundaries),'char'))                                 % check for 'cond'
        boundaries = {boundaries,boundaries};
    elseif (strcmp(class(boundaries),'cell') && (numel(boundaries) == 1)) % check for {'cond'}
        boundaries = {boundaries{1},boundaries{1}};
    elseif (~strcmp(class(boundaries),'cell') || ~(numel(boundaries) == 2))
        % does not check class of cell array elements
        error('invalid boundary condition specification - must be string or 2-element cell array of strings');
    end
    
    if (strcmp(scheme,'forward'))
        if (strcmp(boundaries(2),'neumann'))
            result = spdiags([0.5*ones(n-1,1) 0.5*ones(n-1,1); 1 0.5],0:1,n,n);
        elseif (strcmp(boundaries(2),'dirichlet'))
            result = spdiags([0.5*ones(n,1) 0.5*ones(n,1)],0:1,n,n);
        elseif (strcmp(boundaries(2),'periodic'))
            result = spdiags([0.5*ones(n,1) 0.5*ones(n,1)],0:1,n,n);
            result(n,1) = result(n,1) + 0.5; % sum catches the extreme case n = 1
            normbound = 2;
        else
            error('unsupported boundary condition for this scheme');
        end
    elseif (strcmp(scheme,'backward'))
        if (strcmp(boundaries(1),'neumann'))
            result = spdiags([0.5 1; 0.5*ones(n-1,1) 0.5*ones(n-1,1)],-1:0,n,n);
            normbound = 2;
        elseif (strcmp(boundaries(1),'dirichlet'))
            result = spdiags([0.5*ones(n,1) 0.5*ones(n,1)],-1:0,n,n);
            normbound = 2;
        elseif (strcmp(boundaries(1),'periodic'))
            result = spdiags([0.5*ones(n,1) 0.5*ones(n,1)],-1:0,n,n);
            result(1,n) = result(1,n) + 0.5; % sum catches the extreme case n = 1
            normbound = 2;
        else
            error('unsupported boundary condition for this scheme');
        end
    else
        error('unsupported scheme');
    end    
    
    if (nargout > 1)
        resultbound = normbound;
    end
end
