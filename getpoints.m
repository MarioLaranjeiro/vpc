function [xy, XYZ] = getpoints(img)
% Função para obter pontos em uma imagem e suas coordenadas 3D correspondentes.

% Inicialmente, a lista de pontos está vazia.
xy = [];
XYZ = [];
n = 0;

% Loop para selecionar os pontos.
disp('Pressione o botão esquerdo do mouse para selecionar pontos.')
disp('Pressione o botão direito do mouse para finalizar a seleção.')
zoom on;
but = 1;
while but == 1
    [xi, yi, but] = ginput(1); % Captura as coordenadas (x, y) do clique do mouse
    hold on;
    plot(xi, yi, 'ro') % Plota um ponto vermelho na posição selecionada
    hold off;
    n = n + 1;
    xy(:, n) = [xi; yi]; % Adiciona um novo ponto à lista de pontos 2D
    input = inputdlg('[X Y Z]'); % Mostra uma caixa de diálogo para inserir as coordenadas 3D
    XYZi = str2num(input{1}); % Converte as coordenadas 3D de string para números
    XYZ(:, n) = XYZi; % Adiciona um novo ponto à lista de pontos 3D
end
end
