function [xyn, XYZn, T, U] = normalization(xy, XYZ)
% Função para normalizar os pontos 2D e 3D.

% Normalização dos dados
% Tornar os pontos homogêneos
xy(3, :) = 1;
XYZ(4, :) = 1;

% Calcular o centróide
xy_centroid = mean(xy, 2);
XYZ_centroid = mean(XYZ, 2);

% Calcular a escala
xyn = xy - xy_centroid;
XYZn = XYZ - XYZ_centroid;
xy_dist= sqrt(xyn(1, :).^2 + xyn(2, :).^2);
XYZ_dist = sqrt(XYZn(1, :).^2 + XYZn(2, :).^2 + XYZn(3, :).^2);
xy_scale = mean(xy_distances) / sqrt(2);
XYZ_scale = mean(XYZ_distances) / sqrt(3);

% Criar as matrizes de transformação T e U
T = inv([xy_scale, 0, xy_centroid(1);
         0, xy_scale, xy_centroid(2);
         0, 0, 1]);
U = inv([XYZ_scale, 0, 0, XYZ_centroid(1);
         0, XYZ_scale, 0, XYZ_centroid(2);
         0, 0, XYZ_scale, XYZ_centroid(3);
         0, 0, 0, 1]);

% Normalizar os pontos de acordo com as transformações
xyn = T * xy;
XYZn = U * XYZ;
xyn(3, :) = 1;
XYZn(4, :) = 1;

end
