function [xy, XYZ] = getpoints(img)
% Função para obter pontos e suas coordenadas 3D correspondentes.

%  lista de pontos  vazia 
xy = [];
XYZ = [];
n = 0;

 
disp('Pressione o botão esquerdo do mouse para selecionar pontos.')
disp('Pressione o botão direito do mouse para finalizar a seleção.')
zoom on;

a = 1;
while a == 1
    [xi, yi, but] = ginput(1); % Captura as coordenadas (x, y)  
    hold on;
    plot(xi, yi, 'ro') % Plota um ponto vermelho na posição selecionada
    hold off;
    n = n + 1;
    xy(:, n) = [xi; yi]; % Adiciona um novo ponto à lista de pontos 2D
    input = inputdlg('[X Y Z]'); % Insere as coordenadas 3D
    XYZi = str2num(input{1}); % Converte  string para número 
    XYZ(:, n) = XYZi; % Adiciona o novo ponto à lista de pontos 3D
end
end
