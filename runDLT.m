function [K, R, t, error] = runDLT(xy, XYZ, D_type)
% Função para executar a técnica de DLT (Direct Linear Transformation).

% Normalizar os pontos de dados
[xy_norm, XYZ_norm, T, U] = normalization(xy, XYZ);

% Calcular a DLT
[P_normalized] = dlt(xy_norm, XYZ_norm);

% Denormalizar a matriz da câmera
M = inv(T) * P_normalized * U;

% Fatorar a matriz da câmera em K, R e t
if D_type == "QR"
    [K, R, C] = decomposeQR(M);
elseif D_type == "EXP"
    [K, R, C] = decomposeEXP(M);
else
    disp('Erro: Tipo de decomposição inválido');
end
t = -R * C; % Calcular o vetor de translação

% Calcular o erro de reprojeção
n = size(XYZ, 2);
xy_reproj = zeros(2, n);

for i = 1:n
    xy_reproj (1, i) = (M(1, :) * [XYZ(:, i); 1]) / (M(3, :) * [XYZ(:, i); 1]);
    xy_reproj(2, i) = (M(2, :) * [XYZ(:, i); 1]) / (M(3, :) * [XYZ(:, i); 1]);
end

% Plotar os pontos originais e os pontos reprojetados na imagem
IMG_NAME = 'images/image001.jpg'; % Nome do arquivo de imagem
img_I = imread(IMG_NAME); % Ler a imagem
imshow(img_I); % Mostrar a imagem
hold on;
plot(xy(1, :), xy(2, :), 'rx', 'LineWidth', 1, 'MarkerSize', 10); % Plotar os pontos originais
plot(xy_reproj(1, :), xy_reproj(2, :), 'bo', 'LineWidth', 2, 'MarkerSize', 10); % Plotar os pontos reprojetados
error = sum(sqrt(sum((xy_reproj - xy).^2, 1)).^2) / size(xy, 2); % Calcular o erro de reprojeção
end
