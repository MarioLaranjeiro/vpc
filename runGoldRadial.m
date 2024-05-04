function [K, R, t, Kd, error] = runGoldRadial(xy, XYZ, Dec_type)

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ); % (Como no runDLT)

%compute DLT
[Pn] = dlt(xy_normalized, XYZ_normalized);

% Distortion Coeficient Initial Values
Kd= [0 0];

%minimize geometric error
pn = [Pn(1,:) Pn(2,:) Pn(3,:) Kd];
for i=1:20
    [pn] = fminsearch(@fminGoldRadial, pn, [], xy_normalized, XYZ_normalized);
end

P = [pn(1:4);pn(5:8);pn(9:12)];
Kd = [pn(13) pn(14)];

%denormalize camera matrix
M = inv(T) * P *U;

%factorize camera matrix in to K, R and t
if Dec_type == "QR"
   [K, R, C] = decomposeQR(M); 
elseif Dec_type == "EXP"
   [K, R, C] = decomposeEXP(M);
else
    disp('Error');
end
t=-R*C;

%compute reprojection error
XYZ(4,:)=1;
xyz = [R t] * (XYZ);
xy_ideal = xyz(1:2,:)./xyz(3,:);

r = sqrt(xy_ideal(1,:).^2 + xy_ideal(2,:).^2);
L = 1 + Kd(1)*r.^2 + Kd(2)*r.^4;

xy_d = L.*xy_ideal;
xy_d(3,:) = 1;

xy_reprojection = K * xy_d;
xy_reprojection = xy_reprojection./xy_reprojection(3,:);

IMG_NAME = 'images/image001.jpg';
img_I = imread(IMG_NAME);
imshow(img_I);
hold on;
plot(xy(1,:), xy(2,:), 'rx', 'LineWidth', 1, 'MarkerSize', 10);
plot(xy_reprojection(1,:), xy_reprojection(2,:), 'bo', 'Color', 'y', 'LineWidth', 2, 'MarkerSize', 10);
error = sum(sqrt(sum((xy_reprojection(1:2,:)-xy).^2,1)).^2)/ size(xy,2);

end