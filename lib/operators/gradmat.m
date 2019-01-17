function [D1,D2] = gradmat(u,boundary)

M = size(u,1);
N = size(u,2);

D1 = spdiags([-ones(M,1) ones(M,1)],[0 1],M,M);
D2 = spdiags([-ones(N,1) ones(N,1)],[0 1],N,N);

switch boundary
    case 'all'
        D1([1 M],:) = 0;
        D2([1 N],:) = 0;
    case 'end'
        D1([M],:) = 0;
        D2([N],:) = 0;
     case 'end2'
        D1([M],[end-1,end]) = [-1 1];
        D2([N],[end-1,end]) = [-1 1];
    case 'none'
end

D1 = kron(speye(N),D1);
D2 = kron(D2,speye(M));

return