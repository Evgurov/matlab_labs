%% 1-2
clear; clc;
f1 = @(x) sqrt(x) .* sin(x);
f2 = @(x) exp(cos(x));
f3 = @(x) sin(x.*x);
f4 = @(x) floor(x);
a = 0;
b = 5;
nn = 10;
n = 100;
x = linspace(a, b, n);
xx = linspace (a, b, nn);
compareInterp(x,xx,f3);
%% 3
clear; clc;
nn = 10;
n = 100;
a = 0;
b = 4;
h = (b-a)/nn;
xx = linspace(a,b,nn);
x = linspace(a,b,n);
g1 = @(x) x.^3 - x.^2;
d2g1 = @(x) 6 * x - 2;
g2 = @(x) sin(20 * x);
d2g2 = @(x) -4 * sin(x);
maxDerivF1 = 22;
maxDerivF2 = 400;
aprErr1 = ones(size(x)) * maxDerivF1 * h^2;
aprErr2 = ones(size(x)) * maxDerivF2 * h^2;
apostErr1 = abs(g1(x) - interp1(xx, g1(xx), x, 'linear'));
apostErr2 = abs(g2(x) - interp1(xx, g2(xx), x, 'linear'));
subplot(2,1,1);
plot(x, aprErr1);
hold on;
plot(x, apostErr1);
title('Function f1');
hold off;
legend ('aprior mistake', 'aposterior mistake');
subplot(2,1,2);
plot (x, aprErr2);
hold on;
plot (x, apostErr2);
title('fuction f2');
hold off;
legend('aprior mistake', 'aposterior mistake');
%% 4
clear; clc;
f1n = @(x,n) n*x./(n+x.^n);
f1 = @(x) x;
f2n = @(x,n) 1 * double(x < 1/n);
f2 = @(x) 0 * x;
f3n = @(x,n) x.^n;
f3 = @(x) double(x>=0)*0+(x==1)*1;
convergenceFunc(f1n, f1, 0, 1, 20, 'uniform');
%% 5
clear; clc;
f1 = @(x) 1 * double(mod(floor(x), 2) == 0) + (-1) * double(mod(floor(x), 2) == 1);
f2 = @(x) x.^5;
f3 = @(x) sign(x);
f4 = @(x) abs(x);
f5 = @(x) sin(x.^2);
fourierApprox(f2, -3, 3, 10, 'cheb');
%% 6 *cometScript*
%% 7
clear; clc;
A = 1;
B = 1;
a = 1;
b = 2;
delta = pi/2;
f = @(t) A * sin(a * t + delta * ones(size(t)));
g = @(t) B * sin(b * t);
t0 = 0;
t1 = pi;
N = 10;
getEqual(f, g, t0, t1, N);
%% 8
clear;clc;
drawSet('rhombus', [0,1], 3, 2, 20);
%% 9
clear;clc;
f = @(x) (x(1))^2 + (x(2))^2 - 1;
rho = supportLebesgue(f);
%% 10
clc;clear;
f1 = @(x) abs(x(1)) + abs(x(2)) - 1;
f2 = @(x) abs(x(1) - 1) + abs(x(2) - 1) - 3;
f3 = @(x) (x(1)-1)^2 + (x(2)-1)^2 - 1;
f4 = @(x) (x(1))^2 + (x(2))^2/4 - 1;
rho = supportLebesgue(f2);
save('funfile','f2');
drawPolar(rho);
%% 13
clc;clear;
points = [-1, -1; 3, -2; 8, 2; -6, 5; -3, 1; 0, -6;-4, 6; 2, -7];
viewPossible(points, 10, 11);
%% 14
a = -3;
b = 3;
N = 20;
alpha = 2;
f = @(x, y, z) abs(x).^alpha + abs(y).^alpha + abs(z).^alpha;
params.f = f;
params.a = a;
params.b = b;
params.N = N;
params.isovalue = 50;
params.FaceColor = 'blue';
params.EdgeColor = 'red';
drawBall(params);
%% 15
alphas = 1:1:5;
colors = ["black", "red", "blue", "green", "yellow"];
edges = ["none", "blue", "green", "red", "black"];
drawManyBalls(alphas, colors, edges);