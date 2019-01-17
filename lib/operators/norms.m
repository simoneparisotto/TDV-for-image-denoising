function y = norms(z,p,dir)

switch p
    case 1
        y = sum(abs(z),dir);
    case 'Inf'
        y = max(z(:));
    otherwise
        y = sum(z.^p,dir).^(1/p);
end

return