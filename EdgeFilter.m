function [img1] = EdgeFilter(img0, sigma)

% Dimensões da Imagem
lin = size(img0,1);
col = size(img0,2);

% Definição do Tamanho do Filtro Gaussiano
hsize = 2 * ceil(3 * sigma) + 1;

% Definição dos Filtros
g_f = fspecial('gaussian', hsize, sigma);   % Filtro Gaussiano
s_v = fspecial('sobel');                    % Filtro de Sobel - Vertical
s_h = s_v';                                 % Filtro de Sobel - Horizontal

% Filtragem da Imagem img0 com o Filtro Gaussian
Img_gf= ImageFilter(img0, g_f);

% Filtragem da Imagem Img_gf com os Filtros de Sobel (Vertical e Horizontal)
Img_vf = ImageFilter(Img_gf, s_v);   % Gradiente em y
Img_hf = ImageFilter(Img_gf, s_h);   % Gradiente em x

% Cálculo da Magnitude, Orientação do Gradiente e Ajuste para uma Orientação sempre Positiva
Mag = sqrt(Img_hf.^2 + Img_vf.^2);
Theta = rad2deg(atan2(Img_vf, Img_hf));
Theta(Theta < 0) = Theta(Theta < 0) + 180;

% Criação de Matriz Auxiliar de Orientação
Theta_Aux = zeros(lin, col);

% Mapeamento dos Ângulos para 0º, 45º, 90º e 135º para Theta_Aux
Theta_0 = ((Theta < 22.5) | (Theta > 157.5));
Theta_45 = ((Theta >= 22.5) & (Theta < 67.5));
Theta_90 = ((Theta >= 67.5 & Theta < 112.5));
Theta_135 = ((Theta >= 112.5 & Theta < 157.5));

Theta_Aux(Theta_0) = 0;
Theta_Aux(Theta_45) = 45;
Theta_Aux(Theta_90) = 90;
Theta_Aux(Theta_135) = 135;

% Criação de Matriz para Armazenamento de Píxeis Máximos
SNM = zeros (lin,col);

% Supressão Não-Máxima 
% Comparação de Intensidades de Píxeis Atuais com seus Vizinhos numa dada Orientação
for i = 2:lin-1
    for j = 2:col-1
        if (Theta_Aux(i,j) == 0)
            % Segundo 0 graus -- Atual com seus Vizinhos Horizontais --
            SNM(i,j) = (Mag(i,j) == max([Mag(i,j), Mag(i,j+1), Mag(i,j-1)]));
        elseif (Theta_Aux(i,j) == 45)
            % Segundo 45 graus -- Atual com seus Vizinhos Diagonais --
            SNM(i,j) = (Mag(i,j) == max([Mag(i,j), Mag(i+1,j-1), Mag(i-1,j+1)]));
        elseif (Theta_Aux(i,j) == 90)
            % Segundo 90 graus -- Atual com seus Vizinhos Verticais --
            SNM(i,j) = (Mag(i,j) == max([Mag(i,j), Mag(i+1,j), Mag(i-1,j)]));
        elseif (Theta_Aux(i,j) == 135)
            % Segundo 135 graus -- Atual com seus Vizinhos Diagonais --
            SNM(i,j) = (Mag(i,j) == max([Mag(i,j), Mag(i+1,j+1), Mag(i-1,j-1)]));
        end
    end
end

% Preservação da Intensidade da Borda
SNM = SNM.*Mag; 

% Declaração do Valor de Threshold Máximo e Mínimo
Th_Min = 0.15;
Th_Max = 0.18;

% Limiar de Histerese
Th_Min = Th_Min * max(max(SNM));
Th_Max = Th_Max * max(max(SNM));

% Criação de Matriz de Resolução de Threshold
T_res = zeros(lin, col);

% Binarização da Imagem segundo o Intervalo de Threshold
for i = 1:lin
    for j = 1:col
        if (SNM(i, j) < Th_Min) % Abaixo de Th_Min declara-se a 0
            T_res(i, j) = 1;
        elseif (SNM(i, j) > Th_Max)
            T_res(i, j) = 0;    % Abaixo de Th_max declara-se a 1
        elseif (SNM(i+1,j)>Th_Max || SNM(i-1,j)>Th_Max ...
                || SNM(i,j+1)>Th_Max || SNM(i,j-1)>Th_Max...
                || SNM(i-1, j-1)>Th_Max || SNM(i-1, j+1)>Th_Max...
                || SNM(i+1, j+1)>Th_Max || SNM(i+1, j-1)>Th_Max)
            T_res(i,j) = 0;     % Abaixo de Th_max declara-se a 1 tendo em Conta os Vizinhos do Pixel Atual
        end
    end
end

% Mapeamento da Imagem para a Escala de 0 - 255 
img1 = uint8(T_res.*255);



end
          
       