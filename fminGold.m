function f = fminGold(p, xy, XYZ, w)
% Função para calcular a função de custo para otimização com o método de
% busca áurea.

% Rearranjar p em uma matriz de projeção P
P = [p(1:4); p(5:8); p(9:12)];

% Calcular o erro geométrico ao quadrado
n = size(XYZ, 2);
xy_reprojected = zeros(2, n);

for i = 1:n
    % Projetar os pontos 3D para o plano da imagem
    xy_reprojected(1, i) = (P(1, :) * XYZ(:, i)) / (P(3, :) * XYZ(:, i));
    xy_reprojected(2, i) = (P(2, :) * XYZ(:, i)) / (P(3, :) * XYZ(:, i));
end

% Calcular o valor da função de custo
f = sum(sqrt(sum((xy_reprojected - xy(1:2, :)).^2, 1)).^2) / size(xy, 2);
end
