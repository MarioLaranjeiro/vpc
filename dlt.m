function [P] = dlt(xy, XYZ)
%computes DLT, xy and XYZ should be normalized before calling this function

% Construct matrix A
n = size(xy, 2);
A = zeros(2*n, 12);
w = 1;

for i = 1:n
    A(2*i-1,:) = [w*XYZ(:,i)' 0 0 0 0 -xy(1,i)*XYZ(:,i)'];
    A(2*i,:) =[0 0 0 0 w*XYZ(:,i)' -xy(2,i)*XYZ(:,i)'];
end

% Solve for P using SVD
[~, ~, V] = svd(A);
P = reshape(V(:,end), 4, 3)';

end