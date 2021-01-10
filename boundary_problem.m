clc;clear;
f = @(x) exp(x) - 2;

grid = linspace(0, 1, 100);
solinit = bvpinit(grid, @guess);

sol = bvp4c(@bvpfcn, @bcfcn, solinit);

y = sol.y;
plot(sol.x, y(1,:));

L2_norm = sqrt(trapz(sol.x, abs(y(1,:) - f(sol.x))))
C_norm = max(abs(y(1,:) - f(sol.x)))

function dydx = bvpfcn(x,y)
    dydx = zeros(2,1);
    dydx = [y(2)
            y(2)];
end

function res = bcfcn(ya,yb)
    res = [ya(1) + 1
           yb(2) - yb(1) - 2];
end

function g = guess(x)
    g = [exp(x)
         exp(x)];
end