% same as diffopn, but averages, i.e., computes values on the edges of the grid. If you want to compute the values
% in the cell centers, use avgopn instead.
% supports only forward and backward.
function [result,resultbound] = avgsopn(dims, components, schemes, boundaries)

    %%%% General Case %%%%

    schm = {};
    if (strcmp(class(schemes),'char'))
        for i = 1:numel(dims)
            schm{i} = schemes;
        end
    else
        schm = schemes; % assume cell array with different scheme for each direction
    end
    
    bound = {};
    if (strcmp(class(boundaries),'char'))
        for i = 1:numel(dims)
            bound{i} = boundaries;
        end
    elseif (strcmp(class(boundaries),'cell') && (numel(boundaries) == 1))
        for i = 1:numel(dims)
            bound{i} = boundaries{1};
        end
    else
        bound = boundaries; % assume cell array with different scheme for each direction
    end
    
    if (numel(schm) ~= numel(dims))
        error('invalid number of schemes');
    end
    if (numel(bound) ~= numel(dims))
        error('invalid number of boundary conditions');
    end

    for j = 1:numel(dims)
		diffops{j} = @(n)(avgsop(n,schm{i},bound{i}));
	end
	
	[result,resultbound] = opn(dims, components, diffops);   
end
