function [K, R, t, error] = runGold(xy, XYZ, Dec_type)

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ); % (Como no runDLT)

%compute DLT
[Pn] = dlt(xy_normalized, XYZ_normalized);

%minimize geometric error
pn = [Pn(1,:) Pn(2,:) Pn(3,:)];
for i=1:20
    [pn] = fminsearch(@fminGold, pn, [], xy_normalized, XYZ_normalized);
end

P = [pn(1:4);pn(5:8);pn(9:12)];

%denormalize camera matrix
M = inv(T) * P * U;

%factorize camera matrix in to K, R and t (Como no runDLT)
if Dec_type == "QR"
   [K, R, C] = decomposeQR(M); 
elseif Dec_type == "EXP"
   [K, R, C] = decomposeEXP(M);
else
    disp('Error');
end
t=-R*C;

%compute reprojection error
n = size(XYZ,2);
xy_reprojection = zeros(2,n);

for i = 1:n
    xy_reprojection(1,i) = (M(1,:)* [XYZ(:,i);1])/(M(3,:) * [XYZ(:,i);1]);
    xy_reprojection(2,i) = (M(2,:)* [XYZ(:,i);1])/(M(3,:) * [XYZ(:,i);1]);
end

IMG_NAME = 'images/image001.jpg';
img_I = imread(IMG_NAME);
imshow(img_I);
hold on;
plot(xy(1,:), xy(2,:), 'rx', 'LineWidth', 1, 'MarkerSize', 10);
plot(xy_reprojection(1,:), xy_reprojection(2,:), 'bo', 'Color', 'g', 'LineWidth', 2, 'MarkerSize', 10);
error = sum(sqrt(sum((xy_reprojection-xy).^2,1)).^2)/ size(xy,2);

end