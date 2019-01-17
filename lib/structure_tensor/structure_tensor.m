function [V,b] = structure_tensor(umat,sigma,rho,D1,D2,params,location)

umat = padarray(umat,[1 1],'replicate','both');

filter    = @(sigma) compute_gaussian_filter([2*ceil(2*sigma)+1,2*ceil(2*sigma)+1],sigma,size(umat));
blur      = @(f,sigma) imfilter(f,filter(sigma));
blur      = @(f,sigma)  imgaussfilt(f,sigma,'padding','replicate','FilterDomain','frequency');
nabla     = @(f)grad(f,D1,D2);
tensorize = @(u)cat(3, u(:,:,1).^2, u(:,:,2).^2, u(:,:,1).*u(:,:,2));
rotate    = @(T)cat(3, T(:,:,2), T(:,:,1), -T(:,:,3));
T         = @(f,sigma) blur( tensorize( nabla(f) ), sigma);
delta     = @(S)(S(:,:,1)-S(:,:,2)).^2 + 4*S(:,:,3).^2;
eigenval  = @(S)deal( ...
    (S(:,:,1)+S(:,:,2)+sqrt(delta(S)))/2,  ...
    (S(:,:,1)+S(:,:,2)-sqrt(delta(S)))/2 );
normalize = @(u)u./repmat(sqrt(sum(u.^2,3)), [1 1 2]);
eig1      = @(S)normalize( cat(3,2*S(:,:,3), S(:,:,2)-S(:,:,1)+sqrt(delta(S)) ) );
ortho     = @(u)deal(u, cat(3,-u(:,:,2), u(:,:,1)));
eigbasis  = @(S)ortho(eig1(S));

% K_sigma * u
u = blur(umat,sigma);

% K_rho * (\grad u_sigma \otimes u_sigma)
S = T(u,sigma);
S(:,:,1) = blur(S(:,:,1),rho);
S(:,:,2) = blur(S(:,:,2),rho);
S(:,:,3) = blur(S(:,:,3),rho);

[lambda1,lambda2] = eigenval(S);
[e1,e2] = eigbasis(S);

V = cat(3,-e1(:,:,2),e1(:,:,1));

E = sqrt(lambda1+lambda2);
A = (lambda1-lambda2)./(lambda1+lambda2);

% MOVE evertthing on cell centres from grid edge
V = cat(3,interpn(location.ii_u1_extra,location.jj_u1_extra,V(:,:,1),location.ii_v,location.jj_v,'linear',0),...
          interpn(location.ii_u2_extra,location.jj_u2_extra,V(:,:,2),location.ii_v,location.jj_v,'linear',0));

lambda1 = cat(3,interpn(location.ii_u_extra,location.jj_u_extra,lambda1,location.ii_v,location.jj_v,'linear',0));
E = cat(3,interpn(location.ii_u_extra,location.jj_u_extra,E,location.ii_v,location.jj_v,'linear',0));
A = cat(3,interpn(location.ii_u_extra,location.jj_u_extra,A,location.ii_v,location.jj_v,'linear',0));


if ~isnan(params.regularize) && params.regularize~=0
    
    % normalize orientation
    switch params.caseweight
        case 1
            weights = mat2gray(lambda1(:));
        case 2
            weights = 1-round(10000*A)/10000;
    end
    
    bc = 'neumann';
    gff = diffopn(size(u)-3,2,{'forward','forward'},bc);
    gbf = diffopn(size(u)-3,2,{'backward','forward'},bc);
    gfb = diffopn(size(u)-3,2,{'forward','backward'},bc);
    gbb = diffopn(size(u)-3,2,{'backward','backward'},bc);
    
    laplace = 0.25 * (gff' * gff + gbf' * gbf + gfb' * gfb + gbb' * gbb);
    
    % (L +
    % Dw IS THE DIAGONAL MATRIX WITH weights on diagonal.. first component,
    % second component for v which is double component
    Dw = (1.0 / params.gamma_regularize) * spdiag([weights(:); weights(:)]);
    
    V = reshape((laplace + Dw) \ (Dw * V(:)), [size(V,1) size(V,2) 2]);
end

switch params.bvary
    case 0
        bb = [params.b(2)];
    case 1
        bb = 1-round(10000*A)/10000;
        bb = min(mat2gray(bb),params.c);
    otherwise
        bb = params.b(2);
end

b = cat(3,params.b(1)*ones(size(bb)),bb);
end