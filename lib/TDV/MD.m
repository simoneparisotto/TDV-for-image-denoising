function Z = MD(u,M,B,D1,D2,location)

Q = numel(M);
[m,n,c]=size(u);

switch Q
    case 0
        % u
        Z = u;
    case 1
        % MD
        [Z{1},Z{2}] = basicMD(M{1},B{1}{1}*D1,B{1}{2}*D2,size(M{1},1),size(M{1},2));
        
    case 2
     
        % MD
        [MD{1},MD{2}] = basicMD(M{1},B{1}{1}*D1,B{1}{2}*D2,size(M{1},1),size(M{1},2));
        
        % MD_MD
        [Z{1}{1},Z{2}{1}] =  basicMD(M{2},B{2}{1}*D1*MD{1},B{2}{2}*D2*MD{1},size(M{2},1),size(M{2},2));
        [Z{1}{2},Z{2}{2}] =  basicMD(M{2},B{2}{3}*D1*MD{2},B{2}{4}*D2*MD{2},size(M{2},1),size(M{2},2));
        
    case 3   
        
        % MD
        [MD{1},MD{2}]    = basicMD(M{1},B{1}{1}*D1,B{1}{1}*D2,size(M{1},1),size(M{1},2));
        
        % MD_MD
        [MD_MD{1}{1},MD_MD{2}{1}] = basicMD(M{2},B{2}{1}*D1*MD{1},B{2}{2}*D2*MD{1},size(M{2},1),size(M{2},2));
        [MD_MD{1}{2},MD_MD{2}{2}] = basicMD(M{2},B{2}{3}*D1*MD{2},B{2}{4}*D2*MD{2},size(M{2},1),size(M{2},2));

        % MD_MD_MD
        [Z{1}{1}{1},Z{2}{1}{1}] = basicMD(M{3},B{3}{1}*D1*MD_MD{1}{1},B{3}{5}*D2*MD_MD{1}{1},size(M{3},1),size(M{3},2));
        [Z{1}{1}{2},Z{2}{1}{2}] = basicMD(M{3},B{3}{2}*D1*MD_MD{1}{2},B{3}{3}*D2*MD_MD{1}{2},size(M{3},1),size(M{3},2));
        [Z{1}{2}{1},Z{2}{2}{1}] = basicMD(M{3},B{3}{2}*D1*MD_MD{2}{1},B{3}{3}*D2*MD_MD{2}{1},size(M{3},1),size(M{3},2));
        [Z{1}{2}{2},Z{2}{2}{2}] = basicMD(M{3},B{3}{3}*D1*MD_MD{2}{2},B{3}{6}*D2*MD_MD{2}{2},size(M{3},1),size(M{3},2));
end

return

function [MD1, MD2] = basicMD(M,D1,D2,m,n)
C{1}{1} = spdiags(flatten(M(:,:,1),1),0,m*n,m*n);
C{1}{2} = spdiags(flatten(M(:,:,2),1),0,m*n,m*n);
C{2}{1} = spdiags(flatten(M(:,:,3),1),0,m*n,m*n);
C{2}{2} = spdiags(flatten(M(:,:,4),1),0,m*n,m*n);

MD1 = C{1}{1}*D1 + C{1}{2}*D2;
MD2 = C{2}{1}*D1 + C{2}{2}*D2;
return

% function Z = MD(u,M,B,D1,D2,location)
% 
% Q = numel(M);
% [m,n,c]=size(u);
% 
% switch Q
%     case 0
%         % u
%         w = u;
%     case 1
%         % MD
%         Z = basicMD(M{1},D1,D2,m,n);
%         
%     case 2
%         % MD1
%         MD1 = basicMD(M{1},D1,D2,m,n);
%         % MD2
%         MD2 = basicMD(M{2},D1,D2,m,n);
% 
%         % MD \otimes MD
%         Z{1}{1} = MD2{1}*MD1{1};
%         Z{1}{2} = MD2{1}*MD1{2};
%         Z{2}{1} = MD2{2}*MD1{1};
%         Z{2}{2} = MD2{2}*MD1{2};
%         
%     case 3
%         % MD1
%         MD1 = basicMD(M{1},D1,D2,m,n);
%         % MD2
%         MD2 = basicMD(M{2},D1,D2,m,n);
%         % MD3
%         MD3 = basicMD(M{3},D1,D2,m,n);
% 
%         % MD \otimes MD
%         MDMD{1}{1} = MD2{1}*MD1{1};
%         MDMD{1}{2} = MD2{1}*MD1{2};
%         MDMD{2}{1} = MD2{2}*MD1{1};
%         MDMD{2}{2} = MD2{2}*MD1{2};
%         
%         % MD \otimes MD \otimes MD
%         Z{1}{1}{1} = MD3{1}*MDMD{1}{1};
%         Z{1}{1}{2} = MD3{1}*MDMD{1}{2};
%         Z{1}{2}{1} = MD3{1}*MDMD{2}{1};
%         Z{1}{2}{2} = MD3{1}*MDMD{2}{2};
%         Z{2}{1}{1} = MD3{2}*MDMD{1}{1};
%         Z{2}{1}{2} = MD3{2}*MDMD{1}{2};
%         Z{2}{2}{1} = MD3{2}*MDMD{2}{1};
%         Z{2}{2}{2} = MD3{2}*MDMD{2}{2};
% end
% 
% return
% 
% function MD = basicMD(M,D1,D2,m,n)
% C{1}{1} = spdiags(flatten(M(:,:,1),1),0,m*n,m*n);
% C{1}{2} = spdiags(flatten(M(:,:,2),1),0,m*n,m*n);
% C{2}{1} = spdiags(flatten(M(:,:,3),1),0,m*n,m*n);
% C{2}{2} = spdiags(flatten(M(:,:,4),1),0,m*n,m*n);
% 
% MD{1} = C{1}{1}*D1 + C{1}{2}*D2;
% MD{2} = C{2}{1}*D1 + C{2}{2}*D2;
% return