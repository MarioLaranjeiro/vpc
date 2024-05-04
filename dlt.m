function [P] = dlt(xy, XYZ)
% Função para calcular a DLT (Direct Linear Transformation).
% Os pontos xy e XYZ devem ser normalizados antes de chamar esta função.

% Construir a matriz A
n = size(xy, 2);
A = zeros(2 * n, 12);
w = 1;

for i = 1:n
    % Preencher as linhas pares e ímpares de A
    A(2 * i - 1, :) = [w * XYZ(:, i)', 0, 0, 0, 0, -xy(1, i) * XYZ(:, i)'];
    A(2 * i, :) = [0, 0, 0, 0, w * XYZ(:, i)', -xy(2, i) * XYZ(:, i)'];
end

% Resolver para P usando SVD
[~, ~, V] = svd(A);
P = reshape(V(:, end), 4, 3)'; % Reformular o vetor coluna em uma matriz 4x3
end
