% Returns u reshaped as 1 x n vector
function r = flatten(u,dir)
    if dir == 1
        r = u(:);
    else
        r = reshape(u,1,numel(u));
    end
end
