% creates n-dimensional difference operator for vector-valued functions
% schemes may be a string or a cell array of numel(dims) strings
% boundaries may be a string, cell array of numel(dims) strings, or a cell
% array of cell arrays with 2 strings each
% resultbound is optional and gets assigned an estimate of operator norm
% (spectral norm)
% TODO extend schemes & boundaries to be adjustable for all components separately (and
% automatically extended if not specified) -> schemes should be a cell matrix
function [result,resultbound] = diffopn(dims, components, schemes, boundaries)

    %%%% Centered Differences -- reduce to averaging of forward differences %%%%

    if (strcmp(schemes,'centered'))
        if (~strcmp(boundaries,'none'))
            error('Centered differences require ''none'' boundary conditions.');            
        end
        
        result = avgopn(dims,components) * diffopn(dims, components, 'forward', 'neumann');
        %{
        op = sparse(prod(dims)*numel(dims)*components, prod(dims)*components);
        for i = 0:(2^numel(dims)-1)
            ibin = dec2bin(i,numel(dims));
            ischemes = {};
            for j = 1:numel(dims)
                if (ibin(j) == '0')
                    ischemes{j} = 'forward';
                else
                    ischemes{j} = 'backward';
                end
            end
            op = op + diffopn(dims, components, ischemes, 'neumann');
        end
        result = op ./ (2^numel(dims)); % average
        %}
        resultbound = +inf; % bounds not yet supported
        return;
    end

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

    diffops = {};
    for j = 1:numel(dims)
		diffops{j} = @(n)(diffop(n,schm{j},bound{j}));
    end
	
	[result,resultbound] = opn(dims, components, diffops);   
end
