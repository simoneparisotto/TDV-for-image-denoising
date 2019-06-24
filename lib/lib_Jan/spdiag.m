% SPDIAG creates a sparse blockdiagonal matrix
%   S = SPDIAG(A1,A2,...,An) returns a block-diagonal matrix S with the
%   rectangular matrices A1,..,An on the main diagonal. If Ai is a vector,
%   then instead a diagonal matrix of Ai is used.
function S = spdiag(varargin)
n = 0;
m = 0;
i = [];
j = [];
v = [];
for k = 1:nargin
    A = varargin{k};
    [nk,mk] = size(A);

    [ik,jk,vk] = find(A);
    if (nk == 1)
        % A is a row vector -> make diagonal matrix
        nk = mk;
        ik = jk;
    elseif (mk == 1)
        % A is a column vector -> make diagonal matrix
        mk = nk;
        jk = ik;
    else
        % A is a matrix
    end;

    ik = ik + n;
    jk = jk + m;
    if (numel(ik) > 0)
        i = [i; ik];
        j = [j; jk];
        v = [v; vk];
    end;
    n = n + nk;
    m = m + mk;
end;
S = sparse(i,j,v,n,m,numel(v));

