function [xyn, XYZn, T, U] = normalization(xy, XYZ)

%data normalization
% homogenize the points
xy(3,:) = 1;
XYZ(4,:) = 1;

% compute centroid
xy_centroid = mean(xy, 2);
XYZ_centroid = mean(XYZ, 2);

% compute scale
xyn = xy - xy_centroid;
XYZn = XYZ - XYZ_centroid;
xy_distances = sqrt(xyn(1,:).^2 + xyn(2,:).^2);
XYZ_distances = sqrt(XYZn(1,:).^2 + XYZn(2,:).^2 + XYZn(3,:).^2);
xy_scale = mean(xy_distances) / sqrt(2);
XYZ_scale = mean(XYZ_distances) / sqrt(3);

% create T and U transformation matrices
T = inv([xy_scale 0 xy_centroid(1);
         0 xy_scale xy_centroid(2);
         0 0 1]);
U = inv([XYZ_scale 0 0 XYZ_centroid(1);
         0 XYZ_scale 0 XYZ_centroid(2);
         0 0 XYZ_scale XYZ_centroid(3);
         0 0 0 1]);

% normalize the points according to the transformations
xyn = T * xy;
XYZn = U * XYZ;
xyn(3,:) = 1;
XYZn(4,:) = 1;

end