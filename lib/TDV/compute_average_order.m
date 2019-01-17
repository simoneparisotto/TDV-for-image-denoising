function AA = compute_average_order(M,N)

%% B is the matrix for averaging to bring the derivative in the cell centres
% averaging over i, (u_{i,j} + u_{i+1,j})/2
%B{1} = (toeplitz(sparse(1,1,1/2,1,M*N),sparse(1,2,1/2,1,M*N)));
%B{1} = 0.5*spdiags([ones(M*N,1) ones(M*N,1)],[0 1],M*N,M*N);
%B{1}(end,[end-1,end]) = [0.5 0.5];
% averaging over j, (u_{i,j} + u_{i,j+1})/2
%B{2} = (toeplitz(sparse(1,1,1/2,1,M*N),sparse(1,M+1,1/2,1,M*N))); 
%B{2} = 0.5*spdiags([ones(M*N,1) ones(M*N,1)],[0 M],M*N,M*N);
%B{2}(end-M+1:end,:) = B{2}(end-2*M+1:end-M,:);
% averaging over j diagonally left to right, (u_{i,j} + u_{i-1,j+1})/2
%B{3} = (toeplitz(sparse(1,1,1/2,1,M*N),sparse(1,M,1/2,1,M*N))); 
B{3} = 0.5*spdiags([ones(M*N,1) ones(M*N,1)],[0 M-1],M*N,M*N);
%B{3}(1,:) = 0; B{3}(1,[1,M+1]) = 0.5;
%B{3}(end-M+1:end,:) = 0;
% averaging over i diagonally right to left, (u_{i+1,j-1} + u_{i,j+1})/2
%B{4} = (toeplitz(sparse(1,1,1/2,1,M*N),sparse(1,M,1/2,1,M*N))).'; 
B{4} = B{3}.';
%B{4}(end,:) = 0;

%% NEW METHOD


% averaging over i plus, (u_{i,j} + u_{i+1,j})/2
B1plus                  = 0.5*spdiags([ones(M,1) ones(M,1)],[0 1],M,M);
B1plus(end,[end-1 end]) = [0.5 0.5];
B{1}                    = kron(speye(N),B1plus);

% % averaging over i minus, (u_{i,j} + u_{i-1,j})/2
% B1minus          = 0.5*spdiags([ones(M,1) ones(M,1)],[-1 0],M,M);
% B1minus(1,[1 2]) = [0.5 0.5];
% B{2}             = kron(speye(N),B1minus);
% 
% averaging over j plus, (u_{i,j} + u_{i,j+1})/2
B2plus                  = 0.5*spdiags([ones(N,1) ones(N,1)],[0 1],N,N);
B2plus(end,[end-1 end]) = [0.5 0.5];
B{2}                    = kron(B2plus,speye(M));
% 
% % averaging over j minus, (u_{i,j} + u_{i,j-1})/2
% B2minus            = 0.5*spdiags([ones(N,1) ones(N,1)],[-1 0],N,N);
% B2minus(1,[1 2]) = [0.5 0.5];
% B{4}               = kron(B2minus,speye(M));
% 
% B_extra_M     =  spdiags([ones(M,1)],[0],M,M);
% B_extra_N     =  spdiags([ones(N,1)],[0],N,N);
% 
% Ep{1} = kron(speye(N),Bplus_extra_M);
% Ep{2} = kron(Bplus_extra_N,speye(M));
% Em{1} = kron(speye(N),Bminus_extra_M);
% Em{2} = kron(Bminus_extra_N,speye(M));

% % averaging for D11
% B{5} = B{4}.'*B{2};
% 
% % averaging for D22
% B{6} = B{3}.'*B{1};


%% R,L we need to delete rows and columns; R for rows L for columns
% (1:end-3,2:end-2)
r1                  = ones(M,N); 
r1(end-2:end,:)     = 0; 
r1                  = find(r1(:));
l1                  = ones(M-3,N); 
l1(:,[1 end-1:end]) = 0; 
l1                  = find(l1(:));

% (2:end-2,1:end-3)
r2                  = ones(M,N); 
r2([1 end-1:end],:) = 0; 
r2                  = find(r2(:));
l2                  = ones(M-3,N); 
l2(:,[end-2:end])   = 0; 
l2                  = find(l2(:));

% (2:end-1,2:end-1)
r3                  = ones(M,N); 
r3([1 end],:)       = 0; 
r3                  = find(r3(:));
l3                  = ones(M-2,N); 
l3(:,[1 end])       = 0; 
l3                  = find(l3(:));

% (2:end-2,2:end-2)
r4                    = ones(M,N); 
r4([1 end-1 end],:) = 0; 
r4                    = find(r4(:));
l4                    = ones(M-3,N); 
l4(:,[1 end-1 end]) = 0; 
l4                    = find(l4(:));



R{1} = spdiags(ones(M*N,1),0,M*N,M*N);             R{1} = R{1}(r1,:);
L{1} = spdiags(ones((M-3)*N,1),0,(M-3)*N,(M-3)*N); L{1} = L{1}(:,l1);

R{2} = spdiags(ones(M*N,1),0,M*N,M*N);             R{2} = R{2}(r2,:);
L{2} = spdiags(ones((M-3)*N,1),0,(M-3)*N,(M-3)*N); L{2} = L{2}(:,l2);

R{3} = spdiags(ones(M*N,1),0,M*N,M*N);             R{3} = R{3}(r3,:);
L{3} = spdiags(ones((M-2)*N,1),0,(M-2)*N,(M-2)*N); L{3} = L{3}(:,l3);

R{4} = spdiags(ones(M*N,1),0,M*N,M*N);             R{4} = R{4}(r4,:);
L{4} = spdiags(ones((M-3)*N,1),0,(M-3)*N,(M-3)*N); L{4} = L{4}(:,l4);


%% 1 DERIVATIVES
% % no
AA{1}{1} = L{4}.'*R{4}*B{2}; % average along J for D1
AA{1}{2} = L{4}.'*R{4}*B{1}; % average along I for D2

%% 2 DERIVATIVES
AA{2}{1} = L{1}.'*R{1}*B{3}; % average for D11
AA{2}{2} = L{4}.'*R{4};      % THEY ARE ALREADY ON THE CELL CENTRE
AA{2}{3} = L{4}.'*R{4};      % THEY ARE ALREADY ON THE CELL CENTRE
AA{2}{4} = L{2}.'*R{2}*B{4}; % average for D22

%% 3 DERIVATIVES
% this works
AA{3}{1} = L{1}.'*R{1}*B{2};
AA{3}{2} = L{1}.'*R{1}*B{1};
AA{3}{3} = L{2}.'*R{2}*B{2};
AA{3}{4} = L{2}.'*R{2}*B{2};
AA{3}{5} = L{1}.'*R{1}*B{1};
AA{3}{6} = L{2}.'*R{2}*B{1};
% AA{3}{1} = L{1}.'*R{1}*B{3};
% AA{3}{2} = L{1}.'*R{1}*B{1};
% AA{3}{3} = L{2}.'*R{2}*B{3};
% AA{3}{4} = L{2}.'*R{2}*B{3};
% AA{3}{5} = L{1}.'*R{1}*B{1};
% AA{3}{6} = L{2}.'*R{2}*B{1};



% % averaging for v
% C{1} = L{3}.'*R{3}*B{1};
% C{2} = L{3}.'*R{3}*B{2};