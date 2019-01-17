function [LR,I] = build_M(v,b)

[m,n,c] = size(v); 

% CONTRACTION on cell centres
B      = {b(:,:,1),b(:,:,2)}; % ellipse shape
L      = cat(3,B{1}.*ones(m,n),zeros(m,n),zeros(m,n),B{2}.*ones(m,n));

% ROTATION on cell centres
RT      = cat(3,v(:,:,1),v(:,:,2),-v(:,:,2),v(:,:,1));

LR  = cat(3,L(:,:,1).*RT(:,:,1) + L(:,:,2).*RT(:,:,3),...
            L(:,:,1).*RT(:,:,2) + L(:,:,2).*RT(:,:,4),...
            L(:,:,3).*RT(:,:,1) + L(:,:,4).*RT(:,:,3),...
            L(:,:,3).*RT(:,:,2) + L(:,:,4).*RT(:,:,4));
        
% IDENTITY on grid verteces
I     = cat(3,ones(m+3,n+3),zeros(m+3,n+3),zeros(m+3,n+3),ones(m+3,n+3));
