function divv = div(v,D1,D2)

% THIS IS -div

M = size(v,1);
N = size(v,2);

DIV = @(v) reshape(...
                D1.'*reshape(v(:,:,1),M*N,1) + D2.'*reshape(v(:,:,2),M*N,1),...
                M,N);

divv = DIV(v);

return