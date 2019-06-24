% Author: Jan Lellmann, j.lellmann@damtp.cam.ac.uk
% Date: 28/11/2012

% creates 1-dimensional sparse difference operator matrix for
% vectors with length n
% boundaries can be a string or a cell array of 2 strings for left and
% right boundary conditions
% normbnd is optional returns an upper bound for the operator's norm if
% available (and +inf if not).
% NOTE: A grid spacing of _2_ is assumed!
function [result,resultbound] = diffop(n, scheme, boundaries)
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
        %TODO improve estimate for neumann & dirichlet conditions (can
        %probably be computed explicitly)
        %TODO look up proof for this (experimentally verified using svd(...); for periodic conditions:
        %2.0 is exactly reached.
        if (strcmp(boundaries(2),'neumann'))
            result = spdiags([-ones(n-1,1) ones(n-1,1); 0 1],0:1,n,n);            
            normbound = 2;
        elseif (strcmp(boundaries(2),'dirichlet'))
            result = spdiags([-ones(n,1) ones(n,1)],0:1,n,n);
            normbound = 2;
        elseif (strcmp(boundaries(2),'periodic'))
            result = spdiags([-ones(n,1) ones(n,1)],0:1,n,n);
            result(n,1) = result(n,1) + 1; % sum catches the extreme case n = 1
            normbound = 2;
        elseif (strcmp(boundaries(2),'second-order'))
            result = spdiags([-ones(n-1,1) ones(n-1,1); 0 1],0:1,n,n);            
            result(end,:) = result(end-1,:);
            normbound = +inf; % not implemented yet
        elseif (strcmp(boundaries(2),'third-order'))
            result = spdiags([-ones(n-1,1) ones(n-1,1); 0 1],0:1,n,n);            
            result(end,end-2:end) = [1 -3 2];
            normbound = +inf; % not implemented yet
        else
            error('unsupported boundary condition for this scheme');
        end            
    elseif (strcmp(scheme,'backward'))
        if (strcmp(boundaries(1),'neumann'))
            result = spdiags([-1 0; -ones(n-1,1) ones(n-1,1)],-1:0,n,n);
            normbound = 2;
        elseif (strcmp(boundaries(1),'dirichlet'))
            result = spdiags([-ones(n,1) ones(n,1)],-1:0,n,n);
            normbound = 2;
        elseif (strcmp(boundaries(1),'periodic'))
            result = spdiags([-ones(n,1) ones(n,1)],-1:0,n,n);
            result(1,n) = result(1,n) - 1; % sum catches the extreme case n = 1
            normbound = 2;
        elseif (strcmp(boundaries(1),'second-order'))
            result = spdiags([-1 0; -ones(n-1,1) ones(n-1,1)],-1:0,n,n);
            result(1,:) = result(2,:);
            normbound = +inf; % not implemented yet            
        elseif (strcmp(boundaries(1),'third-order'))
            result = spdiags([-1 0; -ones(n-1,1) ones(n-1,1)],-1:0,n,n);
            result(1,1:3) = [-2 3 -1];
            normbound = +inf; % not implemented yet            
        else
            error('unsupported boundary condition for this scheme');
        end
        
    elseif (strcmp(scheme,'central'))

        result = spdiags([-ones(n,1),zeros(n,1),ones(n,1)],-1:1,n,n);
        
        if (strcmp(boundaries(1),'neumann'))
            result(1,:) = 0;
        elseif (strcmp(boundaries(1),'dirichlet'))
            % keep as is
        elseif (strcmp(boundaries(1),'periodic'))
            result(1,end) = -1;
        elseif (strcmp(boundaries(1),'second-order'))
            result(1,:) = result(2,:);
        elseif (strcmp(boundaries(2),'third-order'))
            result(1,1:4) = [-2 1 2 -1];
        else
            error('unsupported boundary condition for this scheme');
        end
        
        if (strcmp(boundaries(2),'neumann'))
            result(end,:) = 0;
        elseif (strcmp(boundaries(2),'dirichlet'))
            % keep as is
        elseif (strcmp(boundaries(2),'periodic'))
            result(end,1) = 1;
        elseif (strcmp(boundaries(2),'second-order'))
            result(end,:) = result(end-1,:);
        elseif (strcmp(boundaries(2),'third-order'))
            result(end,end-3:end) = [1 -2 -1 2];
        else
            error('unsupported boundary condition for this scheme');
        end
            
        %elseif (strcmp(boundary,'dirichlet'))
        %    result = spdiags([-ones(n,1),zeros(n,1),ones(n,1)],-1:1,n,n);
        %elseif (strcmp(boundary,'periodic'))
        %    result = spdiags([-ones(n,1),zeros(n,1),ones(n,1)],-1:1,n,n);
        %    result(1,n) = result(1,n) - 1; % works also for n = 1
        %    result(n,1) = result(n,1) + 1;
        %else
        %    error('unsupported boundary condition for this scheme');
        %end
		
		result = result ./ 2.0; % account for double grid step
    else
        error('unsupported scheme');
    end    
    
    if (nargout > 1)
        resultbound = normbound;
    end
end

%UNTITLED1 Summary of this function goes here
%   Detailed explanation goes here
