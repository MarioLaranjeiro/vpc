function fcost = fminGoldRadial(p, xy, XYZ, w)
 

% Rearranjar p na matriz de projeção P
P = [p(1:4); p(5:8); p(9:12)];

% Extrair a matriz intrínseca da câmera K e os coeficientes de distorção radial Kd
Kd = [p(13), p(14)];
[K, R, C] = decomposeQR(P);
 
% Calcular as coordenadas 2D transformadas
xy_trans = inv(K) * xy;

% Calcular as coordenadas ideais 2D com distorção radial
XYZ(4, :) = 1;
xyz = [R, -R * C] * [XYZ];
xy_ideal = xyz(1:2, :) ./ xyz(3, :);
r = sqrt(xy_ideal(1, :).^2 + xy_ideal(2, :).^2);
L = 1 + Kd(1) * r.^2 + Kd(2) * r.^4;
xy_d = L .* xy_ideal;
xy_d(3, :) = 1;

% Calcular o valor da função de custo
diff = xy_d - xy_trans;
fcost = (diff(:)' * diff(:)) / size(xy, 2);
end
