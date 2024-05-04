function f = fminGoldRadial(p, xy, XYZ, w)

%reassemble P
P = [p(1:4);p(5:8);p(9:12)];

% Extract the camera intrinsic matrix K and distortion coefficients Kd
Kd = [p(13) p(14)];
[K, R, C] = decomposeQR(P);

%compute squared geometric error with radial distortion

% Compute the transformed 2D point coordinates
xy_new = inv(K)*xy;

% Compute the ideal 2D point coordinates with radial distortion
XYZ(4,:) = 1;
xyz = [R -R*C]*[XYZ];
xy_ideal = xyz(1:2,:)./xyz(3,:);
r = sqrt(xy_ideal(1,:).^2 + xy_ideal(2,:).^2);
L = 1 + Kd(1)*r.^2 + Kd(2)*r.^4;
xy_d = L.*xy_ideal;
xy_d(3,:) = 1;

%compute cost function value
diff = xy_d - xy_new;
f = (diff(:)'*diff(:)) / size(xy,2);

end

