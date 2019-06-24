% Author: Jan Lellmann, j.lellmann@damtp.cam.ac.uk
% Date: 28/11/2012

% Creates an operator that averages a vector field in the cell
% centers along the specified dimensions.
% The output will be (dim1-1)x...x(dimN-1), therefore no boundary
% conditions are required.
% Requires each dimension to be at least length 2 (otherwise cell centers
% are not defined).
function [result,resultbound] = avgopn(dims, components)
    eyes = {};
    for i = 1:numel(dims)
        eyes{i} = [speye(dims(i)-1,dims(i)-1), zeros(dims(i)-1,1)];
    end

    result = sparse(prod(dims-1)*numel(dims),prod(dims)*numel(dims));
    
    for k = 1:numel(dims)
        rk = sparse(prod(dims-1),prod(dims));
        for i = 1:numel(dims)
            m = sparse([1]);
            for j = 1:numel(dims)
                if ((j == i) && (j ~= k))
                    f = spdiags([zeros(dims(i)-1,1) ones(dims(i)-1,1)],0:1,dims(i)-1,dims(i));
                    m = kron(f, m); % order is MATLAB array memory layout (->reshape) specific
                else
                    m = kron(eyes{j},m); % order is MATLAB array memory layout (->reshape) specific
                end
            end
            rk = rk + m; % bound for m (!) is now bounds(i) (kron(id,...) does not change norm)
        end

        result((1+(k-1)*prod(dims-1)):(k*prod(dims-1)),...
               (1+(k-1)*prod(dims)):(k*prod(dims))) = rk;
    end   
    
    result = result ./ numel(dims);
    
    result = kron(speye(components),result);
end
