function [result, result_svp, result_svm] = minsv(st, fn)
    if (nargin < 2)
        % fn can be used to modify the magnitude of the returned vectors
        % depending on the large and small singular values of the matrix
        fn = @(larger_sv, smaller_sv)(ones(size(larger_sv)));
    end

    st = reshape(st,size(st,1),2,2); % reshape into matrix form
    
    a = st(:,1,1);
    b = st(:,1,2);
    c = st(:,2,1);
    d = st(:,2,2);
    
    abcd = a.^2+b.^2+c.^2+d.^2;
    
    discr = sqrt(abcd.^2 - 4 * (b.*c - a.*d).^2);
    
    
    svm = sqrt(0.5 * (abcd - discr));  % smaller singular value
    svp = sqrt(0.5 * (abcd + discr));  % larger singular value
    
    % for minimal eigenvalue
    result = [a.^2-b.^2+c.^2-d.^2 - discr,...
              2*(a.*b + c.*d)];
          
    % for maximal eigenvalue      
    %result = [a.^2-b.^2+c.^2-d.^2 + discr,...
    %           2*(a.*b + c.*d)];
          
    result = normalize(result')';
    
    factors = fn(svp, svm);
    
    result = result .* factors(:,[1 1]);
    
    if (nargout > 1)
        result_svp = svp;
        if (nargout > 2)
            result_svm = svm;
        end
    end
end
