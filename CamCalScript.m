 
close all;

IMG_NAME = 'images/image001.jpg';
img_I = imread(IMG_NAME);
image(img_I);
%axis off
axis image

% Decomposition Approach
D_type = 'QR';
%D_type = 'EXP';

 
%[xy, XYZ] = getpoints(IMG_NAME);

%% === Task 2 DLT algorithm ===

[K, R, t, error] = runDLT(xy, XYZ, D_type);

%% === Task 3 Gold algorithm ===

%[K, R, t, error] = runGold(xy, XYZ, D_type);

%% === Task 4 Gold algorithm with radial distortion estimation ===

%[K, R, t, Kd, error] = runGoldRadial(xy, XYZ, D_type);

 
