function [ K, R, C ] = decomposeEXP(P)
% Função para decompor a matriz de projeção P em K (matriz de calibração),
% R (matriz de rotação) e C (vetor de translação).

% Extrair a matriz de calibração A e o vetor de translação b de P
A = P(1:3, 1:3);
b = P(1:3, 4);

% Calcular o centro da câmera C
C = -inv(A) * b;

% Extrair os vetores de coluna de A para facilitar os cálculos
a1 = A(1, 1:3);
a2 = A(2, 1:3);
a3 = A(3, 1:3);

% Definir os valores de epsilon (±1) para facilitar os cálculos
eps = 1;

% Calcular o fator de escala rho
rho = eps / norm(a3);

% Calcular o vetor r3, que é uma versão escalada de a3
r3 = rho * a3;

% Calcular os parâmetros u0 e v0
u0 = (rho^2) * dot(a1, a3);
v0 = (rho^2) * dot(a2, a3);

% Definir os valores de epsilon_u e epsilon_v (±1)
eps_u = 1;
eps_v = 1;

% Calcular o ângulo theta entre os vetores a1 e a2
cos_theta = -eps_u * eps_v * dot(cross(a1, a3), cross(a2, a3)) / (norm(cross(a1, a3)) * norm(cross(a2, a3)));
theta = acos(cos_theta);

% Calcular os parâmetros alpha e beta
alpha = eps_u * rho^2 * norm(cross(a1, a3)) * sin(theta);
beta = eps_v * rho^2 * norm(cross(a2, a3)) * sin(theta);

% Calcular o vetor r1
r1 = (1 / norm(cross(a2, a3))) * cross(a2, a3);

% Calcular o vetor r2
r2 = cross(r3, r1);

% Construir a matriz de calibração K
K = [alpha, -alpha*cot(theta), u0; 
     0, beta/sin(theta), v0;
     0, 0, 1];

% Construir a matriz de rotação R com os vetores r1, r2 e r3
R = [r1; r2; r3];

end
