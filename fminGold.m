function f = fminGold(p, xy, XYZ, w)

%reassemble P
P = [p(1:4);p(5:8);p(9:12)];

%compute squared geometric error
n = size(XYZ, 2);
xy_reprojected = zeros(2,n);

for i = 1:n
    xy_reprojected(1,i) = (P(1,:)* XYZ(:,i))/(P(3,:) * XYZ(:,i));
    xy_reprojected(2,i) = (P(2,:)* XYZ(:,i))/(P(3,:) * XYZ(:,i));
end

%compute cost function value
f = sum(sqrt(sum((xy_reprojected-xy(1:2,:)).^2,1)).^2)/ size(xy,2);

end
