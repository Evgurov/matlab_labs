%% 1
clear;clc;
inf = 10000;
S = 0;
N = 100;
SnMas(N) = 0;
for n = 1:inf
    S = S + 1/(n * factorial(n));
    if n <= N
        SnMas(n) = S;
    end
end 
grid = linspace(1, N, N);
plot(grid, SnMas - S);
hold on;
psi = ones(1, N) ./ grid;
plot(grid, psi, 'r');
hold off;
legend ('S(n) - S', 'error estimation')
%% 2
clear;clc;
fun = @(x) sqrt(x) - tan(x);
grid = linspace(0, 10, 1000);
hold on;
plot(grid, sqrt(grid), 'b');
plot(grid, tan(grid), 'r');
x0 = ginput(10);
for i = 1:size(x0, 1)
    plot(x0(i, 1), x0(i, 2), '*r');
    options = optimset('Display','iter');
    approx_root = fzero(fun, x0(i, 1), options);
    discrepancy = fun(approx_root);
    fprintf(num2str(x0(i, 1)));
    fprintf('\n');
    fprintf(num2str(approx_root));
    fprintf('\n');
    fprintf(num2str(discrepancy));
    fprintf('\n');  
    plot(approx_root, sqrt(approx_root), 's', 'MarkerFaceColor', 'green', 'MarkerSize', 8);
end
hold off;
%% 9
clear;clc;
f = @(x) x(1)^2 + x(2)^2 + x(1)^2 * x(2)^2 + exp(x(1)^2 + x(2)^2);
gradf = @(x) [2 * x(1) + 2 * x(1) * x(2)^2 + exp(x(1)^2 + x(2)^2) * 2 * x(1)
             2 * x(2) + 2 * x(2) * x(1)^2 + exp(x(1)^2 + x(2)^2) * 2 * x(2)];
gessianf = @(x)[2 + 2 * x(2)^2 + 2 * exp(x(1)^2 + x(2)^2) * 2 * x(1) * x(1) + 2 * exp(x(1)^2 + x(2)^2), 2 * x(1) * 2 * x(2) + exp(x(1)^2 + x(2)^2) * 2 * x(1) * 2 * x(2)
           2 * x(2) * 2 * x(1) + exp(x(1)^2 + x(2)^2) * 2 * x(2) * 2 * x(1), 2 + 2 * x(1)^2 + exp(x(1)^2 + x(2)^2) * 2 * x(2) * 2 * x(2) + exp(x(1)^2 + x(2)^2) * 2];
x_startf = [-3; 4];

g = @(x) sin(x(1)) * cos(x(2)) + x(1)^2 + x(2)^4;
gradg = @(x) [cos(x(1)) * cos(x(2)) + 2 * x(1)
               sin(x(1)) * -sin(x(2)) + 4 * x(2)^3];
gessiang = @(x) [-sin(x(1)) * cos(x(2)) + 2, cos(x(1)) * -sin(x(2))
                   cos(x(1)) * -sin(x(2)), sin(x(1)) * -cos(x(2)) + 12 * x(2)^2];
x_startg = [2,3];
[xmin,fmin] = Newton_min(g, gradg, gessiang, x_startg, 1e-3);

h = @(x) x^2 + sin(x);
gradh = @(x) 2*x + cos(x);
gessianh = @(x) 2 - sin(x);
x_starth = 1;
[xminNewton, fminNewton] = Newton_min(h, gradh, gessianh, x_starth, 0.01);
xminbnd = fminbnd(h, -9, 9);
xminNewton
xminbnd
%% 10
clear;clc;
original_function_figure = figure('Name', 'Original function', 'NumberTitle', 'off');
step = 0.1;
inpLims = [-10, 10];
outLims = [-100, 100];
grid = linspace(inpLims(1), inpLims(2), 1000);
plot (grid, func4(grid));
title('Original function plot');
transform_function_figure = figure('Name', 'Fourier transform', 'NumberTitle', 'off');
plotFT(transform_function_figure, @func4, [], step, inpLims, outLims);

function val = func1(t)
    val = (ones(size(t)) - (cos(t)).^2) ./ t;
end

function val = FTfunc1(h)
    real = zeros(size(h));
    imaginary =  pi/4 * (sign(h-2) - 2 * sign(h) + sign(h+2));
    val = complex(real, imaginary);
end

function val = func2(t)
    val = t .* exp((-2) * t.^2);
end

function val = FTfunc2(h)
    real = zeros(size(h));
    imaginary =  -sqrt(pi/2) * h/4 .* exp(-h.^2/8);
    val = complex(real, imaginary);
end

function val = func3(t)
    val = 2 * ones(size(t)) ./ (ones(size(t)) - 3 * t.^6);
end

function val = func4(t)
    val = exp(-5 * abs(t)) .* log(3 * ones(size(t)) + t.^4);
end