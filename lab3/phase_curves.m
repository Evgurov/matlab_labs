clc;clear;
A1 = [2, 1; 1, 4];
A2 = [1, 0; 0, 1];
A3 = [-1, 0; 0, 1];
A4 = [0, 4; -1, -1];
A5 = [0, 1; -1/50, 0];

A = A4;
t0 = 30;
T = linspace(0, 2*pi, 100);
for i = T
    [t, x] = ode45(@(t, x) syst(t,x,A), [0 t0], [sin(i); cos(i)]);
    plot(x(:, 1), x(:, 2));
    hold on;
    quiver(x(10, 1), x(10, 2), x(11, 1) - x(10, 1), x(11, 2) - x(10, 2), 'k', 'MaxHeadSize', 5);
end
grid on;
axis equal;
axis([-10 10 -10 10]);

function dxdt = syst(t,x,A)
    dxdt = zeros(2,1);
    dxdt(1) = A(1,1) * x(1) + A(1,2) * x(2);
    dxdt(2) = A(2,1) * x(1) + A(2,2) * x(2);
end