function result = innerssq(A)
%INNERSSQ Sums of squares over inner dimension
    result = sum(A.^2,ndims(A));
end
