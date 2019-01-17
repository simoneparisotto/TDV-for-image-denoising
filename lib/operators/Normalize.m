function w = Normalize(v)

epsilon = 1e-15;
%epsilon = 0;
NormEps   = @(z,epsilon) sqrt(epsilon^2 + z(:,:,1).^2 + z(:,:,2).^2);

w = v ./ repmat(NormEps(v,epsilon),[1 1 2]);

%w(isnan(w)) = v(isnan(w));


%index = (prod(v,3)==0);


%v = padarray(v(2:end-1,2:end-1,:),[1 1],'replicate','both');
%v(end,:,:) = v(end-1,:,:);
%v(:,end,:) = v(:,end-1,:);
%rr = rand(numel(index),1);
%v(index) = rr;

return
