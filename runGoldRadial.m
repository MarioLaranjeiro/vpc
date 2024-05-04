function [K, R, t, Kd, error] = runGoldRadial(xy, XYZ, Dec_type)
% Função para executar a otimização da DLT com distorção radial usando busca áurea.

% Normalizar os pontos de dados
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

% Calcular a DLT
[Pn] = dlt(xy_normalized, XYZ_normalized);

% Valores iniciais dos coeficientes de distorção
Kd = [0 0];

% Minimizar o erro geométrico
pn = [Pn(1, :) Pn(2, :) Pn(3, :) Kd];
for i = 1:20
    [pn] = fminsearch(@fminGoldRadial, pn, [], xy_normalized, XYZ_normalized);
end

P = [pn(1:4); pn(5:8); pn(9:12)];
Kd = [pn(13), pn(14)];

% Denormalizar a matriz da câmera
M = inv(T) * P * U;

% Fatorar a matriz da câmera em K, R e t
if Dec_type == "QR"
    [K, R, C] = decomposeQR(M);
elseif Dec_type == "EXP"
    [K, R, C] = decomposeEXP(M);
else
    disp('Erro: Tipo de decomposição inválido');
end
t = -R * C; % Calcular o vetor de translação

% Calcular o erro de reprojeção
XYZ(4, :) = 1;
xyz = [R, t] * (XYZ);
xy_ideal = xyz(1:2, :) ./ xyz(3, :);

r = sqrt(xy_ideal(1, :).^2 + xy_ideal(2, :).^2);
L = 1 + Kd(1) * r.^2 + Kd(2) * r.^4;

xy_d = L .* xy_ideal;
xy_d(3, :) = 1;

xy_reprojection = K * xy_d;
xy_reprojection = xy_reprojection ./ xy_reprojection(3, :);

% Plotar os pontos originais e os pontos reprojetados na imagem
IMG_NAME = 'images/image001.jpg'; % Nome do arquivo de imagem
img_I = imread(IMG_NAME); % Ler a imagem
imshow(img_I); % Mostrar a imagem
hold on;
plot(xy(1, :), xy(2, :), 'rx', 'LineWidth', 1, 'MarkerSize', 10); % Plotar os pontos originais
plot(xy_reprojection(1, :), xy_reprojection(2, :), 'bo', 'Color', 'y', 'LineWidth', 2, 'MarkerSize', 10); % Plotar os pontos reprojetados
error = sum(sqrt(sum((xy_reprojection(1:2, :) - xy).^2, 1)).^2) / size(xy, 2); % Calcular o erro de reprojeção
end
