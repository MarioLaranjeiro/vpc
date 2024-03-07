function [img1] = ImageFilter(img0, h)

% ====================== Processamento do Filtro h ========================
% Dimensões do Filtro h
ysize_h = size(h,1);
xsize_h = size(h,2);

% Cálculo do SVD
[U, S, V] = svd(h);

% Contagem de Elementos Singulares Não Nulos (Maiores que um Threshold)
num_nonzero = sum(abs(diag(S)) > 1e-10); 


% ================= Convolução do Filtro h e Imagem img0 ==================
% Dimensões da Imagem img0 
ysize_img0 = size(img0,1);
xsize_img0 = size(img0,2);

% Padding da Imagem img0 
img0_bord = padarray(img0,floor([ysize_h/2 xsize_h/2]),'replicate','both');

% Convolução da Imagem img0
if num_nonzero == 1 % --> Se Filtro h Separável ---------------------------
    
    disp('É separável');
        
    % Inicialização da Imagem img_conv_h e img_conv_hv
    img_conv_h = zeros(ysize_img0,xsize_img0);
    img_conv_hv = zeros(ysize_img0,xsize_img0);
    
    % Extração das Matrizes Unidimensionais h_vert e h_hori
    h_hori = sqrt(S(1,1)) * V(:,1)';
    h_vert = sqrt(S(1,1)) * U(:,1);

    % Replicação da Matrizes Unidimensionais h_vert
    h_hori_rep = repmat(h_hori,size(img0,1),1);
    % Convolução Horizontal 
    for i=1:xsize_img0
        img_conv_h(:,i) = sum(h_hori_rep.*img0_bord(1+1:1+ysize_img0,i:i+xsize_h-1),2);
    end


    % Replicação da Matrizes Convolução Horizontal
    img_conv_h_bord = padarray(img_conv_h,floor([ysize_h/2 xsize_h/2]),'replicate','both');

    % Replicação da Matrizes Unidimensionais h_hori
    h_vert_rep = repmat(h_vert,1,size(img_conv_h,2));
    % Convolução Vertical
    for i=1:ysize_img0
        img_conv_hv(i,:) = sum(h_vert_rep.*img_conv_h_bord(i:i+ysize_h-1,1+1:1+xsize_img0),1);
    end        
    
    % Resultado Final da Convolução
    imagem_final = img_conv_hv;


else    % --> Se Filtro h Não Separável -----------------------------------
    
    disp('Não é separável');
    
    % Inicialização da Imagem img_conv
    img_conv = zeros(ysize_img0,xsize_img0);
    
    % Convolução Vertical e Horizontal
    for i=1:ysize_img0
        for j=1:xsize_img0
            img_conv(i,j) = sum(h.*img0_bord(i:i+ysize_h-1,j:j+xsize_h2-1),'all');
        end
    end
    
    % Resultado Final da Convolução
    imagem_final = img_conv;


end


img1 = imagem_final;

end

 