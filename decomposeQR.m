function [ K, R, C ] = decomposeQR(P)
% Função para decompor a matriz de projeção P em K (matriz de calibração),
% R (matriz de rotação) e C (vetor de translação do Centro da câmera).

% Extrair a submatriz esquerda 3x3 de P
S = P(:, 1:3);
inv_S = inv(S);

% Calcular a decomposição QR de S^(-1)
[Q_qr, R_qr] = qr(inv_S);

% Calcular K e R
K = inv(R_qr);
K = K ./ K(end, end); % Normalizar K
R = inv(Q_qr);

% Calcular o centro da câmera C pela ultima coluna de SVD
[~, ~, V] = svd(P);
C_matrix = V(:, end);

% Normalizar C_matrix pelo último elemento
C = [C_matrix(1) / C_matrix(4);
     C_matrix(2) / C_matrix(4);
     C_matrix(3) / C_matrix(4)];
