clear; clc;
Xa = rand(3) * 3;
Ya = rand(3) * 4;
A = complex(Xa, Ya);
Xb = rand(3) * 2;
Yb = rand(3) * 6;
B = complex(Xb, Yb);
Xc = rand(3) * 8;
Yc = rand(3) * 4;
C = complex(Xc, Yc);
X1c = zeros(3);
X2c = zeros(3);
X3c = zeros(3);
X4c = zeros(3);
[X1c, X2c, X3c, X4c] = biquadsolve(A, B, C);
X1c
X2c
X3c
X4c
% D = B.^2 - 4 * A .* C;
% X1m = sqrt((-B - sqrt(D))./(2 * A))
% X2m = -sqrt((-B - sqrt(D))./(2 * A))
% X3m = sqrt((-B + sqrt(D))./(2 * A))
% X4m = -sqrt((-B + sqrt(D))./(2 * A))

R1 = A.*X1c.^4 + B.*X1c.^2 + C
R2 = A.*X2c.^4 + B.*X2c.^2 + C
R3 = A.*X3c.^4 + B.*X3c.^2 + C
R4 = A.*X4c.^4 + B.*X4c.^2 + C