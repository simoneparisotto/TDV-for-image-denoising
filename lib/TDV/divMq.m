function w = divMq(z,M,B,D1,D2,location)

Q = numel(M);

switch Q
    case 3
        
        www1 = divM(z(:,:,[1,5]),M{3},B{3}{1}*D1,B{3}{5}*D2,location);
        www2 = divM(z(:,:,[2,6]),M{3},B{3}{2}*D1,B{3}{3}*D2,location);
        www3 = divM(z(:,:,[3,7]),M{3},B{3}{2}*D1,B{3}{3}*D2,location);
        www4 = divM(z(:,:,[4,8]),M{3},B{3}{3}*D1,B{3}{6}*D2,location);
        e3   = numel(www1)~=numel(z(:,:,1));  
        www  = reshape(cat(2,www1,www2,www3,www4),size(M{3},1)+3*e3,size(M{3},2)+3*e3,4); 
        
        ww1 = divM(www(:,:,[1,2]),M{2},B{2}{1}*D1,B{2}{2}*D2,location);
        ww2 = divM(www(:,:,[3,4]),M{2},B{2}{3}*D1,B{2}{4}*D2,location);
        e2  = numel(ww1)~=numel(www(:,:,1));      
        ww  = reshape(cat(2,ww1,ww2),size(M{2},1)+3*e2,size(M{2},2)+3*e2,2);
        
        w1  = divM(ww,M{1},B{1}{1}*D1,B{1}{2}*D2,location);   
        e1  = numel(w1)~=numel(ww(:,:,1)); 
        w   = reshape(w1,size(M{1},1)+3*e1,size(M{1},2)+3*e1);
        
        
        
    case 2
        
        ww1 = divM(z(:,:,[1,2]),M{2},B{2}{1}*D1,B{2}{2}*D2,location);
        ww2 = divM(z(:,:,[3,4]),M{2},B{2}{3}*D1,B{2}{4}*D2,location);
        e2  = numel(ww1)~=numel(z(:,:,1));      
        ww  = reshape(cat(2,ww1,ww2),size(M{2},1)+3*e2,size(M{2},2)+3*e2,2);
        
        w1  = divM(ww,M{1},B{1}{1}*D1,B{1}{2}*D2,location);   
        e1  = numel(w1)~=numel(ww(:,:,1)); 
        w   = reshape(w1,size(M{1},1)+3*e1,size(M{1},2)+3*e1);
        
        
    case 1
        w1   = divM(z,M{1},B{1}{1}*D1,B{1}{2}*D2,location);
        e1  = numel(w1)~=numel(z(:,:,1)); 
        w   = reshape(w1,size(M{1},1)+3*e1,size(M{1},2)+3*e1);
end


return

function divM = divM(y,M,D1,D2,location)
    
    z1 = D1.'*flatten(M(:,:,1).*y(:,:,1) + M(:,:,3).*y(:,:,2),1);
    z2 = D2.'*flatten(M(:,:,2).*y(:,:,1) + M(:,:,4).*y(:,:,2),1);
    
    divM = (z1 + z2);
    
return


