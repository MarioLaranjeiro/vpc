function [ K, R, C ] = decomposeEXP(P)
%decompose P into K, R and t

A = P(1:3,1:3);
b = P(1:3,4);

% Compute the camera center C
C = -inv(A)*b;

a1 = A(1,1:3);
a2 = A(2,1:3);
a3 = A(3,1:3);

eps = 1; % +/- 1

rho = eps / norm(a3);
r3 = rho * a3;
u0 = (rho^2) * dot(a1,a3);
v0 = (rho^2) * dot(a2,a3);

eps_u = 1;
eps_v = 1;

cos_theta = -eps_u * eps_v * dot(cross(a1,a3),cross(a2,a3))/(norm(cross(a1,a3))*norm(cross(a2,a3)));
theta = acos(cos_theta);
alpha = eps_u * rho^2 * norm(cross(a1,a3)) * sin(theta);
beta = eps_v * rho^2 * norm(cross(a2,a3)) * sin(theta);

r1 = (1/norm((cross(a2,a3))))*cross(a2,a3);
r2 = cross(r3,r1);

% Compute K and R
K = [alpha -alpha*cot(theta) u0; 
     0 beta/sin(theta) v0;
     0 0 1];
R = [r1; r2; r3];

end