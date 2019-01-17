function DU = grad(u,D1,D2)

M = size(u,1);
N = size(u,2);
	
DU(:,:,1) = reshape(D1*u(:),M,N);
DU(:,:,2) = reshape(D2*u(:),M,N);

return