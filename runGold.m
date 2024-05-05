function [K, R, t, error] = runGold(xy, XYZ, Dec_type)
% Função para executar a otimização da DLT usando busca áurea.

% Normalizar os pontos de dados
[xy_norm, XYZ_norm, T, U] = normalization(xy, XYZ);

% Calcular a DLT
[Pn] = dlt(xy_norm, XYZ_norm);

% Minimizar o erro geométrico
pn = [Pn(1, :) Pn(2, :) Pn(3, :)];
for i = 1:20
    [pn] = fminsearch(@fminGold, pn, [], xy_norm, XYZ_norm);
end

P = [pn(1:4); pn(5:8); pn(9:12)];

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
n = size(XYZ, 2);
xy_reprojection = zeros(2, n);

for i = 1:n
    xy_reprojection(1, i) = (M(1, :) * [XYZ(:, i); 1]) / (M(3, :) * [XYZ(:, i); 1]);
    xy_reprojection(2, i) = (M(2, :) * [XYZ(:, i); 1]) / (M(3, :) * [XYZ(:, i); 1]);
end

% Plotar os pontos originais e os pontos reprojetados na imagem
IMG_NAME = 'images/image001.jpg'; % Nome do arquivo de imagem
img_I = imread(IMG_NAME); % Ler a imagem
imshow(img_I); % Mostrar a imagem
hold on;
plot(xy(1, :), xy(2, :), 'rx', 'LineWidth', 1, 'MarkerSize', 10); % pontos originais
plot(xy_reprojection(1, :), xy_reprojection(2, :), 'bo', 'Color', 'g', 'LineWidth', 2, 'MarkerSize', 10); % pontos reprojetados
error = sum(sqrt(sum((xy_reprojection - xy).^2, 1)).^2) / size(xy, 2); % Calcular o erro de reprojeção
end
