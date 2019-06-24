% Author: Jan Lellmann, j.lellmann@damtp.cam.ac.uk
% Date: 28/11/2012

function [result,resultbound] = opn(dims, components, operators)
    % prepare identity matrices
    
    eyes = {};
    for i = 1:numel(dims)
        eyes{i} = speye(dims(i),dims(i));
    end
    
    % construct difference matrix for one component

    bounds = [];
    result = sparse([]);
    for i = 1:numel(dims)
        m = sparse([1]);
        for j = 1:numel(dims)
            if (j == i)
                [f,b] = operators{i}(dims(i)); %SLOW could spare computation of bound if not required
                m = kron(f, m); % order is MATLAB array memory layout (->reshape) specific
                bounds(i) = b;
            else
                m = kron(eyes{j},m); % order is MATLAB array memory layout (->reshape) specific
            end
        end
        result = [result; m]; % bound for m (!) is now bounds(i) (kron(id,...) does not change norm)
    end
    
    % extend to all components
    
    result = kron(speye(components),result);
    
    % give upper bound on operator norm (spectral norm)
    % the matrices for the individual i are stacked one above the other, so
    % ||result * x|| = sqrt(sum_i(||m_i * x||)^2) <=
    % sqrt(sum_i((||m_i||*||x||)^2)) <= ||x||*sqrt(sum_i(||m_i||^2))
    % = ||x|| * ||bounds||.
    %
    % The operator norm does NOT change when extending the operator to all
    % components (independently!)
    
    if (nargout > 1)
        resultbound = norm(bounds,2); % this correctly handles the case where some bounds are +inf
    end
end
