function [ K, R, C ] = decomposeQR(P)
%decompose P into K, R and t

% Extract the left 3x3 submatrix of P
S = P(:,1:3);
inv_S = inv(S);

% Compute the QR decomposition of S^(-1)
[Q_qr, R_qr] = qr(inv_S);

% Compute K and R
K = inv(R_qr);
K = K./K(end,end);
R = inv(Q_qr);

% Compute the camera center C
[~,~,V] = svd(P);
C_matrix = V(:,end);

C = [C_matrix(1)/C_matrix(4);
     C_matrix(2)/C_matrix(4);
     C_matrix(3)/C_matrix(4)];

end