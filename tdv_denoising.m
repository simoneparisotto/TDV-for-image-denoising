%% (Higher-order) Total directional variation for image denoising
%
% [u, v, time, varargout] = tdv_denoising(unoise,params,varargin)
%
% Input:
% unoise       = noisy image
% params       = parameters from get_parameters
% varargin{1}  = ground truth image
%
% Output:
% u            = denoised image
% v            = vector field
% time         = cpu time elapsed
% varargout{1} = PSNR (if varargin{1} = unoise)
%
% Companion software to
% Simone Parisotto, Simon Masnou and Carola-Bibiane Schoenlieb.
% "(Higher-order) Total directional variation. Part I: Imaging Application"
% ArXiv: https://arxiv.org/abs/1812.05023
%
% Authors:
% 1) Simone Parisotto          (email: sp751 at cam dot ac dot uk)
% 2) Jan Lellmann              (email: jan lellmann at mic dot uni-luebeck dot de)
% 3) Simon Masnou              (email: masnou at math dot univ-lyon1 dot fr)
% 4) Carola-Bibiane Schoenlieb (email: cbs31 at cam dot ac dot uk)
%
% Address of Authors 1) and 4):
% Cambridge Image Analysis
% Centre for Mathematical Sciences
% Wilberforce Road
% CB3 0WA, Cambridge, United Kingdom
%  
% Date:
% January, 2019
%
% Licence: BSD-3-Clause (https://opensource.org/licenses/BSD-3-Clause)
%

function [u, v, TDVtime, varargout] = tdv_denoising(unoise,params,varargin)

% measure time
TDVtime = cputime;

% size of the image
u = unoise;
[m,n,c] = size(u);

% check if a clean image is available
flag_psnr = 0;
if nargin==3
    uorig = varargin{1};
    flag_psnr = 1;
else
    uorig = NaN(m,n,c);
end

% CREATE STAGGERED GRIDS for vector fields
location = get_location(m,n);

% COMPUTE GRADIENT OPERATOR
u = padarray(u,[1 1,0],'replicate','both');
params.boundary_u = 'end';
[D1,D2] = gradmat(u,params.boundary_u);

% STORE ORIGINAL CORRUPTERD IMAGE
xnoise = u;

% CREATE A STACK OF SIGMAs AND RHOs FOR THE MULTIPLE TEST OPTION, if any
switch params.update_v_iter
    case 1
        sigma_stack = params.sigma;
        rho_stack   = params.rho;
    otherwise
        stack       = @(r,params) (r(end)-r(1))*max( (0:params.update_v_iter-1)./(params.update_v_iter-1), 0) + r(1);
        sigma_stack = stack([params.sigma(1),params.sigma(2)],params);
        rho_stack   = stack([params.rho(1),params.rho(2)],params);
end

%% START ALGORITHM

for ii = 1:params.update_v_iter % iterates the procedure, if you wish
    
    %% COMPUTE THE VECTOR FIELD v
    switch params.compute_field
        case 'v1'
            sigma = params.sigma;
            rho   = params.rho;
            v = structure_tensor(uorig,sigma,rho,D1,D2,params,location);      % from ground truth image
        case 'v2'
            sigma = sigma_stack(ii);
            rho   = rho_stack(ii);
            if size(u,3)>1
                [v, params.b] = structure_tensor(rgb2gray(u(2:end-1,2:end-1,:)),sigma,rho,D1,D2,params,location);
            else
                [v, params.b] = structure_tensor(u(2:end-1,2:end-1,:),sigma,rho,D1,D2,params,location);
            end
    end
    
    
    %% COMPUTE THE DERIVATIVE OPERATOR OF ORDER Q FOR EACH Q, WEIGHTED BY M
    % compute averaging operators to match derivatives on cell centres
    B  = compute_average_order(m+2,n+2); % move D^Q on cell centres
    Be = speye((m+2)*(n+2),(m+2)*(n+2)); % keep on D^k u position at k-th derivative
    Br = speye((m-1)*(n-1),(m-1)*(n-1)); % keep on cell centres
    % NB the transfer operator to move the derivative of v back to
    % cell centres is not yet implemented
    
    %% BUILD STANDARD MATRICES and MCAL for each order
    [LR,I]  = build_M(v,params.b);
    Mcal{1} = {LR};
    Mcal{2} = {I,LR};
    Mcal{3} = {I,I,LR};
    
    %% BUILD Wcal (transfer operator) for each order
    Wcal{1} = {B{1}};
    Wcal{2} = {{Be,Be},B{2}};
    Wcal{3} = {{Be,Be},{Be,Be,Be,Be},B{3}};
    
    Kcal{1} = MD(u,Mcal{1},Wcal{1},D1,D2,location);
    Kcal{2} = MD(u,Mcal{2},Wcal{2},D1,D2,location);
    Kcal{3} = MD(u,Mcal{3},Wcal{3},D1,D2,location);
    
    %% COMPUTE SADDLE-POINT OPERATORS AND PROX
    % F:= (lamdba/eta)*TDV  is the vectorial soft thresholding.
    K         = @(u,params) Ku(Kcal,u,params);
    KS        = @(y,q)      divMq(y,Mcal{q},Wcal{q},D1,D2,location);
    ProxFS    = @(y,sigma,params) y./max(1,repmat(norms(y,2,3)./params.lambda,1,1,size(y,3)));
    
    % G = 0.5*eta*|| u - u^\diamond||_2^2
    ProxG     = @(x,u,tau)( x+tau*params.eta*u )/( 1+tau*params.eta );
    
    options.niter  = params.maxiter;
    
    %% PRIMAL-DUAL SCHEME
    for kk = 1:size(u,3)
        if flag_psnr
            u(:,:,kk) = perform_primal_dual(xnoise(:,:,kk), params, K, KS, ProxFS, ProxG, options,uorig(:,:,kk));
        else
            u(:,:,kk) = perform_primal_dual(xnoise(:,:,kk), params, K, KS, ProxFS, ProxG, options);
        end
    end
    
    if flag_psnr
        psnr_local = psnr(uorig,u(2:end-1,2:end-1,:));
    end                  
    
end

% return values
if flag_psnr
    varargout{1} = psnr_local(end);
end
u    = u(2:end-1,2:end-1,:);

TDVtime = cputime-TDVtime;

end

function x = perform_primal_dual(x, params, K, KS, ProxFS, ProxG, options,varargin)
% perform_primal_dual - primal-dual algorithm
%
%    [x,R] = perform_admm(x, K,  KS, ProxFS, ProxG, options);
%
%   Solves
%       min_x F(K*x) + G(x)
%   where F and G are convex proper functions with an easy to compute proximal operator,
%   and where K is a linear operator
%
%   Uses the Preconditioned Alternating direction method of multiplier (ADMM) method described in
%       Antonin Chambolle, Thomas Pock,
%       A first-order primal-dual algorithm for convex problems with applications to imaging,
%       Preprint CMAP-685
%
%   INPUTS:
%   ProxFS(y,sigma) computes Prox_{sigma*F^*}(y)
%   ProxG(x,tau) computes Prox_{tau*G}(x)
%   K(y) is a linear operator.
%   KS(y) compute K^*(y) the dual linear operator.
%   options.sigma and options.tau are the parameters of the
%       method, they shoudl satisfy sigma*tau*norm(K)^2<1
%   options.theta=1 for the ADMM, but can be set in [0,1].
%   options.verb=0 suppress display of progression.
%   options.niter is the number of iterations.
%   options.report(x) is a function to fill in R.
%
%   OUTPUTS:
%   x is the final solution.
%   R(i) = options.report(x) at iteration i.
%
%   Copyright (c) 2010 Gabriel Peyre

options.null = 0;
niter  = getoptions(options, 'niter', 100);
theta  = getoptions(options, 'theta', 1);

%%%% ADMM parameters %%%%
sigma = getoptions(options, 'sigma', -1);
tau   = getoptions(options, 'tau', -1);

% INITIALIZATION
if nargin == 8
    xorig = varargin{1};
    psnr_local = zeros(niter,1);
end

if sigma<0 || tau<0
    rr = randn(size(x));
end

Q = numel(params.lambda{:});
index_Q = find(params.lambda{1});

paramslocal = cell(Q,1);
xstar       = cell(Q,1);
y           = cell(Q,1);
Lq          = cell(Q,1);

for q=index_Q
    
    paramslocal{q}        = params;
    paramslocal{q}.order  = params.order(q);
    paramslocal{q}.lambda = params.lambda{1}(q);
    
    xstar{q} = 0;
    y{q}     = 0;
    Lq{q}    = 0;
    
    if sigma<0 || tau<0
        Lq{q} = compute_operator_norm(@(x) KS(K(x,paramslocal{q}),q),rr);
        y{q}  = K(x,paramslocal{q});
    end
    
end

% OPERATOR NORM
L = max(cat(1,Lq{index_Q}));
%L = max([8.^find(params.lambda{1})]);

if params.acceleration
    
    %  ADMM
    tau   = 1/sqrt(L);
    sigma = 1./(tau*L);
    %gamma = 0.5;
    gamma = 0.35*params.eta;
    
else
    sigma = 10;
    tau   = 0.9/(sigma*L);
end

if params.verbose_text
    fprintf('\n  ITER  |   PSNR  \n');
    fprintf('--------------------\n');
end

xhat   = x;
xnoise = x;

for iter = 1:niter
    
    xold = x;
    
    % DUAL PROBLEM
    for q=index_Q
        y{q}     = ProxFS( y{q} + sigma*K(xhat,paramslocal{q}), sigma, paramslocal{q});
        xstar{q} = KS(y{q},q);
    end
    
    % PRIMAL PROBLEM
    x = ProxG(  x-tau*sum(cat(3,xstar{index_Q}),3), xnoise, tau);
    
    % EXTRAPOLATION
    xhat = x + theta * (x-xold);
    
    % ACCELERATION
    if params.acceleration
        theta = 1./sqrt(1+2*gamma*tau);
        tau   = theta*tau;
        sigma = sigma/theta;
    end
    
    if nargin == 8
        psnr_local(iter) = psnr(xorig,x(2:end-1,2:end-1));     
        if params.verbose_text && ~mod(iter,20)
            fprintf('   %02d   |  %2.2f  \n',iter,psnr_local(iter))
        end
    else
        fprintf('Denoising in progress...')
    end
    
end

if nargin<8
    fprintf(' done!\n')
end

end

function [L,e] = compute_operator_norm(A,n)
% compute_operator_norm - compute operator norm
%
%   [L,e] = compute_operator_norm(A,n);
%
%   Copyright (c) 2010 Gabriel Peyre

if length(n)==1
    u = randn(n,1); u = u/norm(u);
else
    u = n;
    u = u/norm(u);
end
e = [];
for i=1:30
    v = A(u);
    e(end+1) = sum(u(:).*v(:));
    u = v/norm(v(:));
end
L = e(end);
end

function v = getoptions(options, name, v, mendatory)
% getoptions - retrieve options parameter
%
%   v = getoptions(options, 'entry', v0);
% is equivalent to the code:
%   if isfield(options, 'entry')
%       v = options.entry;
%   else
%       v = v0;
%   end
%
%   Copyright (c) 2007 Gabriel Peyre

if nargin<4
    mendatory = 0;
end

if isfield(options, name)
    v = eval(['options.' name ';']);
elseif mendatory
    error(['You have to provide options.' name '.']);
end
end