% function w = divMq(z,M,B,D1,D2,location)
% 
% Q = numel(M);
% 
% switch Q
%     case 3
%         w11 = divM(cat(3,z(:,:,[1 5])),M{3},B,D1,D2,location);
%         w12 = divM(cat(3,z(:,:,[2 6])),M{3},B,D1,D2,location);
%         w21 = divM(cat(3,z(:,:,[3 7])),M{3},B,D1,D2,location);
%         w22 = divM(cat(3,z(:,:,[4 8])),M{3},B,D1,D2,location);
%         
%         w11 = interpn(location.ii_u_extra,location.jj_u_extra,w11,location.ii_v,location.jj_v,'linear',0);
%         w12 = interpn(location.ii_u_extra,location.jj_u_extra,w12,location.ii_v,location.jj_v,'linear',0);
%         w21 = interpn(location.ii_u_extra,location.jj_u_extra,w21,location.ii_v,location.jj_v,'linear',0);
%         w22 = interpn(location.ii_u_extra,location.jj_u_extra,w22,location.ii_v,location.jj_v,'linear',0);
%         
%         w1  = divM(cat(3,w11,w12), M{2},B,D1,D2,location);
%         w2  = divM(cat(3,w21,w22), M{2},B,D1,D2,location);
%         
%         w1 = interpn(location.ii_u_extra,location.jj_u_extra,w1,location.ii_v,location.jj_v,'linear',0);
%         w2 = interpn(location.ii_u_extra,location.jj_u_extra,w2,location.ii_v,location.jj_v,'linear',0);
%        
%         w   = divM(cat(3,w1,w2),   M{1},B,D1,D2,location);
%         
%     case 2
%         w1  = divM(z(:,:,1,:),M{2},B,D1,D2,location);
%         w2  = divM(z(:,:,2,:),M{2},B,D1,D2,location);
%         w   = divM(cat(w1,w2), M{1},B,D1,D2,location);      
%     case 1
%         w   = divM(z,M{1},B,D1,D2,location);
% end
% 
% return
% 
% function divM = divM(y,M,B,D1,D2,location)
%     
%     %y1 = interpn(location.ii_v,location.jj_u_extra,y(:,:,1),location.ii_v,location.jj_v,'linear',0);
%     %y2 = interpn(location.ii_v_extra,location.jj_u_extra,y(:,:,2),location.ii_v,location.jj_v,'linear',0);
% 
%     z1 = reshape(D1.'*B{1}.'*flatten(M(:,:,1).*y(:,:,1) + M(:,:,3).*y(:,:,2),1),size(M,1)+3,size(M,2)+3);
%     z2 = reshape(D2.'*B{2}.'*flatten(M(:,:,2).*y(:,:,1) + M(:,:,4).*y(:,:,2),1),size(M,1)+3,size(M,2)+3);
%     
%     divM = (z1 + z2);
%     
% return







