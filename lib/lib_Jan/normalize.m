% Normalizes u along the columns with norm p (returns row vector).
% If  |u| <= thresh, 0 is returned (this mimicks the sign function).
% Not optimized for speed yet.
function result = normalize(u, p, thresh)
    if (nargin < 3)
        thresh = 0.0;
    end
    if (nargin < 2)
        p = 2;
    end

    ns = norms(u, p, 1);
    fact = zeros(size(ns));
    fact(ns > thresh) = 1./ns(ns > thresh); % all others are zero
    result = u .* fact(ones(1,size(u,1)),:);
end
