 
close all;

IMG_NAME = 'images/image001.jpg';
img_I = imread(IMG_NAME);
image(img_I);
%axis off
axis image
%|||||||||||||||||||||||||||||||||||||||||||||Descomentar a linha do algoritmo que se quer testar|||||||||||||||||||||||||||||||||||||||||||||||||||||||||


D_type = 'QR';
%D_type = 'EXP';
%[xy, XYZ] = getpoints(IMG_NAME);

%% === DLT algorithm ===

[K, R, t, error] = runDLT(xy, XYZ, D_type);

%% ===  Gold algorithm ===

%[K, R, t, error] = runGold(xy, XYZ, D_type);

%% === Gold algorithm w radial distortion estimation ===

%[K, R, t, Kd, error] = runGoldRadial(xy, XYZ, D_type);

 