% 
% q = numel(size(y))-2;
% 
% divM = zeros(size(y,1),size(y,2),q);
% 
% M = reshape(M,[size(M,1),size(M,2),2,2]);
% 
% switch q
%     case 1
%         y1 = interpn(location.ii_u_extra,location.jj_u_extra,y(:,:,1),location.ii_v,location.jj_v,'linear',0);
%         y2 = interpn(location.ii_u_extra,location.jj_u_extra,y(:,:,2),location.ii_v,location.jj_v,'linear',0);
%         z1 = D1.'*B{1}.'*flatten(M(:,:,1,1).*y1 + M(:,:,2,1).*y2,1);
%         z2 = D2.'*B{2}.'*flatten(M(:,:,1,2).*y1 + M(:,:,2,2).*y2,1);
%         
%         divM = -reshape( z1 + z2, size(y,1),size(y,2) );
%            
%     case 2
%         
%         % get the correct index expression
%         basic_ex = ':,:';
%         basic_at = '';
%         for i=1:q-2
%             var{i}       = ['i',num2str(i)]; 
%             store_var{i} = ['i',num2str(i),'=[1,2]']; 
%             basic_at     = [basic_at,'i',num2str(i),','];
%             basic_ex     = [basic_ex,',i',num2str(i)];
%         end
%         basic_ex = ['y(',basic_ex,',k,j)'];
%         basic_ex_interp = ['@(k,j) interpn(location.ii_u_extra,location.jj_u_extra,',basic_ex,',location.ii_v,location.jj_v,''linear'',0)'];
%         Y = eval(basic_ex_interp);
%         
%         y11 = flatten( M(:,:,1,1).*Y(1,1) + M(:,:,2,1).*Y(2,1),1 );
%         y12 = flatten( M(:,:,1,1).*Y(1,2) + M(:,:,2,1).*Y(2,2),1 );
%         y21 = flatten( M(:,:,1,2).*Y(1,1) + M(:,:,2,2).*Y(2,1),1 );
%         y22 = flatten( M(:,:,1,2).*Y(1,2) + M(:,:,2,2).*Y(2,2),1 );
%         
%         divM(:,:,1:2) = -( cat(3,...
%             reshape( D1.'*B{1}.'*y11 + D2.'*B{2}.'*y12, size(y,1),size(y,2) ),...
%             reshape( D1.'*B{1}.'*y21 + D2.'*B{2}.'*y22, size(y,1),size(y,2) ) ) );
%         
%       case 3
%         
%         % get the correct index expression
%         basic_ex = ':,:';
%         basic_at = '';
%         for i=1:q-2
%             var{i}       = ['i',num2str(i)]; 
%             store_var{i} = ['i',num2str(i),'=[1,2]']; 
%             basic_at     = [basic_at,'i',num2str(i),','];
%             basic_ex     = [basic_ex,',i',num2str(i)];
%         end
%         %basic_ex = ['@(',basic_at,'k,j)',' y(',basic_ex,',k,j)'];
%         %Y = eval(basic_ex);
%         basic_ex = ['y(',basic_ex,',k,j)'];
%         basic_ex_interp = ['@(',basic_at,'k,j) interpn(location.ii_u_extra,location.jj_u_extra,',basic_ex,',location.ii_v,location.jj_v,''linear'',0)'];
%         Y = eval(basic_ex_interp);
%         
%         for i1= [1,2]
%             y11 = flatten( M(:,:,1,1).*Y(i1,1,1) + M(:,:,2,1).*Y(i1,2,1),1 );
%             y12 = flatten( M(:,:,1,1).*Y(i1,1,2) + M(:,:,2,1).*Y(i1,2,2),1 );
%             y21 = flatten( M(:,:,1,2).*Y(i1,1,1) + M(:,:,2,2).*Y(i1,2,1),1 );
%             y22 = flatten( M(:,:,1,2).*Y(i1,1,2) + M(:,:,2,2).*Y(i1,2,2),1 );
%                   
%             divM(:,:,i1,1:2) = -( cat(3,...
%                 reshape( D1.'*B{1}.'*y11 + D2.'*B{2}.'*y12, size(y,1),size(y,2) ),...
%                 reshape( D1.'*B{1}.'*y21 + D2.'*B{2}.'*y22, size(y,1),size(y,2) ) ) );
%         
%         end
%         
%         
% %     case 4
% %         
% %         % get the correct index expression
% %         basic_ex = ':,:';
% %         basic_at = '';
% %         for i=1:q-2
% %             var{i}       = ['i',num2str(i)]; 
% %             store_var{i} = ['i',num2str(i),'=[1,2]']; 
% %             basic_at     = [basic_at,'i',num2str(i),','];
% %             basic_ex     = [basic_ex,',i',num2str(i)];
% %         end
% %         basic_ex = ['@(',basic_at,'k,j)',' y(',basic_ex,',k,j)'];
% %         Y = eval(basic_ex);
% %         
% %         for i1=[1,2]
% %             for i2=[1,2]
% %                 yhat11(:,:,i2,i1) = FFT2( M(:,:,1,1).*Y(i2,i1,1,1) + M(:,:,2,1).*Y(i2,i1,2,1));
% %                 yhat12(:,:,i2,i1) = FFT2( M(:,:,1,1).*Y(i2,i1,1,2) + M(:,:,2,1).*Y(i2,i1,2,2));
% %                 yhat21(:,:,i2,i1) = FFT2( M(:,:,1,2).*Y(i2,i1,1,1) + M(:,:,2,2).*Y(i2,i1,2,1));
% %                 yhat22(:,:,i2,i1) = FFT2( M(:,:,1,2).*Y(i2,i1,1,2) + M(:,:,2,2).*Y(i2,i1,2,2));
% %                 
% %                 divM(:,:,i2,i1,1:2) = -( cat(3,...
% %                     IFFT2(Lambda{1}.*yhat11(:,:,i2,i1)) + IFFT2(Lambda{2}.*yhat12(:,:,i2,i1)),...
% %                     IFFT2(Lambda{1}.*yhat21(:,:,i2,i1)) + IFFT2(Lambda{2}.*yhat22(:,:,i2,i1)) ) );
% %             end
% %         end
% 
%     otherwise
%         error('ERROR: not YET implemented')
% end
%        
% 
% return